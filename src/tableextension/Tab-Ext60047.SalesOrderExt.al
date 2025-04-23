tableextension 60047 "SalesOrderExt" extends "Sales Header"
{
    fields
    {
        field(60001; "Qty On Shipment"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Shipment Line"."Qty. Outstanding" where("Source No." = field("No.")));
        }
        field(60002; "Qty Picked"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Shipment Line"."Qty. Picked" where("Source No." = field("No.")));
        }
        field(60003; "Date Scanned"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Shipment Line"."Scanned Date" where("Source No." = field("No.")));
        }

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



    }
    keys
    {
        key(CombineShipments; "Document Type", "Payment Method Code", "VAT Bus. Posting Group", "No.", "Order Date")
        {
        }
    }




}