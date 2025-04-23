tableextension 60043 "RegisteredWhseActLineExt" extends "Registered Whse. Activity Line"
{
    fields
    {
        field(60041; "Created By"; Text[50])
        {
            Caption = 'Created By';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
    }
}
