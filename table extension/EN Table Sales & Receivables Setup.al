tableextension 14228884 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(14228880; "C&C Cash Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228881; "C&C Cash Journal Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228882; "C&C Minimum Overdue Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14228910; "Sales Payment Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(14228911; "Posted Sales Payment Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }


}