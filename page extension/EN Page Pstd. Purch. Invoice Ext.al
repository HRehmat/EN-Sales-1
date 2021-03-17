pageextension 14229105 "Pstd. Purch. Invoice Ext" extends "Posted Purchase Invoice"
{
    actions
    {
        addafter(Approvals)
        {
            action("Extra Charge")
            {
                Caption = 'Extra Charge';
                ApplicationArea = All;
                RunObject = Page "Pstd.Doc. Header Extra Charges";
                RunPageLink = "Table ID" = CONST(122), "Document No." = FIELD("No.");
                Image = "Costs";
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }
}