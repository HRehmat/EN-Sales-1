codeunit 14229101 "EN Purch.-Post Event"
{
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterRoundAmount', '', true, true)]
    procedure OnAfterRoundAmount(PurchaseHeader: Record "Purchase Header"; VAR PurchaseLine: Record "Purchase Line"; PurchLineQty: Decimal)
    begin
        //<<ENEC1.00
        IF (PurchaseLine.Type = PurchaseLine.Type::Item) THEN
            ExtraChargeMgmt.StartPurchasePosting(PurchaseHeader, PurchaseLine, Currency);
        //>>ENEC1.00    
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchInvLineInsert', '', true, true)]
    procedure AfterOnAfterPurchInvLineInsert(VAR PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean)
    begin
        //<<ENEC1.00
        IF (PurchInvLine.Type = PurchInvLine.Type::Item) THEN
            ExtraChargeMgmt.MoveToDocumentLine(DATABASE::"Purch. Inv. Line", PurchInvLine."Document No.", PurchInvLine."Line No.");

        IF (PurchInvLine.Type = PurchInvLine.Type::"G/L Account") THEN
            ExtraChargeMgmt.UpdateExtraChargeSummary(PurchLine, PurchInvLine);
        //>>ENEC1.00    
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostItemJnlLineJobConsumption', '', true, true)]
    procedure AfterOnBeforePostItemJnlLineJobConsumption(VAR ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; QtyToBeInvoiced: Decimal; QtyToBeInvoicedBase: Decimal; SourceCode: Code[10])
    var
        ExtraChargeBuffer: Record "Extra Charge Posting Buffer";
        ExtraChargeQty: Decimal;
    begin
        //<<ENEC1.00   
        ExtraChargeMgmt.AdjustItemJnlLine(ItemJournalLine, ExtraChargeBuffer, ExtraChargeQty);
        ExtraChargeMgmt.SetExtraChargeBuffer(ExtraChargeBuffer, ExtraChargeQty, ItemJournalLine."Document No.");  ///TMS 04/09/18    
        //>>ENEC1.00    
    end;


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterDeleteAfterPosting', '', true, true)]
    procedure AfterOnAfterDeleteAfterPosting(PurchHeader: Record "Purchase Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; CommitIsSupressed: Boolean)
    var
        ECPostingBuffer: Record "Extra Charge Posting Buffer";
    begin
        //<<ENEC1.00
        DocExtraCharge.RESET;
        DocExtraCharge.SETFILTER("Table ID", '%1|%2', DATABASE::"Purchase Header", DATABASE::"Purchase Line");
        DocExtraCharge.SETRANGE("Document Type", PurchHeader."Document Type");
        DocExtraCharge.SETRANGE("Document No.", PurchHeader."No.");
        DocExtraCharge.DELETEALL;

        ECPostingBuffer.RESET;
        IF ECPostingBuffer.FIND('-') then
            ECPostingBuffer.DeleteAll;

        //>>ENEC1.00 
    end;


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchInvHeaderInsert', '', true, true)]

    procedure AfterOnAfterPurchInvHeaderInsert(VAR PurchInvHeader: Record "Purch. Inv. Header"; VAR PurchHeader: Record "Purchase Header")
    var
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        //<<ENEC1.00
        ExtraChargeMgmt.MoveToDocumentHeader(DATABASE::"Purchase Header",
            PurchHeader."Document Type", PurchHeader."No.", PurchHeader."Posting Date",
            DATABASE::"Purch. Inv. Header", PurchInvHeader."No.");



        PurchInvLine.RESET;
        PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
        IF PurchInvLine.FINDFIRST THEN BEGIN
            IF (PurchInvLine.Type = PurchInvLine.Type::Item) THEN
                ExtraChargeMgmt.MoveToDocumentLine(DATABASE::"Purch. Inv. Line", PurchInvLine."Document No.", PurchInvLine."Line No.");

            //IF (PurchInvLine.Type = PurchInvLine.Type::"G/L Account") THEN   
            //    ExtraChargeMgmt.UpdateExtraChargeSummary(TempPurchLine, PurchInvLine); TBR
        END;
        //>>ENEC1.00
    end;



    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchRcptHeaderInsert', '', true, true)]
    procedure AfterOnAfterPurchRcptHeaderInsert(VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)

    begin
        //<<ENEC1.00
        ExtraChargeMgmt.MoveToDocumentHeader(DATABASE::"Purchase Header",
            PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader."Posting Date",
            DATABASE::"Purch. Rcpt. Header", PurchRcptHeader."No.");
        //>>ENEC1.00    
    end;



    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchRcptLineInsert', '', true, true)]
    procedure AfterOnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; VAR PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; VAR TempTrackingSpecification: Record "Tracking Specification" TEMPORARY)

    begin
        //<<ENEC1.00
        IF (PurchRcptLine.Type = PurchRcptLine.Type::Item) THEN
            ExtraChargeMgmt.MoveToDocumentLine(
                DATABASE::"Purch. Rcpt. Line", PurchRcptLine."Document No.", PurchRcptLine."Line No.");
        //>>ENEC1.00    
    end;



    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterReturnShptHeaderInsert', '', true, true)]
    procedure OnAfterReturnShptHeaderInsert(VAR ReturnShptHeader: Record "Return Shipment Header"; VAR PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //<<ENEC1.00
        ExtraChargeMgmt.MoveToDocumentHeader(DATABASE::"Purchase Header",
            PurchHeader."Document Type", PurchHeader."No.", PurchHeader."Posting Date",
            DATABASE::"Return Shipment Header", ReturnShptHeader."No.");
        //>>ENEC1.00    
    end;


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterReturnShptLineInsert', '', true, true)]
    procedure OnAfterReturnShptLineInsert(VAR ReturnShptLine: Record "Return Shipment Line"; ReturnShptHeader: Record "Return Shipment Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; VAR TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")

    begin
        //<<ENEC1.00
        IF (ReturnShptLine.Type = ReturnShptLine.Type::Item) THEN
            ExtraChargeMgmt.MoveToDocumentLine(
                DATABASE::"Return Shipment Line", ReturnShptLine."Document No.", ReturnShptLine."Line No.");
        //>>ENEC1.00    
    end;



    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPurchCrMemoHeaderInsert', '', true, true)]
    procedure OnAfterPurchCrMemoHeaderInsert(VAR PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; VAR PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)

    begin
        //<<ENEC1.00
        ExtraChargeMgmt.MoveToDocumentHeader(DATABASE::"Purchase Header",
            PurchHeader."Document Type", PurchHeader."No.", PurchHeader."Posting Date",
            DATABASE::"Purch. Cr. Memo Hdr.", PurchCrMemoHdr."No.");
        //>>ENEC1.00    
    end;

    var
        Currency: Record Currency;
        ExtraChargeMgmt: Codeunit "Extra Charge Management";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        DocExtraCharge: Record "Document Extra Charge";
}