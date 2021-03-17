tableextension 14229107 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{
    fields
    {
        field(14229100; "Extra Charge Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14229101; "Purch. Order for Extra Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    procedure ShowExtraCharges()
    var
        PostedExtraCharge: Record "Posted Document Extra Charges";
        PostedExtraCharges: Page "Pstd.Doc. Header Extra Charges";
    begin
        //ENEC1.00
        TESTFIELD("No.");
        TESTFIELD("Line No.");
        TESTFIELD(Type, Type::Item);
        PostedExtraCharge.SETRANGE("Table ID", DATABASE::"Purch. Inv. Line");
        PostedExtraCharge.SETRANGE("Document No.", "Document No.");
        PostedExtraCharge.SETRANGE("Line No.", "Line No.");
        PostedExtraCharges.SETTABLEVIEW(PostedExtraCharge);
        PostedExtraCharges.RUNMODAL;
        //ENEC1.00
    end;
}