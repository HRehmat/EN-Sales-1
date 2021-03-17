pageextension 14228913 SalesOrderListExt extends "Sales Order List"
{

    procedure GetSelectionFilter(VAR SalesHeader: Record "Sales Header")

    begin
        CurrPage.SETSELECTIONFILTER(SalesHeader); //ENSP1.00
    end;

}