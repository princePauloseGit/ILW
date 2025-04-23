report 60041 "Shop List Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ShopInvoiceReport.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(No_SalesHeader; "No.")
            {
            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Picture; companyInformation.Picture)
            {

            }
            column(ReportLabel; ReportLabel)
            {

            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = filter('Item'));

                column(Document_No_; "Document No.")
                {

                }

                column(No_; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Quantity_Shipped; "Quantity Shipped")
                {
                }
            }

        }


    }




    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    var
    begin
        companyInformation.Get();
        companyInformation.CalcFields(Picture);
    end;


    var
        companyInformation: Record "Company Information";
        myInt: Integer;
        ReportLabel: Label 'Shop List Invoice';
}