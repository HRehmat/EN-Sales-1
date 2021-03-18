pageextension 14228912 SalesAndReceivablesSetupsExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(Archiving)
        {
            group("Sales Order Cash & Carry")
            {
                field("C&C Cash Journal Template"; "C&C Cash Journal Template")
                {
                    ApplicationArea = All;

                }
                field("C&C Cash Journal Batch"; "C&C Cash Journal Batch")
                {
                    ApplicationArea = All;

                }
                field("C&C Minimum Overdue Invoice"; "C&C Minimum Overdue Invoice")
                {
                    ApplicationArea = All;

                }
            }
        }
        addlast("Number Series")
        {
            field("Sales Payment Nos."; "Sales Payment Nos.")
            {

            }
            field("Posted Sales Payment Nos."; "Posted Sales Payment Nos.")
            {

            }
        }
    }


}