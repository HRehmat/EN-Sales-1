pageextension 14229107 "Gen. Posting Setup Ext" extends "General Posting Setup"
{
    actions
    {
        addafter("&Copy")
        {
            action("E&xtra Charges")
            {
                ApplicationArea = All;
                RunObject = Page "Extra Charge Posting Setup";

                Image = "Costs";
                Promoted = true;
                PromotedCategory = Process;

            }
        }
    }
}