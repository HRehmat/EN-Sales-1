pageextension 14228910 CustLedgerEntriesExt extends "Customer Ledger Entries"
{
    procedure GetSelectionFilter(VAR CustLedgEntry: Record "Cust. Ledger Entry")

    begin
        CurrPage.SETSELECTIONFILTER(CustLedgEntry); //ENSP1.00
    end;
}