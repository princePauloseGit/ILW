pageextension 60052 "SalesListPageExt" extends "Sales Order List"
{
    layout
    {
        addafter("Status")
        {
            field("Qty On Shipment"; rec."Qty On Shipment")
            {
                ApplicationArea = All;

            }
            field("Qty Picked"; rec."Qty Picked")
            {
                ApplicationArea = All;
            }
            field("Qty Scanned"; rec."Date Scanned")
            {
                ApplicationArea = All;
            }

            field(WarehouseShipmentNo; rec.WarehouseShipmentNo)
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        addlast(reporting)
        {
            action("Shop List Invoice")
            {
                ApplicationArea = All;
                Image = OrderList;
                // RunObject = Report "Shop List Invoice";

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    Clear(SalesHeader);
                    CurrPage.SetSelectionFilter(SalesHeader);
                    Report.Run(Report::"Shop List Invoice", false, false, SalesHeader);
                end;
            }
        }
    }



}