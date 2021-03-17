tableextension 14228912 CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    
    procedure OnSalesPayment(VAR FoundPaymentLine: Record "Sales Payment Line"): Boolean
    var
        SalesPaymentLine: Record "Sales Payment Line";
    begin
        //<ENSP1.00
        SalesPaymentLine.SETCURRENTKEY(Type, "Entry No.");
        SalesPaymentLine.SETRANGE(Type, SalesPaymentLine.Type::"Open Entry");
        SalesPaymentLine.SETRANGE("Entry No.", "Entry No.");
        IF SalesPaymentLine.FINDFIRST THEN BEGIN
            FoundPaymentLine := SalesPaymentLine;
            EXIT(TRUE);
        END;
        //>>ENSP1.00
    end;

    procedure IsSalesPaymentTender(VAR FoundTenderEntry: Record "Sales Payment Tender Entry"): Boolean
    var
        SalesTenderEntry: Record "Sales Payment Tender Entry";
        SalesPayment: Record "Sales Payment Header";
    begin
        //<<ENSP1.00
        SalesTenderEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        SalesTenderEntry.SETRANGE("Cust. Ledger Entry No.", "Entry No.");
        IF SalesTenderEntry.FINDFIRST THEN
            IF SalesPayment.GET(SalesTenderEntry."Document No.") THEN BEGIN
                FoundTenderEntry := SalesTenderEntry;
                EXIT(TRUE);
            END;
        //>>ENSP1.00
    end;

    procedure IsSalesPaymentInvoice(VAR FoundPayment: Record "Sales Payment Header"): Boolean
    var
        SalesPayment: Record "Sales Payment Header";
    begin
        //<<ENSP1.00
        SalesPayment.SETCURRENTKEY("Min. Posting Entry No.", "Max. Posting Entry No.");
        SalesPayment.SETFILTER("Min. Posting Entry No.", '..%1', "Entry No.");
        SalesPayment.SETFILTER("Max. Posting Entry No.", '%1..', "Entry No.");
        IF SalesPayment.FINDLAST THEN BEGIN
            FoundPayment := SalesPayment;
            EXIT(TRUE);
        END;
        //>>ENSP1.00
    end;
}