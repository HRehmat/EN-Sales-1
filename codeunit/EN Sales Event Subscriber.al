codeunit 14228911 "EN Sales-Post Event"
{
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeFinalizePosting', '', true, true)]
    procedure OnFinalizePostingSalesPost(var SalesHeader: Record "Sales Header")
    begin

        IF SalesHeader.OnSalesPayment(SalesPaymentLine) then
            if SalesPaymentLine.UpdateStatus() then
                SalesPaymentLine.Modify(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterCheckSalesDoc', '', true, true)]
    procedure OnCheckAndUpdateSalesPost(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader.OnSalesPayment(SalesPaymentLine) then begin
            if (not SalesHeader.Ship) and (SalesHeader.Invoice) then
                Error(Text55020);
            SalesHeader.Invoice := false;
            SalesPayment.Get(SalesPaymentLine."Document No.");
            SalesPayment.CheckBalance();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReleaseSalesDoc', '', true, true)]
    procedure OnReleaseSalesDocCode(var SalesHeader: Record "Sales Header")

    begin
        UpdatePaymentLine(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReopenSalesDoc', '', true, true)]
    procedure OnReleaseSalesDocOnReOpen(var SalesHeader: Record "Sales Header")

    begin
        UpdatePaymentLine(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeManualReOpenSalesDoc', '', true, true)]
    procedure OnReleaseSalesDOnReOpen(var SalesHeader: Record "Sales Header")
    var
        SalesPaymentLine: Record "Sales Payment Line";
    begin
        if SalesHeader.OnSalesPayment(SalesPaymentLine) then
            SalesPaymentLine.TestField("Allow Order Changes", true);
    end;

    local procedure UpdatePaymentLine(var SalesHeader: Record "Sales Header")
    var
        SalesPaymentLine: Record "Sales Payment Line";
    begin
        if not SkipPaymentLineUpdate then
            if SalesHeader.OnSalesPayment(SalesPaymentLine) then
                if SalesPaymentLine.UpdateStatus() then
                    SalesPaymentLine.Modify(true);
    end;

    procedure SetSkipPaymentLineUpdate(NewSkipPaymentLineUpdate: Boolean)
    begin
        SkipPaymentLineUpdate := NewSkipPaymentLineUpdate;
    end;

    var
        SalesPayment: Record "Sales Payment Header";
        SalesPaymentLine: Record "Sales Payment Line";
        Text55020: TextConst ENU = 'You cannot manually invoice an order that is associated to a Sales Payment.';
        SkipPaymentLineUpdate: Boolean;
}