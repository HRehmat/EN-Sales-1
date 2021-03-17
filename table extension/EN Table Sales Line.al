tableextension 14228881 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(14228880; "To be Authorized"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228881; "Authorized Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14228882; "Authorized Price below Cost"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14228883; "Pricing Method"; Enum "Pricing Method Ext")
        {
            DataClassification = ToBeClassified;

        }

        field(14228884; "Requested Order Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                IF Rec."Requested Order Qty." <> xRec."Requested Order Qty." THEN BEGIN
                    VALIDATE(Quantity, "Requested Order Qty.");
                END;
            end;

        }
        field(14228900; "Supply Chain Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228901; "Country/Region of Origin Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228902; "Label Item As"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(14228903; "Price After Sale"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure SuspendPriceCalc(pblnSuspendPriceCalc: Boolean)

    begin
        gblnSuspendPriceCalc := pblnSuspendPriceCalc;
    end;

    procedure doTrackingExists(pdecQty: Decimal; VAR pblnItemTracking: Boolean): Decimal
    var
        lrecReservEntry: Record "Reservation Entry";
        lrecTrackingSpecification: Record "Tracking Specification";
        ldecPctInReserv: Decimal;
        lrecitem: Record Item;
    begin
        pblnItemTracking := FALSE;

        IF NOT (Type = Type::Item) THEN
            EXIT(0);

        IF NOT lrecitem.GET("No.") THEN
            EXIT(0);

        IF lrecitem."Item Tracking Code" = '' THEN
            EXIT(0);

        pblnItemTracking := TRUE;

        IF pdecQty = 0 THEN
            EXIT(0);

        lrecReservEntry.SETCURRENTKEY(
        "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line",
        "Reservation Status", "Shipment Date", "Expected Receipt Date");

        lrecReservEntry.SETRANGE("Source ID", "Document No.");
        lrecReservEntry.SETRANGE("Source Ref. No.", "Line No.");
        lrecReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");

        IF lrecReservEntry.FIND('-') THEN BEGIN
            REPEAT
                IF (lrecReservEntry."Lot No." <> '') OR (lrecReservEntry."Serial No." <> '') THEN BEGIN
                    IF "Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]
                    THEN
                        ldecPctInReserv += lrecReservEntry."Quantity (Base)";
                    IF "Document Type" IN
                        ["Document Type"::Quote,
                        "Document Type"::Order,
                        "Document Type"::Invoice,
                        "Document Type"::"Blanket Order"]
                    THEN
                        ldecPctInReserv += -lrecReservEntry."Quantity (Base)";
                END;
            UNTIL lrecReservEntry.NEXT = 0;
        END;

        lrecTrackingSpecification.SETCURRENTKEY(
        "Source ID", "Source Type", "Source Subtype",
        "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");

        lrecTrackingSpecification.SETRANGE("Source ID", "Document No.");
        lrecTrackingSpecification.SETRANGE("Source Type", DATABASE::"Sales Line");
        lrecTrackingSpecification.SETRANGE("Source Subtype", "Document Type");
        lrecTrackingSpecification.SETRANGE("Source Batch Name", '');
        lrecTrackingSpecification.SETRANGE("Source Prod. Order Line", 0);
        lrecTrackingSpecification.SETRANGE("Source Ref. No.", "Line No.");

        IF lrecTrackingSpecification.FIND('-') THEN BEGIN
            REPEAT
                IF (lrecTrackingSpecification."Lot No." <> '') OR (lrecTrackingSpecification."Serial No." <> '') THEN BEGIN
                    IF "Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]
                    THEN
                        ldecPctInReserv += lrecTrackingSpecification."Quantity (Base)";
                    IF "Document Type" IN
                        ["Document Type"::Quote,
                        "Document Type"::Order,
                        "Document Type"::Invoice,
                        "Document Type"::"Blanket Order"]
                    THEN
                        ldecPctInReserv += -lrecTrackingSpecification."Quantity (Base)";
                END;
            UNTIL lrecTrackingSpecification.NEXT = 0;
        END;

        IF pdecQty <> 0 THEN
            ldecPctInReserv := ldecPctInReserv / pdecQty * 100;

        EXIT(ldecPctInReserv);

    end;

    procedure LookupNoField(VAR mytext: Text[1024]): Boolean
    var
        StdText: Record "Standard Text";
        Acct: Record "G/L Account";
        Item: Record Item;
        Res: Record Resource;
        FA: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";
        StdTextList: Page "Standard Text Codes";
        AcctList: Page "G/L Account List";
        ItemList: Page "Item List";
        ResList: Page "Resource List";
        FAList: Page "Fixed Asset List";
        ItemChargeList: Page "Item Charges";
    begin
        case Rec.Type OF
            Rec.Type::" ":
                begin
                    StdTextList.SetTableView(StdText);
                    IF StdText.Get("No.") then
                        StdTextList.SetRecord(StdText);
                    StdTextList.LookupMode := true;
                    IF StdTextList.RunModal <> Action::LookupOK then
                        exit(false);
                    StdTextList.GetRecord(StdText);
                    mytext := StdText.Code;
                end;
            Rec.Type::"G/L Account":
                begin
                    AcctList.SetTableView(Acct);
                    if Acct.Get("No.") then
                        AcctList.SetRecord(Acct);
                    AcctList.LookupMode := true;
                    if AcctList.RunModal <> Action::LookupOK then
                        exit(false);
                    AcctList.GetRecord(Acct);
                    mytext := Acct."No.";
                end;
            Rec.Type::Item:
                begin
                    Item.SetRange("Item Type", Item."Item Type"::"Finished Good");
                    ItemList.SetTableView(Item);
                    if item.Get("No.") then
                        ItemList.SetRecord(Item);
                    ItemList.LookupMode := true;
                    if ItemList.RunModal <> Action::LookupOK then
                        exit(false);
                    ItemList.GetRecord(Item);
                    mytext := Item."No.";
                end;
            Rec.Type::Resource:
                begin
                    ResList.SetTableView(Res);
                    if Res.Get("No.") then
                        ResList.SetRecord(Res);
                    ResList.LookupMode := true;
                    if ResList.RunModal <> Action::LookupOK then
                        exit(false);
                    ResList.GetRecord(Res);
                    mytext := Res."No.";
                end;
            Rec.Type::"Fixed Asset":
                begin
                    FAList.SetTableView(FA);
                    IF FA.Get("No.") then
                        FAList.SetRecord(FA);
                    FAList.LookupMode := true;
                    IF FAList.RunModal <> Action::LookupOK then
                        exit(false);
                    FAList.GetRecord(FA);
                    mytext := FA."No.";
                end;
            Rec.Type::"Charge (Item)":
                begin
                    ItemChargeList.SetTableView(ItemCharge);
                    if ItemCharge.Get("No.") then
                        ItemChargeList.SetRecord(ItemCharge);
                    ItemChargeList.LookupMode := true;
                    IF ItemChargeList.RunModal <> Action::LookupOK then
                        exit(false);
                    ItemChargeList.GetRecord(ItemCharge);
                    mytext := ItemCharge."No.";
                end;

        end;
        exit(false);
    end;

    var
        gblnSuspendPriceCalc: Boolean;
}