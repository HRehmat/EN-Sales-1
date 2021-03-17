tableextension 14228880 "EN Sales Header Ext" extends "Sales Header"
{
    fields
    {

        field(14228880; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(14228881; "Source Subtype"; Enum "Source Subtype Ext")
        {
            Caption = 'Source Subtype';

        }
        field(14228882; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(14228883; "Authorized Amount"; Decimal)
        {

        }
        field(14228884; "Authorized User"; Code[20])
        {

        }

        field(14228885; "Cash vs Amount Including Tax"; Decimal)
        {

        }
        field(14228886; "Created By"; Code[50])
        {

        }
        field(14228887; "Cash Applied (Other)"; Decimal)
        {
        }
        field(14228888; "Cash Applied (Current)"; Decimal)
        {
        }
        field(14228889; "Cash Tendered"; Decimal)
        {
        }
        field(14228890; "Entered Amount to Apply"; Decimal)
        {
            Editable = true;
        }
        field(14228891; "Change Due"; Decimal)
        {
        }
        field(14228892; "Stop Arrival Time"; Time)
        {

        }
        field(14228893; "Non-Commissionable"; Boolean)
        {
            Caption = 'Non-Commissionable';


            trigger OnValidate()
            var

            begin
                UpdateSalesLines(FieldCaption("Non-Commissionable"));
            end;
        }
        field(14228894; "Approved By"; Code[50])
        {
            Editable = false;
        }
        field(14228895; "Approval Status"; Enum "Approved Status Ext")
        {
            Editable = false;

        }
        field(14228896; "Cash & Carry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228897; "Order Template Location"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228900; "Supply Chain Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228901; "Delivery Route No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14228902; "Cash Drawer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source Subtype", "Source ID")
        {

        }
    }

    procedure ibSetUserID()
    var
        CCSalesOrder: Record "Sales Header";
    begin
        IF NOT ("Document Type" IN ["Document Type"::Order, "Document Type"::"Return Order"]) THEN BEGIN
            EXIT;
        END;
        //<<EN1.00
        CCSalesOrder.RESET;
        CCSalesOrder.SETRANGE("Source Type", DATABASE::"Sales Header");
        CCSalesOrder.SETRANGE("Source Subtype", CCSalesOrder."Source Subtype"::"1");
        CCSalesOrder.SETRANGE("Source ID", Rec."No.");
        IF NOT CCSalesOrder.FINDFIRST THEN BEGIN
            "Source Type" := DATABASE::"Sales Header";
            "Source Subtype" := "Source Subtype"::"1";
            "Source ID" := "No.";
            "Created By" := USERID;
            MODIFY();
        END;
        //Commit();
        //>>EN1.00
    end;

    procedure OnSalesPayment(VAR FoundPaymentLine: Record "Sales Payment Line"): Boolean
    var
        SalesPaymentLine: Record "Sales Payment Line";
    begin
        //<<ENSP1.00
        SalesPaymentLine.SETCURRENTKEY(Type, "No.");
        SalesPaymentLine.SETRANGE(Type, SalesPaymentLine.Type::Order);
        SalesPaymentLine.SETRANGE("No.", "No.");
        IF SalesPaymentLine.FINDFIRST THEN BEGIN
            FoundPaymentLine := SalesPaymentLine;
            EXIT(TRUE);
        END;
        //>>ENSP1.00
    end;

    procedure PrintTermMktPickTicket(CheckCashCust: Boolean)
    var
        PayTerms: Record "Payment Terms";
        SalesHeader: Record "Sales Header";
    begin
        //<<ENSP1.00
        IF CheckCashCust THEN
            IF PayTerms.GET("Payment Terms Code") THEN
                IF FORMAT(PayTerms."Due Date Calculation") <> '' THEN
                    IF (TODAY = CALCDATE(PayTerms."Due Date Calculation", TODAY)) AND
                        ((TODAY + 1) = CALCDATE(PayTerms."Due Date Calculation", TODAY + 1))
                    THEN
                        ERROR(Text14228900);
        SalesHeader.COPY(Rec);
        SalesHeader.SETRECFILTER;
        //REPORT.RUN(REPORT::"Terminal Market Pick Ticket",FALSE,FALSE,SalesHeader);    TBR
        //>>ENSP1.00  
    end;

    var


        Text14228880: TextConst ENU = 'You cannot make changes because this Sales Order is on Cash Drawer %1';
        Text14228881: TextConst ENU = 'No Record Extension Records exist for Sales %1 %2. Please update these entries.';
        Text14228900: TextConst ENU = 'Not allowed for cash customers.';
        Text14228901: TextConst ENU = 'You cannot make changes because this Sales Order is on Cash Drawer %1.';
        Text14228910: TextConst ENU = 'Not allowed for cash customers.';


        grecSalesLine: Record "Sales Line";


    procedure UpdateSalesLines(ChangedFieldName: Text[100])
    begin

        grecSalesLine.Reset;
        grecSalesLine.SetRange("Document Type", "Source Subtype");
        grecSalesLine.SetRange("Document No.", "Source ID");
        if grecSalesLine.FindSet then begin
            repeat

                /*CASE ChangedFieldName OF

                  FIELDCAPTION("Non-Commissionable") :
                    IF grecSalesLine."No." <> '' THEN BEGIN
                      IF (grecSalesLine."Comm. Bus. Group" <> '') AND (grecSalesLine."Comm. Prod. Group" <> '') THEN BEGIN
                        grecSalesLine.VALIDATE("Non-Commissionable","Non-Commissionable");
                      END;
                    END;
                END;*///TBR

                //grecSalesLine.MODIFY(TRUE);
                grecSalesLine.Modify;
            until grecSalesLine.Next = 0;
        end;

    end;




    procedure CashDrawerCheck()

    begin
        if Rec."Document Type" = Rec."Document Type"::Order then
            if Rec."Cash Drawer No." <> '' then
                Error(Text14228901, "Cash Drawer No.");
    end;



}

