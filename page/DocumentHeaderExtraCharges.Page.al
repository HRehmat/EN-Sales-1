page 14229101 "Document Header Extra Charges"
{


    Caption = 'Document Header Extra Charges';

    DelayedInsert = false;
    PageType = List;
    ShowFilter = false;
    //ApplicationArea = all;
    //UsageCategory = Lists;
    SourceTable = "Document Extra Charge";

    layout
    {
        area(content)
        {
            repeater(Control37002001)
            {
                ShowCaption = false;
                field("Extra Charge Code"; "Extra Charge Code")
                {

                }
                field(Charge; Charge)
                {

                    trigger OnValidate()
                    begin
                        if InvoiceExistOnECSummary("Document No.", "Extra Charge Code") then
                            Error('Cannot change Extra Charge %1 after it has been Posted', "Extra Charge Code");
                    end;
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Allocation Method"; "Allocation Method")
                {

                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }



            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }


    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Allocate)
                {
                    Caption = 'Allocate';
                    Image = Allocate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        TransferHeader: Record "Transfer Header";
                        ExtraCharge: Record "Extra Charge";
                        DocExtraCharge: Record "Document Extra Charge";
                        ExtraChargeMgmt: Codeunit "Extra Charge Management";
                    begin

                        if not Evaluate(DocExtraCharge."Table ID", GetFilter("Table ID")) then
                            exit;
                        case DocExtraCharge."Table ID" of
                            DATABASE::"Purchase Header":
                                begin
                                    if not Evaluate(PurchaseHeader."Document Type", GetFilter("Document Type")) then
                                        exit;
                                    if not Evaluate(PurchaseHeader."No.", GetFilter("Document No.")) then
                                        exit;
                                    if not PurchaseHeader.Find('=') then
                                        exit;
                                    PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);

                                    ExtraChargeMgmt.AllocateChargesToLines(DocExtraCharge."Table ID", PurchaseHeader."Document Type",
                                      PurchaseHeader."No.", PurchaseHeader."Currency Code", ExtraCharge);
                                    Message('Charges were Allocated.');

                                end;
                        end;


                    end;
                }
                action("Update PO")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;
                    trigger OnAction()
                    begin

                        UserSetup.Get(UserId);
                        if UserSetup."Allow EC Button Use" = false
                          then
                            Error(Text50000);

                        UpdatePO;
                    end;
                }
                action("EC Update")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;
                    trigger OnAction()
                    begin

                        UserSetup.Get(UserId);
                        if UserSetup."Allow EC Button Use" = false
                          then
                            Error(Text50000);

                        CreateExtraChargeSummary;
                        CreateVendInv;
                    end;
                }
            }
        }
    }

    var
        Text001: Label 'Purchase %1 %2';
        Text002: Label 'Transfer Order %1';
        Text50000: Label 'You do not have permission to use this function.';
        UserSetup: Record "User Setup";


    procedure SetCaption(): Text[100]
    begin

        case "Table ID" of
            DATABASE::"Purchase Header":
                exit(StrSubstNo(Text001, "Document Type", "Document No."));
            DATABASE::"Transfer Header":
                exit(StrSubstNo(Text002, "Document No."));
        end;
    end;


    procedure CreateVendInv()
    var
        EXtraChargeMgmnt: Codeunit "Extra Charge Management";
        ExtraCharge: Record "Extra Charge";
        PurchHeader: Record "Purchase Header";
        DocExtraCharge: Record "Document Extra Charge";
    begin

        DocExtraCharge.Reset;
        ExtraCharge.Reset;
        PurchHeader.Reset;
        DocExtraCharge := Rec;
        DocExtraCharge.CopyFilters(Rec);
        DocExtraCharge.SetFilter("Vendor No.", '<>%1', '');
        if DocExtraCharge.Find('-') then begin
            repeat
                if ExtraCharge.Get(DocExtraCharge."Extra Charge Code") then begin
                    PurchHeader.Get(1, DocExtraCharge."Document No.");
                    if (InvoiceExistOnECSummary(DocExtraCharge."Document No.", DocExtraCharge."Extra Charge Code"))
                       or CheckIfPurchInvExist(DocExtraCharge."Vendor No.") then
                        UpdateExistingECInvoices(DocExtraCharge."Document No.")
                    else
                        CreateVendorInvoices(DocExtraCharge, DocExtraCharge."Document No.");
                end;
            until DocExtraCharge.Next = 0;
        end;
    end;


    procedure UpdatePO()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine1: Record "Purchase Line";
        ExtraChargePostingSetup: Record "Extra Charge Posting Setup";
        ExtraCharge: Record "Extra Charge";
        LineNo: Integer;
        DocExtraCharge: Record "Document Extra Charge";
        IC: Integer;
        MC: Integer;
    begin

        IC := 0;
        MC := 0;
        if PurchaseHeader.Get("Document Type"::Order, "Document No.") then begin
            DocExtraCharge.Reset;
            DocExtraCharge.SetRange("Document Type", PurchaseHeader."Document Type");
            DocExtraCharge.SetRange("Document No.", PurchaseHeader."No.");
            DocExtraCharge.SetRange("Line No.", 0);
            DocExtraCharge.SetFilter("Vendor No.", '%1', '');
            if DocExtraCharge.Find('-') then begin
                repeat
                    LineNo := 0;
                    PurchaseLine.Reset;
                    PurchaseLine.SetCurrentKey("Purch. Order for Extra Charge", "Extra Charge Code");
                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.SetRange("Purch. Order for Extra Charge", PurchaseHeader."No.");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
                    PurchaseLine.SetRange("Extra Charge Code", DocExtraCharge."Extra Charge Code");
                    //PurchaseLine.SetRange("No.", '21020');
                    //PurchaseLine.SETRANGE("Extra Charge",DocExtraCharge.Charge);
                    if not PurchaseLine.Find('-') then begin
                        PurchaseLine1.Reset;
                        PurchaseLine1.SetCurrentKey("Purch. Order for Extra Charge", "Extra Charge Code");
                        PurchaseLine1.SetRange("Document Type", PurchaseHeader."Document Type");
                        PurchaseLine1.SetRange("Document No.", PurchaseHeader."No.");
                        PurchaseLine1.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                        if PurchaseLine1.Find('+') then begin
                            LineNo := PurchaseLine1."Line No.";
                            PurchaseLine1.Reset;
                            PurchaseLine1.Init;
                            PurchaseLine1."Line No." := LineNo + 10000;
                            PurchaseLine1.Validate("Document Type", PurchaseHeader."Document Type");
                            PurchaseLine1.Validate(Type, PurchaseLine.Type::"G/L Account");
                            PurchaseLine1.Validate("Document No.", DocExtraCharge."Document No.");
                            PurchaseLine1.Validate("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                            PurchaseLine1.Validate("Extra Charge Code", DocExtraCharge."Extra Charge Code");
                            ExtraCharge.Get(DocExtraCharge."Extra Charge Code");
                            PurchaseLine1.Description := ExtraCharge.Description;
                            /*IF ExtraChargePostingSetup.GET(PurchaseHeader."Gen. Bus. Posting Group",'',
                               "Extra Charge Code")  THEN
                                 IF ExtraChargePostingSetup."Direct Cost Applied Account" <> '' THEN
                                    PurchaseLine1."No." := ExtraChargePostingSetup."Direct Cost Applied Account";*/
                            //PurchaseLine1."No." := '21020';
                            PurchaseLine1.Validate(Quantity, 1);
                            PurchaseLine1.Validate("Direct Unit Cost", DocExtraCharge.Charge);
                            PurchaseLine1."Purch. Order for Extra Charge" := PurchaseHeader."No.";
                            PurchaseLine1.Validate("Expected Receipt Date", PurchaseHeader."Posting Date");
                            PurchaseLine1.Insert;
                            IC := IC + 1;
                        end;
                    end else begin
                        if PurchaseLine."Direct Unit Cost" <> DocExtraCharge.Charge then begin
                            PurchaseLine."Direct Unit Cost" := DocExtraCharge.Charge;
                            PurchaseLine.Modify;
                            MC := MC + 1;
                        end;
                    end;
                until DocExtraCharge.Next = 0;
                if IC <> 0 then
                    Message('%1 PO Line(s) inserted', IC);
                if MC <> 0 then
                    Message('%1 PO Line(s) updated', MC);

            end;
        end;

    end;


    procedure CreateExtraChargeSummary()
    var
        ExtraChargeSummary: Record "Extra Charge Summary";
        POHdr: Record "Purchase Header";
    begin

        if Find('-') then begin
            repeat
                if not ExtraChargeSummary.Get("Document No.", "Extra Charge Code") then begin
                    ExtraChargeSummary.Init;
                    ExtraChargeSummary."Purchase Order No." := "Document No.";
                    ExtraChargeSummary."Extra Charge Code" := "Extra Charge Code";
                    ExtraChargeSummary.Open := true;
                    ExtraChargeSummary."Charge Amount" := Charge;
                    if POHdr.Get("Document Type", "Document No.") then begin
                        ExtraChargeSummary."Vendor Shipment No." := POHdr."Vendor Shipment No.";
                        ExtraChargeSummary."Posting Date" := POHdr."Posting Date";               //EN 02/13/18
                    end;
                    ExtraChargeSummary."Vendor No." := "Vendor No.";
                    ExtraChargeSummary.Insert;
                end;
                ExtraChargeSummary."Charge Amount" := Charge;
                ExtraChargeSummary.Modify;

            until Next = 0;
        end;
    end;


    procedure UpdateExistingECInvoices(PONum: Code[20])
    var
        DocExtraCharge: Record "Document Extra Charge";
        InvHdr: Record "Purchase Header";
        InvLine: Record "Purchase Line";
        ExtraCharge: Record "Extra Charge";
        InvoiceLine: Record "Purchase Line";
        LineNo: Integer;
        ExtraChargePostingSetup: Record "Extra Charge Posting Setup";
    begin

        DocExtraCharge.SetRange("Document Type", DocExtraCharge."Document Type"::Order);
        DocExtraCharge.SetRange("Document No.", PONum);
        DocExtraCharge.SetRange(DocExtraCharge."Line No.", 0);
        DocExtraCharge.SetFilter("Vendor No.", '<>%1', '');
        if DocExtraCharge.Find('-') then begin
            repeat
                InvHdr.SetRange("Document Type", InvLine."Document Type"::Invoice);
                InvHdr.SetRange("Extr chrg created for Ord. No.", PONum);
                InvHdr.SetRange("Buy-from Vendor No.", DocExtraCharge."Vendor No.");
                if InvHdr.Find('-') then begin
                    InvLine.SetRange("Document Type", InvHdr."Document Type"::Invoice);
                    InvLine.SetRange("Document No.", InvHdr."No.");
                    InvLine.SetRange("Extra Charge Code", DocExtraCharge."Extra Charge Code");
                    if InvLine.Find('-') then begin
                        InvLine.Validate("Direct Unit Cost", DocExtraCharge.Charge);
                        InvLine.Modify;
                    end else begin
                        if not InvoiceExistOnECSummary(PONum, DocExtraCharge."Extra Charge Code") then begin
                            InvLine.SetRange("Extra Charge Code");
                            LineNo := 0;
                            InvoiceLine.Reset;
                            InvoiceLine := InvLine;
                            InvoiceLine.CopyFilters(InvLine);
                            if InvoiceLine.Find('+') then
                                LineNo := InvoiceLine."Line No.";
                            InvLine.Init;
                            InvLine."Document Type" := InvHdr."Document Type"::Invoice;
                            InvLine."Document No." := InvHdr."No.";
                            InvLine."Line No." := LineNo + 10000;
                            InvLine.Type := InvLine.Type::"G/L Account";
                            /*IF ExtraChargePostingSetup.GET(InvHdr."Gen. Bus. Posting Group",'',
                              "Extra Charge Code")  THEN
                              IF ExtraChargePostingSetup."Direct Cost Applied Account" <> '' THEN
                                 InvLine."No." := ExtraChargePostingSetup."Direct Cost Applied Account";*/
                            //InvLine.Validate("No.", '21020');
                            InvLine.Validate("Buy-from Vendor No.", InvHdr."Buy-from Vendor No.");
                            if ExtraCharge.Description <> '' then
                                InvLine.Description := ExtraCharge.Description;
                            InvLine.Validate(Quantity, 1);
                            InvLine.Validate("Direct Unit Cost", DocExtraCharge.Charge);
                            InvLine.Validate("Extra Charge Code", DocExtraCharge."Extra Charge Code");
                            InvLine."Purch. Order for Extra Charge" := PONum;
                            InvLine.Insert;
                        end;
                    end;
                end;
            until DocExtraCharge.Next = 0;
        end;

    end;


    procedure CreateVendorInvoices(var DocExtraCharge: Record "Document Extra Charge" temporary; ReceiptNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ExtraCharge: Record "Extra Charge";
        ExtraChargePostingSetup: Record "Extra Charge Posting Setup";
    begin

        PurchaseHeader.Init;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader."No." := '';
        PurchaseHeader.Insert(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", DocExtraCharge."Vendor No.");
        //PurchaseHeader.VALIDATE("Posting Date",VendorPurchaseInvoice."Posting Date");
        //PurchaseHeader.VALIDATE("Document Date",VendorPurchaseInvoice."Posting Date");
        //PurchaseHeader.VALIDATE("Vendor Shipment No.",VendorPurchaseInvoice."Vendor Shipment No.");
        PurchaseHeader."Extr chrg created for Ord. No." := ReceiptNo;   // DA0034A
        PurchaseHeader.Modify(true);
        //VendorBuffer.SETRANGE("Vendor No.",VendorBuffer."Vendor No.");
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 0;
        PurchaseLine.Init;
        PurchaseLine."Line No." += 10000;
        PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
        /*IF ExtraChargePostingSetup.GET(PurchaseHeader."Gen. Bus. Posting Group",'',
             "Extra Charge Code")  THEN
             IF ExtraChargePostingSetup."Direct Cost Applied Account" <> '' THEN
               PurchaseLine."No." := ExtraChargePostingSetup."Direct Cost Applied Account";*/
        //PurchaseLine.Validate("No.", '21020');
        ExtraCharge.Get(DocExtraCharge."Extra Charge Code");
        if ExtraCharge.Description <> '' then
            PurchaseLine.Description := ExtraCharge.Description;
        PurchaseLine.Validate(Quantity, 1);
        PurchaseLine.Validate("Direct Unit Cost", DocExtraCharge.Charge);
        PurchaseLine."Extra Charge Code" := DocExtraCharge."Extra Charge Code";
        PurchaseLine."Purch. Order for Extra Charge" := ReceiptNo;

        PurchaseLine.Insert(true);

    end;


    procedure InvoiceExistOnECSummary(DocNo: Code[20]; ECCode: Code[10]): Boolean
    var
        ExtChargeSummary: Record "Extra Charge Summary";
    begin

        if ExtChargeSummary.Get(DocNo, ECCode) and (ExtChargeSummary."Invoice No." <> '') then
            exit(true);

    end;


    procedure CheckIfPurchInvExist(VendNo: Code[20]): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine1: Record "Purchase Line";
        ExtraChargePostingSetup: Record "Extra Charge Posting Setup";
        ExtraCharge: Record "Extra Charge";
        LineNo: Integer;
        DocExtraCharge: Record "Document Extra Charge";
        IC: Integer;
    begin

        PurchaseHeader.Reset;
        PurchaseHeader.SetRange("Document Type", "Document Type"::Invoice);
        PurchaseHeader.SetRange("Buy-from Vendor No.", VendNo);
        PurchaseHeader.SetRange("Extr chrg created for Ord. No.", "Document No.");
        if PurchaseHeader.Find('-') then
            exit(true)
        else
            exit(false);
    end;
}

