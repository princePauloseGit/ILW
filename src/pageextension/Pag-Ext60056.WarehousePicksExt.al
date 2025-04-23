pageextension 60056 "WarehousePicksExt" extends "Warehouse Picks"
{
    layout
    {
        addafter("Total Outstanding Qty")
        {
            field("Warehouse Shipment No."; Rec."Warehouse Shipment No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
