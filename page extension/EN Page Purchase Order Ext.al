pageextension 14229100 "Purchase Order Ext" extends "Purchase Order"
{
    actions
    {

        addlast("O&rder")
        {

            action("Extra Charge")
            {
                ApplicationArea = All;

                Caption = 'Extra Charge';              
                Promoted = true;
                Image = Cost;
                PromotedCategory = Process;
                AccessByPermission = TableData "Extra Charge" = R;
                trigger OnAction()
                begin
                    //<<ENEC1.00
                    ShowExtraCharges;
                    CurrPage.PurchLines.PAGE.UpdateForm(FALSE);
                    //>>ENEC1.00    
                end;
            }

        }
    }
}