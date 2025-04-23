tableextension 60051 "SalesShipmentHeaderExt" extends "Sales Shipment Header"
{

    fields
    {
        field(60004; WarehouseShipmentNo; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            Editable = false;
            DataClassification = ToBeClassified;

        }
        field(60005; WarehousePick; Code[20])
        {
            Caption = 'Warehouse Pick No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(60006; SalesOrderReturnNo; Code[20])
        {
            Caption = 'Sales Order Return No.';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }

}
