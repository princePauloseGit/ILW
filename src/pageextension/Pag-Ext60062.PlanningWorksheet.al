pageextension 60062 "Planning Worksheet" extends "Planning Worksheet"
{
    layout
    {
        // Add changes to page layout here
        addafter("Accept Action Message")
        {
            field("Component Out Of Stock"; Rec."Component Out Of Stock")
            {
                Editable = false;
                ToolTip = 'Specifies the component product stock availability';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}