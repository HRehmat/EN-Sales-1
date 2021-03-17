tableextension 14228887 "Item Unit Of Measure Ext" extends "Item Unit of Measure"
{
    fields
    {
        field(14228880; "Item UOM Size Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228881; "Qty. per Base UOM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14228882; "Allow Variable Qty. Per"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14229100; Type; Enum "Type Ext")
        {
            DataClassification = ToBeClassified;
        }
    }


}