query 60046 "LotNumber WarehouseEntry New"
{

    elements
    {
        dataitem("QueryElement1000000000"; "Bin Content")
        {

            column(Item_No; "Item No.")
            {
            }
            column(Variant_Code; "Variant Code")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Zone_Code; "Zone Code")
            {
            }
            column(Bin_Code; "Bin Code")
            {
            }


            column(Sum_Quantity; Quantity)
            {
                Method = Sum;
            }
        }

    }
}

