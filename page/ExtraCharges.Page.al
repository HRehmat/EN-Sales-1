page 14229100 "Extra Charges"
{
    Caption = 'Extra Charges';
    PageType = List;
    ApplicationArea = all;
    UsageCategory = lists;
    SourceTable = "Extra Charge";

    layout
    {
        area(content)
        {
            repeater(Control37002000)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Allocation Method"; "Allocation Method")
                {
                }
                field("Charge Caption"; "Charge Caption")
                {
                }
                field("Vendor Caption"; "Vendor Caption")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

