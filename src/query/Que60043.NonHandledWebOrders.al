query 60043 "NonHandledWebOrders"
{
    elements
    {
        dataitem(Interim_Sales_Header; "Interim Sales Header")
        {
            column(No_; "No.")
            {
                Caption = 'Web Order No';
            }

            column(Status; Status)
            {
                Caption = 'Order Status';
            }
            column(Trade_Partner_Code; "Trade Partner Code")
            {
                Caption = 'Channel Name';
            }
            column(Trade_Partner_Code2; "Trade Partner Code")
            {
                Caption = 'Trade Partner Code';
            }
            column(Shipping_Agent_Code; "Shipping Agent Code")
            {
                Caption = 'Shipping Agent Code';
            }

            dataitem(Interim_Sales_Line; "Interim Sales Line")
            {
                DataItemLink = "Document Type" = Interim_Sales_Header."Document Type", "Document No" = Interim_Sales_Header."No.";
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
                    DataItemLink = "No." = Interim_Sales_Line."No.";

                    column(Item_Category_Code; "Item Category Code")
                    {
                        Caption = 'Item Category Code';
                    }
                    dataitem(Whse__Internal_Pick_Header; "Whse. Internal Pick Header")
                    {
                        DataItemLink = "No." = Interim_Sales_Line."Destination Doc No.";
                        column(WIPNo_; "No.")
                        {
                            Caption = 'WIP Number';
                        }
                        column(Document_Status; "Document Status")
                        {
                            Caption = 'WIP Status';
                        }

                    }
                }
            }
        }
    }
}