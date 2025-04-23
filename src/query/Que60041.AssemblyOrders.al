query 60041 "AssemblyOrders"
{
    elements
    {
        dataitem(Posted_Assembly_Header; "Posted Assembly Header")
        {
            column(Starting_Date; "Starting Date")
            {
                Caption = 'Date of Assembly Order Creation';
            }
            column(Posting_Date; "Posting Date")
            {
                Caption = 'Date of Assembly Order Completion';
            }
            column(User_ID; "User ID")
            {
                Caption = 'Username';
            }
            dataitem(Posted_Assembly_Line; "Posted Assembly Line")
            {
                DataItemLink = "Document No." = Posted_Assembly_Header."No.";
                column(No_; "No.")
                {
                    Caption = 'Item Code';
                }
                column(Description; Description)
                {
                    Caption = 'Item Name';
                }


                column(Bin_Code; "Bin Code")
                {
                    Caption = 'Bin';
                }

                dataitem(Item; Item)
                {
                    DataItemLink = "No." = Posted_Assembly_Line."No.";
                    column(Item_Category_Code; "Item Category Code")
                    {
                        Caption = 'Item Category Code';
                    }
                    column(Safety_Stock_Quantity; "Safety Stock Quantity")
                    {
                        Caption = 'Safety Stock Qty';
                    }
                    column(Inventory; Inventory)
                    {
                        Caption = 'Current Stock Level';
                    }
                }
            }
        }
    }
}