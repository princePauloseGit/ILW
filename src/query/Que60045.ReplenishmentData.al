query 60045 "ReplenishmentData"
{
    elements
    {
        dataitem("Requisition_Line"; "Requisition Line")
        {
            DataItemTableFilter = Type = const(Item);
            column(No_; "No.")
            {
                Caption = 'Item Code';
            }
            column(Description; Description)
            {
                Caption = 'Item Name';
            }
            column(Item_Category_Code; "Item Category Code")
            {
                Caption = 'Item Category Code';
            }
            column(Order_Date; "Order Date")
            {
                Caption = 'Date';
            }
            column(Status; Status)
            {
                Caption = 'Status';
            }
            column(User_ID; "User ID")
            {
                Caption = 'Username';
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Requisition_Line."No.";
                column(Inventory; Inventory)
                {
                    Caption = 'Current Stock Level';
                }
                column(Safety_Stock_Quantity; "Safety Stock Quantity")
                {
                    Caption = 'Safety Stock Qty';
                }
            }

        }
    }


    trigger OnBeforeOpen()
    begin

    end;
}