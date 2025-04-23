pageextension 60067 PostedWhseShipmentListExt extends "Posted Whse. Shipment List"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = false;
        }

        addafter("Assigned User ID")
        {

            field("Scanned By"; Rec."Scanned By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Scanned By field.';
            }
        }
    }

}
