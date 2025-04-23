pageextension 60059 "PostedSalesShipmentExt" extends "Posted Sales Shipment"
{
    layout
    {

        addafter(Billing)
        {
            group("Warehouse Traceability")
            {
                field(WarehouseShipmentNo; Rec.WarehouseShipmentNo)
                {

                    ApplicationArea = all;

                }
                field(WarehousePick; Rec.WarehousePick)
                {
                    ApplicationArea = all;
                }
                field(SalesOrderReturnNo; Rec.SalesOrderReturnNo)
                {

                    ApplicationArea = all;
                }
            }
        }
    }
}