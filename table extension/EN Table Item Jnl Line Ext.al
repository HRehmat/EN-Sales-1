tableextension 14229103 "Item Jnl. Line Ext" extends "Item Journal Line"
{
    fields
    {

    }

    procedure GetCostingQty(FldNo: Integer): Decimal
    begin
        //>>ENEC1.00
        CASE FldNo OF
            FIELDNO(Quantity):
                EXIT(Quantity);
            FIELDNO("Quantity (Base)"):
                EXIT("Quantity (Base)");
            FIELDNO("Invoiced Quantity"):
                EXIT("Invoiced Quantity");
            FIELDNO("Invoiced Qty. (Base)"):
                EXIT("Invoiced Qty. (Base)");
            FIELDNO("Scrap Quantity"):
                EXIT("Scrap Quantity");
            FIELDNO("Scrap Quantity (Base)"):
                EXIT("Scrap Quantity (Base)");
        END;
        //>>ENEC1.00
    end;


}