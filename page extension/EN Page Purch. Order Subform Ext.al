pageextension 14229101 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Pallet Count"; "Pallet Count")
            {

                ApplicationArea = All;
                Visible = true;
            }
        }
        addafter("Deferral Code")
        {
            field("Shortcut EC Charge 1"; ShortcutECCharge[1])
            {
                ApplicationArea = All;
                Visible = false;
                AutoFormatExpression = "Currency Code";
                trigger OnDrillDown()
                begin
                    ValidateShortcutECCharge(1, ShortcutECCharge[1]);
                end;
            }
            field("Shortcut EC Charge 2"; ShortcutECCharge[2])
            {
                ApplicationArea = All;
                Visible = false;
                AutoFormatExpression = "Currency Code";
                trigger OnDrillDown()
                begin
                    ValidateShortcutECCharge(1, ShortcutECCharge[1]);
                end;
            }
            field("Shortcut EC Charge 3"; ShortcutECCharge[3])
            {
                ApplicationArea = All;
                Visible = false;
                AutoFormatExpression = "Currency Code";
                trigger OnDrillDown()
                begin
                    ValidateShortcutECCharge(1, ShortcutECCharge[1]);
                end;
            }
            field("Shortcut EC Charge 4"; ShortcutECCharge[4])
            {
                ApplicationArea = All;
                Visible = false;
                AutoFormatExpression = "Currency Code";
                trigger OnDrillDown()
                begin
                    ValidateShortcutECCharge(1, ShortcutECCharge[1]);
                end;
            }
            field("Shortcut EC Charge 5"; ShortcutECCharge[5])
            {
                ApplicationArea = All;
                Visible = false;
                AutoFormatExpression = "Currency Code";
                trigger OnDrillDown()
                begin
                    ValidateShortcutECCharge(1, ShortcutECCharge[1]);
                end;
            }
            field("Extra Charge"; "Extra Charge")
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                begin
                    //<<ENEC1.00
                    CurrPage.SAVERECORD;
                    COMMIT;
                    Rec.ShowExtraCharges;
                    ShowShortcutECCharge(ShortcutECCharge);
                    CurrPage.UPDATE(TRUE);
                    //>>ENEC1.00
                end;
            }
            field("Extra Charge Unit Cost"; ExtraChargeUnitCost)
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("Line Amount Incl. Extra Charges"; LineAmountWithExtraCharge)
            {
                ApplicationArea = All;

            }
        }
    }
    actions
    {
        addafter(DocAttach)
        {
            action("E&xtra Charge")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    ShowExtraCharges;
                end;
            }
        }
    }
    var
        ShortcutECCharge: Array[5] of Decimal;
}