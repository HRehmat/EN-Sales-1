codeunit 14228883 "User Setup Management Ext"
{
    trigger OnRun()
    begin

    end;

    var
        UserSetup: Record "user Setup";
        gcodSalesLocation: Code[250];

    procedure GetSalesLocationFilter(): Code[250]

    begin
        EXIT(GetSalesLocationFilter2(USERID));
    end;

    procedure GetSalesLocationFilter2(UserCode: Code[50]): Code[250]
    var
        myInt: Integer;
    begin
        IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN BEGIN
            IF UserSetup."Sales Location Filter" <> '' THEN BEGIN
                gcodSalesLocation := UserSetup."Sales Location Filter" + '|' + '''' + '''';
            END;
        END;
        EXIT(gcodSalesLocation);
    end;

}