query 60044 "Bins"
{
    elements
    {
        dataitem(Bin_Content; "Bin Content")
        {
            column(Item_No_; "Item No.")
            {
                Caption = 'Item Code';
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
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Bin_Content."Item No.";
                column(Description; Description)
                {
                    Caption = 'Item Name';
                }
                column(Inventory; Inventory)
                {
                    Caption = 'Current Stock Level';
                }
                column(Blocked; Blocked)
                {
                    Caption = 'Blocked';
                }
                column(Item_Category_Code; "Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
            }
        }
    }
}