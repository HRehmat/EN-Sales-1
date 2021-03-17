tableextension 14228903 PurchHeaderExt extends "Purchase Header"
{
    fields
    {
        field(14228900; "Supply Chain Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14229100; "Extr chrg created for Ord. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure ShowExtraCharges()
    var
        DocExtraCharge: Record "Document Extra Charge";
        Extracharges: Page "Document Header Extra Charges";
    begin
        //<<ENEC1.00
        TESTFIELD("No.");
        DocExtraCharge.RESET;
        DocExtraCharge.SETRANGE("Table ID", DATABASE::"Purchase Header");
        DocExtraCharge.SETRANGE("Document Type", "Document Type");
        DocExtraCharge.SETRANGE("Document No.", "No.");
        Extracharges.SETTABLEVIEW(DocExtraCharge);
        Extracharges.RUNMODAL;
        //>>ENEC1.00   
    end;

}