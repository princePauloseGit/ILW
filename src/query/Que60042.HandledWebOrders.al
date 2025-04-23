query 60042 "HandledWebOrders"
{
    elements
    {
        dataitem(Handled_Interim_Sales_Header; "Handled Interim Sales Header")
        {
            column(No_; "No.")
            {
                Caption = 'Web Order No';
            }
            column(Trade_Partner_Code; "Trade Partner Code")
            {
                Caption = 'Channel Name';
            }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            {
                Caption = 'Shipping Agent Code';
            }
            column(Trade_Partner_Code2; "Trade Partner Code")
            {
                Caption = 'Trade Partner Code';
            }
            column(Order_Date; "Order Date")
            {
                Caption = 'Date';
            }
            column(Status; Status)
            {
                Caption = 'Order Status';
            }
            column(User_ID; "User ID")
            {
                Caption = 'Despatched by Username';
            }
            column(Destination_Doc_No_; "Destination Doc No.")
            {
                Caption = 'WIP Number';
            }
            dataitem(Handled_Interim_Sales_Line; "Handled Interim Sales Line")
            {
                DataItemLink = "Document Type" = Handled_Interim_Sales_Header."Document Type", "Document No" = Handled_Interim_Sales_Header."No.";
                column(Type; Type)
                {
                    ColumnFilter = Type = filter(Item);
                }
                column(ItemNo_; "No.")
                {
                    Caption = 'Item Code';
                }
                column(Description; Description)
                {
                    Caption = 'Item Name';
                }
                column(Quantity; Quantity)
                {
                    Caption = 'Qty';
                }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = Handled_Interim_Sales_Line."No.";

                    column(Item_Category_Code; "Item Category Code")
                    {
                        Caption = 'Item Category Code';
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