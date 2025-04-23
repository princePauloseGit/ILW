query 60049 "Bin Level Data"
{
    Caption = 'Bin Level Data';
    OrderBy = Ascending(Bin_Code);

    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {
            column(Item_No; "Item No.")
            {
                Caption = 'Item Code';
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Warehouse_Entry."Item No.";
                column(Description; Description)
                {
                    Caption = 'Item Name';
                }
            }
            column(Location_Code; "Location Code")
            {
                Caption = 'Location';
            }
            column(Zone_Code; "Zone Code")
            {
                Caption = 'Zone';
            }
            column(Bin_Code; "Bin Code")
            {
                Caption = 'Bin';
            }
            column(Bin_Type_Code; "Bin Type Code")
            {
                Caption = 'Bin Type';
            }

            column(Sum_Qty_Base; "Qty. (Base)")
            {
                Caption = 'Inventory';
                ColumnFilter = Sum_Qty_Base = FILTER(<> 0);
                Method = Sum;
            }
        }
    }
}

