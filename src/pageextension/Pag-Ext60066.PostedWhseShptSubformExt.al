pageextension 60066 PostedWhseShptSubformExt extends "Posted Whse. Shipment Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Trolley No."; Rec."Trolley No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Trolley No. field.';
            }

            field("Bay No."; Rec."Bay No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bay No. field.';
            }

            field("Scanned By"; Rec."Scanned By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scanned By field.';
            }
        }
    }
}
