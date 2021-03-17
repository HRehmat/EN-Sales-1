tableextension 14228907 ItemLedgerExt extends "Item Ledger Entry"
{
    fields
    {
        field(14228900; "Supply Chain Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14228901; "Country/Region of Origin Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure GetCostingQty(): Decimal
    begin
        EXIT(Quantity);
    end;

    procedure GetCostingInvQty(): Decimal
    begin
        EXIT("Invoiced Quantity");
    end;

}