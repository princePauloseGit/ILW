tableextension 60058 SalesShipLineExt extends "Sales Shipment Line"
{
    fields
    {
        field(90001; "Channel Order ID"; Code[50])
        {
            Caption = 'Channel Order ID';
            DataClassification = ToBeClassified;
        }
    }
}
