pageextension 60055 "SalesOrderDocumentExtension" extends "Sales Order"
{
    layout
    {
        addafter(Control1900201301)
        {
            group("Warehouse Traceability")
            {
                field(WarehouseShipmentNo; Rec.WarehouseShipmentNo)
                {

                    ApplicationArea = all;

                }
                field(WarehousePick; Rec.WarehousePick)
                {
                    ApplicationArea = all;
                }
                field(SalesOrderReturnNo; Rec.SalesOrderReturnNo)
                {

                    ApplicationArea = all;
                }
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
