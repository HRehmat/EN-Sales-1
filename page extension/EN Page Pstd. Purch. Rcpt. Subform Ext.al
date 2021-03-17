pageextension 14229104 "Pstd Purch. Rcpt. Subform Ext" extends "Posted Purchase Rcpt. Subform"
{
    procedure _ShowExtraCharges()
    begin
        Rec.ShowExtraCharges; //ENEC1.00
    end;
}