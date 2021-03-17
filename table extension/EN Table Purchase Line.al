tableextension 14228904 PurchLineExt extends "Purchase Line"
{
    fields
    {
        field(14228900; "Country/Region of Origin Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14229100; "Extra Charge Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14229101; "Purch. Order for Extra Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14229102; "Extra Charge"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            FieldClass = FlowField;
            CalcFormula = Sum("Document Extra Charge".Charge WHERE("Table ID" = CONST(39), "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No."), "Line No." = FIELD("Line No.")));
        }
        field(14229103; "Pallet Count"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN

                    IF ItemUOM.GET("No.", 'PALLET') THEN
                        "Pallet Count" := ("Quantity (Base)" / ItemUOM."Qty. per Unit of Measure")
                    ELSE
                        "Pallet Count" := 0;
                END;
            end;
        }
    }
    
    procedure GetExtraChargeAmount()
    var
        ChargeAmount: Decimal;
    begin
        //<<ENEC1.00
        IF (Quantity <> 0) OR ("Extra Charge Code" = '') OR ("Purch. Order for Extra Charge" = '') THEN
            EXIT;
        IF NOT ExtraChargeSummary.GET("Purch. Order for Extra Charge", "Extra Charge Code") THEN
            EXIT;
        ChargeAmount := 0;
        ChargeAmount := ExtraChargeSummary."Charge Amount" - ExtraChargeSummary."Posted Invoice Amount";
        IF ChargeAmount > 0 THEN BEGIN
            VALIDATE(Quantity, 1);
            VALIDATE("Direct Unit Cost", ChargeAmount);
            MODIFY;
        END;
        //>>ENEC1.00    
    end;


    procedure ValidateShortcutECCharge(FieldNumber: Integer; Charge: Decimal)
    begin
        //<<ENEC1.00
        TestStatusOpen;
        TESTFIELD(Type, Type::Item);
        ExtraChargeMgt.ValidateExtraCharge(FieldNumber, Charge);
        IF "Line No." <> 0 THEN BEGIN
            ExtraChargeMgt.SaveExtraCharge(DATABASE::"Purchase Line",
                "Document Type", "Document No.", "Line No.", FieldNumber, Charge);
            CALCFIELDS("Extra Charge");
        END ELSE BEGIN
            ExtraChargeMgt.SaveTempExtraCharge(FieldNumber, Charge);
            "Extra Charge" := ExtraChargeMgt.TotalTempExtraCharge;
        END;
        //>>ENEC1.00
    end;

    procedure ExtraChargeUnitCost(): Decimal
    begin
        //<<ENEC1.00
        CALCFIELDS("Extra Charge");
        IF Quantity <> 0 THEN
            EXIT("Extra Charge" / Quantity);
        //>>ENEC1.00
    end;

    procedure LineAmountWithExtraCharge(): Decimal
    begin
        //<<ENEC1.00
        CALCFIELDS("Extra Charge");
        EXIT("Line Amount" + "Extra Charge");
        //>>ENEC1.00
    end;

    procedure ShowExtraCharges()
    var
        DocExtraCharge: Record "Document Extra Charge";
        Extracharges: Page "Document Header Extra Charges";
    begin
        //<<ENEC1.00
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        TESTFIELD(Type, Type::Item);
        DocExtraCharge.RESET;
        DocExtraCharge.SETRANGE("Table ID", DATABASE::"Purchase Line");
        DocExtraCharge.SETRANGE("Document Type", "Document Type");
        DocExtraCharge.SETRANGE("Document No.", "Document No.");
        DocExtraCharge.SETRANGE("Line No.", "Line No.");
        Extracharges.SETTABLEVIEW(DocExtraCharge);
        Extracharges.RUNMODAL;
        //>>ENEC1.00
    end;

    procedure ShowShortcutECCharge(VAR ShortcutECCharge: ARRAY[5] OF Decimal)
    begin
        //<<ENEC1.00
        IF "Line No." <> 0 THEN
            ExtraChargeMgt.ShowExtraCharge(DATABASE::"Purchase Line",
                "Document Type", "Document No.", "Line No.", ShortcutECCharge)
        ELSE
            ExtraChargeMgt.ShowTempExtraCharge(ShortcutECCharge);
        //>>ENEC1.00
    end;


    var
        ExtraChargeSummary: record "Extra Charge Summary";
        ExtraChargeMgt: Codeunit "Extra Charge Management";
        ItemUOM: Record "Item Unit of Measure";

}