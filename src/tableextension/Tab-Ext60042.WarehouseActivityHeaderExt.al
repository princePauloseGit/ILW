tableextension 60042 "WarehouseActivityHeaderExt" extends "Warehouse Activity Header"
{
    fields
    {
        field(60000; "Warehouse Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Warehouse Activity Line"."Whse. Document No." where("No." = field("No.")));
        }
    }
}
