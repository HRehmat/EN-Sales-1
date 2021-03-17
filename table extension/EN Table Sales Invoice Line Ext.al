tableextension 14228891 "SalesInvoiceLineExt" extends "Sales Invoice Line"
{
    fields
    {
        field(14228880; "To be Authorized"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228881; "Authorized Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14228882; "Authorized Price below Cost"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14228883; "Pricing Method"; Enum "Pricing Method Ext")
        {
            DataClassification = ToBeClassified;
            
        }

        field(14228884; "Requested Order Qty."; Decimal)
        {
            DataClassification = ToBeClassified;


        }
    }
}

