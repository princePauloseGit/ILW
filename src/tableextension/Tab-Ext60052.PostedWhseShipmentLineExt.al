tableextension 60052 "PostedWhseShipmentLineExt" extends "Posted Whse. Shipment Line"
{
    fields
    {
        field(60000; "Warehouse Pick No"; Code[20])
        {
            Caption = 'Warehouse Pick No';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60041; "Picked by Username"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90000; "Trolley No."; Code[20])
        {

        }

        field(90008; "Bay No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(90010; "Scanned By"; Code[250])
        {

        }

        field(90001; "Channel Order ID"; Code[50])
        {
            Editable = false;
        }

        field(90002; "Channel Code"; Code[20])
        {
            Caption = 'Channel Code';
        }



    }
}
