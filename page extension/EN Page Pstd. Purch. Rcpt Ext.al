pageextension 14229103 "Posted Purchase Receipt Ext" extends "Posted Purchase Receipt"
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
                RunPageLink = "Table ID" = CONST(120), "Document No." = FIELD("No.");
                Image = "Costs";
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }

}