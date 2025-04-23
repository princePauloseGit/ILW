#pragma implicitwith disable
page 60043 "Activities"
{
    Caption = 'Activites';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Cue";
    Permissions = tabledata "Sales Cue" = rm;


    layout
    {
        area(Content)
        {
            cuegroup("")
            {
                Caption = '';

                // field("Orders Received Today"; Rec."Orders Received Today")
                // {
                //     ApplicationArea = All;
                //     DrillDownPageID = "Web Order List";
                //     Image = none;


                //  }
                field("Total orders in today"; CalcOrdersToday())
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Sales Order List";

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesOrder: Page "Sales Order List";
                    begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetRange("Document Date", Today());
                        if SalesHeader.FindSet() then begin
                            SalesOrder.SetTableView(SalesHeader);
                            SalesOrder.Run();
                        end;

                    end;

                }
                field("Outstanding Orders"; Rec."Outstanding Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Sales Order List";
                }
                field("OverDue Orders"; OverdueOrders())
                {
                    ApplicationArea = All;
                    //DrillDownPageId = "Sales Order List";
                    Image = none;

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesOrder: page "Sales Order List";

                    begin

                        SalesHeader.Reset();
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetFilter("Document Date", '<=%1', CalcDate('-3D', WorkDate()));
                        SalesHeader.SetFilter("Completely Shipped", 'No');
                        if SalesHeader.FindFirst() then begin
                            SalesOrder.SetTableView(SalesHeader);
                            SalesOrder.Run();
                        end;
                    end;
                }

                field("Orders with Error"; Rec."Orders with Error")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Web Order List";
                }

                field("Order on Shipment"; Rec."Order on Shipment")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Sales Order List";
                }

                field("Order ready to be scanned"; Rec."Order ready to be scanned")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Sales Order List";
                }

                field("Orders Despatched Today"; Rec."Orders Despatched Today")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Posted Sales Shipments";

                }
                // field("Released for Pick Today"; Rec."Released for Pick Today")
                // {
                //     ApplicationArea = All;
                //     DrillDownPageId = "Whse. Internal Pick List";
                //     Image = none;


                // }
                // field("In Pick Today"; Rec."In Pick Today")
                // {
                //     ApplicationArea = All;
                //     DrillDownPageId = "Warehouse Picks";
                //     Image = none;

                // }
                // field("Picked Today"; Rec."Picked Today")
                // {

                //     ApplicationArea = All;
                //     DrillDownPageId = "Registered Whse. Picks";
                //     Image = none;

                // }
                // field("Shipments Today"; Rec."Shipments Today")
                // {

                //     ApplicationArea = All;
                //     DrillDownPageId = "Handled Web Order List";
                //     Image = none;

                // }
                // field("Returns Today"; Rec."Returns Today")
                // {
                //     ApplicationArea = All;
                //     DrillDownPageId = "Sales Return Order List";
                //     Image = none;

                // }
                // field("Total Outstanding"; Rec."Total Outstanding")
                // {
                //     ApplicationArea = All;
                //     DrillDownPageID = "Web Order List";
                //     Image = none;

                // }
            }
        }
    }


    trigger OnOpenPage()
    begin
        Rec."Activities Date Filter" := Today();
        Rec.Modify();
    end;

    var
        "OverDue Orders": Integer;

    local procedure CalcOrdersToday(): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Document Date", Today());
        if SalesHeader.FindSet() then
            exit(SalesHeader.Count);
    end;

    local procedure OverdueOrders(): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Document Date", '<=%1', CalcDate('-3D', WorkDate()));
        SalesHeader.SetFilter("Completely Shipped", 'No');
        if SalesHeader.FindSet() then
            exit(SalesHeader.Count);
    end;


}
#pragma implicitwith restore
