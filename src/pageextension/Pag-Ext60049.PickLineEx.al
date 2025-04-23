pageextension 60049 "Pick Line Ex" extends "Whse. Pick Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure Code")
        {
            field("Bay No."; rec."Bay No.")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        MovementWorkshhet: Page "Movement Worksheet";
        myInt: Integer;

}