tableextension 14228882 "Usr Setup Extension" extends "User Setup"
{
    fields
    {
        field(14228880; "CC Cash Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14228881; "CC Credit Journal Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14228882; "CC Cash Journal Template"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14228883; "Sales Location Filter"; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14228884; "C&C Extended Fields"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228885; "Use Signature"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228886; "Allow C&C Authorization"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228887; "Approval Password"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14228900; "Display All Items"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14228901; "Display All Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14228902; "Sales Team"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14229100; "Allow EC Button Use"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }
    procedure GetUserSalesTeam(): Code[10]
    begin
        Get(UserId);
        exit("Sales Team");

    end;

}