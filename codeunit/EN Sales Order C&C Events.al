codeunit 14228882 "EN Sales Order C&C Events"
{
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesInvHeaderInsert', '', true, true)]
    procedure OnAfterSalesInvheaderInsertUpdate(VAR SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        SalesInvHeader."Source Type" := SalesHeader."Source Type";
        SalesInvHeader."Source Subtype" := SalesHeader."Source Subtype";
        SalesInvHeader."Source ID" := SalesHeader."Source ID";
        SalesInvHeader."Authorized Amount" := SalesHeader."Authorized Amount";
        SalesInvHeader."Authorized User" := SalesHeader."Authorized User";
        SalesInvHeader."Cash & Carry" := SalesHeader."Cash & Carry";
        SalesInvHeader."Cash Applied (Current)" := SalesHeader."Cash Applied (Current)";
        SalesInvHeader."Cash Applied (Other)" := SalesHeader."Cash Applied (Other)";
        SalesInvHeader."Cash Tendered" := SalesHeader."Cash Tendered";
        SalesInvHeader."Cash vs Amount Including Tax" := SalesHeader."Cash vs Amount Including Tax";
        SalesInvHeader."Stop Arrival Time" := SalesHeader."Stop Arrival Time";
        SalesInvHeader."Non-Commissionable" := SalesHeader."Non-Commissionable";
        SalesInvHeader."Approved By" := SalesHeader."Approved By";
        SalesInvHeader."Approval Status" := SalesHeader."Approval Status";
        SalesInvHeader."Order Template Location" := SalesHeader."Order Template Location";
        SalesInvHeader."Entered Amount to Apply" := SalesHeader."Entered Amount to Apply";
        SalesInvHeader."Change Due" := SalesHeader."Change Due";
        SalesInvHeader."Entered Amount to Apply" := SalesHeader."Entered Amount to Apply";
        SalesInvHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesInvLineInsert', '', true, true)]
    procedure OnAfterSalesInvLineInsertUpdate(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; VAR SalesHeader: Record "Sales Header"; VAR TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    begin
        SalesInvLine."Authorized Price below Cost" := SalesLine."Authorized Price below Cost";
        SalesInvLine."Authorized Unit Price" := SalesLine."Authorized Unit Price";
        SalesInvLine."To be Authorized" := SalesLine."To be Authorized";
        SalesInvLine."Requested Order Qty." := SalesLine."Requested Order Qty.";
        SalesInvLine.Modify();
    end;


}