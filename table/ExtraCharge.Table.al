table 14229100 "Extra Charge"
{

    Caption = 'Extra Charge';
    LookupPageID = "Extra Charge List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Allocation Method"; Option)
        {
            Caption = 'Allocation Method';
            OptionCaption = ' ,Amount,Quantity,Weight,Volume,Pallet';
            OptionMembers = " ",Amount,Quantity,Weight,Volume,Pallet;
        }
        field(10; "Charge Caption"; Text[30])
        {
            Caption = 'Charge Caption';
        }
        field(11; "Vendor Caption"; Text[30])
        {
            Caption = 'Vendor Caption';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DocExtraCharge.SetCurrentKey("Extra Charge Code");
        DocExtraCharge.SetRange("Extra Charge Code", Code);
        if DocExtraCharge.Find('-') then
            Error(Text001, TableCaption, Code);

        PostingSetup.SetCurrentKey("Extra Charge Code");
        PostingSetup.SetRange("Extra Charge Code", Code);
        PostingSetup.DeleteAll;
    end;

    var
        DocExtraCharge: Record "Document Extra Charge";
        Text001: Label '%1 ''%2'' is in use.';
        PostingSetup: Record "Extra Charge Posting Setup";
}

