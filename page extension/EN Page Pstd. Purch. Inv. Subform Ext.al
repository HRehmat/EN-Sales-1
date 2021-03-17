pageextension 14229106 "Pstd. Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Extra Charge Code"; "Extra Charge Code")
            {
                ApplicationArea = All;
            }
            field("Purch. Order for Extra Charge"; "Purch. Order for Extra Charge")
            {
                ApplicationArea = All;
            }
        }
    }
}