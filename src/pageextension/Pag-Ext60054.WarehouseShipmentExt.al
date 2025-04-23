pageextension 60054 "WarehouseShipmentExt" extends "Warehouse Shipment List"
{
    layout
    {
        addafter(Status)
        {
            field(Comments; rec.Comments)
            {
                ApplicationArea = All;
            }

            field("Warehouse Pick"; rec."Warehouse Pick")
            {
                ApplicationArea = All;

            }
        }
    }
    local procedure FetchWarehousePick()
    var
        myInt: Integer;
    begin

    end;

}
