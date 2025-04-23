tableextension 60053 "Requisition Line" extends "Requisition Line"
{
    fields
    {
        // Add changes to table fields here
        field(60041; "Component Out Of Stock"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}