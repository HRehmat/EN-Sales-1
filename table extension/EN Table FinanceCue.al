tableextension 14228914 FinanceCueExt extends "Finance Cue"
{
    fields
    {
        field(14228910; "Open Sales Payments"; Integer)
        {

            FieldClass = FlowField;
            CalcFormula = Count("Sales Payment Header" WHERE(Status = FILTER(Open | Shipping)));
        }
        field(14228911; "Shipping Sales Payments"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Payment Header" WHERE(Status = CONST(Shipping)));
        }
        field(14228912; "Complete Sales Payments"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Payment Header" WHERE(Status = CONST(Complete)));

        }
    }
}