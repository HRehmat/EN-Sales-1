pageextension 14228880 UserSetupExt extends "User Setup"
{
    layout
    {
        addafter(Email)
        {
            field("Allow EC Button Use"; "Allow EC Button Use")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("CC Cash Journal Batch"; "CC Cash Journal Batch")
            {

            }
            field("CC Credit Journal Batch"; "CC Credit Journal Batch")
            {

            }
            field("CC Cash Journal Template"; "CC Cash Journal Template")
            {

            }
            field("Sales Location Filter"; "Sales Location Filter")
            {

            }
            field("Use Signature"; "Use Signature")
            {

            }
            field("Allow C&C Authorization"; "Allow C&C Authorization")
            {

            }
            field("Approval Password"; "Approval Password")
            {

            }



        }
    }

    actions
    {
        // Add changes to page actions here
    }


}