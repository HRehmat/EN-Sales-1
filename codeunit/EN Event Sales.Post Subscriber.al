codeunit 14229102 "EN Sales.-Post Event"
{
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostLines', '', true, true)]
    procedure AfterOnBeforePostLines(VAR SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        ExtraChargeMgmt.ClearDropShipPostingBuffer;
    end;


    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterInitAssocItemJnlLine', '', true, true)]
    procedure AfterOnAfterInitAssocItemJnlLine(VAR ItemJournalLine: Record "Item Journal Line"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; SalesHeader: Record "Sales Header")
    var
        ExtraChargeBuffer: Record "Extra Charge Posting Buffer";
        ExtraChargeQty: Decimal;
        SalesLine: Record "Sales Line";
    begin
        ExtraChargeMgmt.StartDropShipPosting(PurchaseHeader, PurchaseLine, SalesHeader, SalesLine);
        ExtraChargeMgmt.AdjustItemJnlLine(ItemJournalLine, ExtraChargeBuffer, ExtraChargeQty);
        ExtraChargeMgmt.SetExtraChargeBuffer(ExtraChargeBuffer, ExtraChargeQty, SalesHeader."No.");
    end;



    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPurchRcptHeaderInsert', '', true, true)]
    procedure AfterOnAfterPurchRcptHeaderInsert(VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    var
        ExtraCharge: Record "Extra Charge";
    begin
        ExtraChargeMgmt.MoveToDocumentHeader(DATABASE::"Purchase Header", PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader."Posting Date", DATABASE::"Purch. Rcpt. Header", PurchRcptHeader."No.");
        ExtraChargeMgmt.DropShipUpdateVendorBuffer(PurchaseHeader);
        ExtraChargeMgmt.CreateVendorInvoices(ExtraCharge);
    end;



    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPurchRcptLineInsert', '', true, true)]
    procedure OnAfterPurchRcptLineInsert(VAR PurchRcptLine: Record "Purch. Rcpt. Line"; PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchOrderLine: Record "Purchase Line"; DropShptPostBuffer: Record "Drop Shpt. Post. Buffer"; CommitIsSuppressed: Boolean)
    
    begin
        ExtraChargeMgmt.DropShipMoveToDocumentLine(PurchRcptLine."Document No.", PurchRcptLine."Line No.", PurchOrderLine."Sales Order Line No.");
    end;


    var
        ExtraChargeMgmt: Codeunit "Extra Charge Management";
}