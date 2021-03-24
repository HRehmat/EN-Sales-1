tableextension 14229120 "Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        field(14229120; "Repack Order Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(14229121; "Default Repack Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            trigger OnValidate()
            var
                Location: Record Location;
            begin
                IF "Default Repack Location" <> '' THEN BEGIN
                    Location.GET("Default Repack Location");
                    Location.TESTFIELD("Bin Mandatory", FALSE);
                END;
            end;
        }
    }


}