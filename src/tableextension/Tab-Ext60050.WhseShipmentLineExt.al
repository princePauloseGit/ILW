tableextension 60050 "WhseShipmentLineExt" extends "Warehouse Shipment Line"
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
    }
}
