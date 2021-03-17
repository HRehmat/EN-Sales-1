tableextension 14229105 "Purch. Rcpt. Line Ext" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(14229100; "Extra Charge Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14229103; "Pallet Count"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

    }

    procedure ShowExtraCharges()
    var
        PostedExtraCharge: Record "Posted Document Extra Charges";
        PostedExtraCharges: Page "Pstd.Doc. Header Extra Charges";
    begin
        //<<ENEC1.00
        TESTFIELD("No.");
        TESTFIELD("Line No.");
        TESTFIELD(Type, Type::Item);
        PostedExtraCharge.SETRANGE("Table ID", DATABASE::"Purch. Rcpt. Line");
        PostedExtraCharge.SETRANGE("Document No.", "Document No.");
        PostedExtraCharge.SETRANGE("Line No.", "Line No.");
        PostedExtraCharges.SETTABLEVIEW(PostedExtraCharge);
        PostedExtraCharges.RUNMODAL;
        //>>ENEC1.00
    end;
}