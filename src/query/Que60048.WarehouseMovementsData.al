query 60048 "Warehouse Movements Data"
{
    QueryType = Normal;

    elements
    {
        dataitem(Warehouse_Entry; "Warehouse Entry")
        {

            column(Item_No_; "Item No.")
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
                column(Item_Category_Code; "Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                column(Safety_Stock_Quantity; "Safety Stock Quantity")
                {
                    Caption = 'Safety Stock Quantity';
                }
                column(Minimum_Pick_Face_qty; "Minimum Pick Face qty")
                {
                    Caption = ' Minimum Pick Face Quantity';
                }
                column(Replanish_Quantity; "Replanish Quantity")
                {
                    Caption = 'Replenish Quantity';
                }
            }
            column(Registering_Date; "Registering Date")
            {
                Caption = 'Movement Date';
            }
            column(Location_Code; "Location Code")
            {
                Caption = 'Location Code';
            }
            column(User_ID; "User ID")
            {
                Caption = 'Username';
            }
            column(Quantity; Quantity)
            {
                Caption = 'Qty adjusted';
            }
            column(Bin_Code; "Bin Code")
            {
                Caption = 'Bin Code';
            }
            column(Zone_Code; "Zone Code")
            {
                Caption = 'Zone Code';
            }
            column(Whse__Document_No_; "Whse. Document No.")
            {
                Caption = 'Whse. Document No.';
            }
            column(ReferenceNo; "Reference No.")
            {
                Caption = 'Reference No.';
            }


            column(Whse__Document_Line_No_; "Whse. Document Line No.")
            {
                Caption = 'Whse. Document Line No.';
            }
            column(Reason_Code; "Reason Code")
            {
                Caption = 'Reason Code';
            }
            column(Source_No_; "Source No.")
            {
                Caption = 'Source No.';
            }
            column(Source_Document; "Source Document")
            {
                Caption = 'Source Document';
            }

        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}