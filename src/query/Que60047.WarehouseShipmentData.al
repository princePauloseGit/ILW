query 60047 "Warehouse Shipment Data"
{
    QueryType = Normal;

    elements
    {
        dataitem(Warehouse_Shipment_Line; "Warehouse Shipment Line")
        {
            column(Source_No_; "Source No.")
            {
                Caption = 'Sales Order No.';
            }
            column(Channel_Order_ID; "Channel Order ID")
            {
                Caption = 'External Reference No.';
            }
            dataitem(Warehouse_Shipment_Header; "Warehouse Shipment Header")
            {
                DataItemLink = "No." = Warehouse_Shipment_Line."No.";

                column(Document_Status; "Document Status")
                {

                }
                column(Shipping_Agent_Code; "Shipping Agent Code")
                {
                    Caption = 'Shipping Agent Code';
                }
            }

            column(No_; "No.")
            {
                Caption = 'Warehouse Shipment No.';
            }
            column(Warehouse_Pick_No; "Warehouse Pick No")
            {
                Caption = 'Warehouse Pick No';
            }
            column(Picked_by_Username; "Picked by Username")
            {
                Caption = 'Picked by Username';
            }
            column(Scanned_By; "Scanned By")
            {
                Caption = 'Scanned by Username';
            }
            column(Qty__Outstanding; "Qty. Outstanding")
            {
                Caption = 'Qty Outstanding on order';
            }
            column(Scanned_Quantity; "Scanned Quantity")
            {
                Caption = 'Qty Scanned on Order';
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
    }

    var
        myInt: page 5779;

    trigger OnBeforeOpen()
    begin

    end;
}