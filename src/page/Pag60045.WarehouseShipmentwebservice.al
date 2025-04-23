#pragma implicitwith disable
page 60045 "Warehouse Shipment web service"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Warehouse Shipment Line";
    SourceTableView = sorting("No.", "Line No.");

    // Sales Order No., 
    // External Reference No., 
    // Status, 
    // Warehouse Shipment No., 
    // Posted Warehouse Shipment No., 
    // Warehouse Pick No, 
    // Picked by Username, 
    // Scanned by Username, 
    // Qty Outstanding on order, 
    // Qty Scanned on Order, Item Code, 
    // Shipping Agent Code, 
    // Channel
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Warehouse Pick No"; Rec."Warehouse Pick No")
                {
                    ApplicationArea = All;
                }
                field(PostedWarhosueShipmentNo; PostedWarhosueShipmentNo)
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Scan Status"; Rec."Scan Status")
                {
                    ApplicationArea = All;
                }

                field("Scanned By"; Rec."Scanned By")
                {
                    ApplicationArea = All;
                }

                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ApplicationArea = All;
                }
                field("Scanned Quantity"; Rec."Scanned Quantity")
                {
                    ApplicationArea = All;
                }
                field("Channel Code"; Rec."Channel Code")
                {
                    ApplicationArea = All;
                }
            }
        }

    }
    trigger OnAfterGetRecord()
    var
    begin
        Clear(PostedWarhosueShipmentNo);
        PostedWhseShipmentHeader.Reset();
        PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", Rec."No.");
        if PostedWhseShipmentHeader.FindSet() then
            repeat
                if PostedWhseShipmentHeader.Count > 1 then
                    PostedWarhosueShipmentNo := PostedWhseShipmentHeader."No."
                else
                    PostedWarhosueShipmentNo += PostedWhseShipmentHeader."No." + ','
            until PostedWhseShipmentHeader.Next() = 0;
    end;

    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        usevard: Page "User Card";
        PostedWarhosueShipmentNo: Text;
}
#pragma implicitwith restore
