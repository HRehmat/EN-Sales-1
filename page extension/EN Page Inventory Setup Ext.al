pageextension 14229120 "Inventory Setup Ext" extends "Inventory Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Repack Order Nos."; "Repack Order Nos.")
            {
                ApplicationArea = All;

            }
        }
        addlast(Location)
        {
            field("Default Repack Location"; "Default Repack Location")
            {
                ApplicationArea = All;

            }
        }
    }

    
}