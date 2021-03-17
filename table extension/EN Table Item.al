tableextension 14228889 "Item Extension" extends Item
{
    fields
    {
        
        field(14228880; "Minimum Price Delta"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14228881; "Item Type Code"; Code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(14228882; "Estimated Average Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14228900; "Supply Chain Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228901; "Country/Region of Origin Reqd."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228902; "Item Type"; Enum TMSType)
        {
            Caption = 'Item type';
        }
        field(14229100; "Costing Unit"; Enum "Costing Unit Ext")
        {
            DataClassification = ToBeClassified;
        }
        field(14229101; "Pricing Unit"; Enum "Costing Unit Ext")
        {
            DataClassification = ToBeClassified;
        }
    }


}