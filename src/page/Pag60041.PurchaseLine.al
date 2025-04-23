page 60041 "Purchase Line"
{
    Caption = 'Purchase Lines';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    SourceTableView = where(Type = const(Item), "Document Type" = const(Order));
    Permissions = tabledata "Sales Shipment Header" = RIMD;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of document that you are about to create.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(VendorName; UpdateVendorName(Rec))
                {
                    Caption = 'Buy-from Vendor Name';
                    ApplicationArea = All;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line''s number.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line type.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }

                field("Item Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies information in addition to the description.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the code for the location where the items on the line will be located.';
                    Visible = true;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies the value in the Reserved Quantity field, expressed in the base unit of measure.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                    Visible = false;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of items that remains to be received.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    ApplicationArea = ItemCharges;
                    ToolTip = 'Specifies how many units of the item charge will be assigned to the line.';

                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    ApplicationArea = ItemCharges;
                    BlankZero = true;
                    ToolTip = 'Specifies how much of the item charge that has been assigned.';


                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units on the order line have not yet been received.';
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';
                    Visible = true;
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the item is planned to arrive in inventory. Forward calculation: planned receipt date = order date + vendor lead time (per the vendor calendar and rounded to the next working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: planned receipt date = order date + vendor lead time (per the location calendar). Backward calculation: order date = planned receipt date - vendor lead time (per the vendor calendar and rounded to the previous working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: order date = planned receipt date - vendor lead time (per the location calendar).';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = true;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(BatchUpdate)
            {
                ApplicationArea = All;
                Image = ChangeBatch;
                Promoted = true;
                Visible = false;
                trigger OnAction()
                var
                    PostedWhseShipment: Record "Posted Whse. Shipment Line";
                    RegWhsePick: Record "Registered Whse. Activity Line";
                    ReturnLine: Record "Sales Line";
                    L_SSH: Record "Sales Shipment Header";
                    L_OrderNo: Code[20];
                begin
                    L_SSH.Reset();
                    L_SSH.SetFilter("Order No.", '<>%1', '');
                    L_SSH.SetRange(WarehouseShipmentNo, '');
                    if L_SSH.FindSet() then begin
                        repeat
                            PostedWhseShipment.Reset();
                            PostedWhseShipment.SetRange("Source Document", PostedWhseShipment."Source Document"::"Sales Order");
                            PostedWhseShipment.SetRange("Source No.", L_SSH."Order No.");
                            PostedWhseShipment.SetRange("Posted Source Document", PostedWhseShipment."Posted Source Document"::"Posted Shipment");
                            PostedWhseShipment.SetRange("Posted Source No.", L_SSH."No.");
                            if PostedWhseShipment.FindFirst() then
                                L_SSH.Validate(WarehouseShipmentNo, PostedWhseShipment."No.");


                            RegWhsePick.Reset();
                            RegWhsePick.SetRange("Source Document", RegWhsePick."Source Document"::"Sales Order");
                            RegWhsePick.SetRange("Source No.", L_SSH."Order No.");
                            if RegWhsePick.FindLast() then
                                L_SSH.Validate(WarehousePick, RegWhsePick."No.");


                            ReturnLine.Reset();
                            ReturnLine.SetRange("Document Type", ReturnLine."Document Type"::"Return Order");
                            ReturnLine.SetRange(Type, ReturnLine.Type::" ");
                            if ReturnLine.FindSet() then begin
                                repeat
                                    Clear(L_OrderNo);
                                    L_OrderNo := CopyStr(ReturnLine.Description, 14, 11);
                                    if L_SSH."Order No." = L_OrderNo then
                                        L_SSH.Validate(SalesOrderReturnNo, ReturnLine."Document No.");
                                until ReturnLine.Next() = 0;
                            end;

                            L_SSH.Modify(true);

                        until L_SSH.Next() = 0;
                        Message('Process Completed');
                    end;
                end;
            }
        }
    }
    // trigger OnAfterGetRecord()
    // var
    //     vendors: Record Vendor;
    // begin
    //     Clear(VendorName);
    //     vendors.Reset();
    //     vendors.SetRange("No.", Rec."Buy-from Vendor No.");
    //     if vendors.FindFirst() then
    //         VendorName := vendors.Name;
    // end;

    var
        VendorName: Text;

    local procedure UpdateVendorName(P_PurchaseLine: Record "Purchase Line"): Text
    var
        vendors: Record Vendor;
    begin
        Clear(VendorName);
        vendors.Reset();
        vendors.SetRange("No.", P_PurchaseLine."Buy-from Vendor No.");
        if vendors.FindFirst() then begin
            VendorName := vendors.Name;
            exit(VendorName);
        end;

    end;
}