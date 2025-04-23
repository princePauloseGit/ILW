query 60050 "Posted Sales Shipment Data"
{
    QueryType = Normal;
    elements
    {
        dataitem(SalesShipmentHeader; "Sales Shipment Header")
        {
            column(Order_No_; "Order No.")
            {
                Caption = 'Sales Order No.';
            }

            dataitem(Posted_Warehouse_Shipment_Line; "Posted Whse. Shipment Line")
            {
                DataItemLink = "Source No." = SalesShipmentHeader."Order No.";
                SqlJoinType = InnerJoin;


                dataitem(Registered_Whse__Activity_Line; "Registered Whse. Activity Line")
                {
                    DataItemLink = "Source No." = Posted_Warehouse_Shipment_Line."Source No.";
                    SqlJoinType = InnerJoin;
                    column(Created_By; "Created By")
                    {
                        Caption = 'Picked by Username';
                    }

                }


                column(No_; "No.")
                {
                    Caption = 'Posted Warehouse Shipment No.';
                }

                column(Channel_Order_ID; "Channel Order ID")
                {
                    Caption = 'External Reference No.';
                }


                column(Scanned_By; "Scanned By")
                {
                    Caption = 'Scanned by Username';
                }

                column(Item_No_; "Item No.")
                {
                    Caption = 'Item Code';
                }
                column(Channel_Code; "Channel Code")
                {
                    Caption = 'Channel';
                }
            }


            column(WarehousePick; WarehousePick)
            {
                Caption = 'Warehouse Pick No.';
            }

            column(Shipping_Agent_Code; "Shipping Agent Code")
            {
                Caption = 'Shipping Agent Code';
            }

            column(Posting_Date; "Posting Date")
            {
                Caption = 'Posting Date';
            }
        }


    }
}