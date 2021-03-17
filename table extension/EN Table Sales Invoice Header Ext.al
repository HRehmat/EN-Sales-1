tableextension 14228890 "SalesInvoiceHeaderExt" extends "Sales Invoice Header"
{
    fields
    {
        field(14228880; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(14228881; "Source Subtype"; Enum "Source Subtype Ext")
        {
            Caption = 'Source Subtype';

        }
        field(14228882; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(14228883; "Authorized Amount"; Decimal)
        {

        }
        field(14228884; "Authorized User"; Code[20])
        {

        }

        field(14228885; "Cash vs Amount Including Tax"; Decimal)
        {

        }
        field(14228886; "Created By"; Code[50])
        {

        }
        field(14228887; "Cash Applied (Other)"; Decimal)
        {
        }
        field(14228888; "Cash Applied (Current)"; Decimal)
        {
        }
        field(14228889; "Cash Tendered"; Decimal)
        {
        }
        field(14228890; "Entered Amount to Apply"; Decimal)
        {
            Editable = true;
        }
        field(14228891; "Change Due"; Decimal)
        {
        }
        field(14228892; "Stop Arrival Time"; Time)
        {

        }
        field(14228893; "Non-Commissionable"; Boolean)
        {
            Caption = 'Non-Commissionable';

        }
        field(14228894; "Approved By"; Code[50])
        {
            Editable = false;
        }
        field(14228895; "Approval Status"; Enum "Approved Status Ext")
        {
            Editable = false;

        }
        field(14228896; "Cash & Carry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228897; "Order Template Location"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

}