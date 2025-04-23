pageextension 60074 ExtSalesInvoiceSubForm extends "Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Channel Order ID"; Rec."Channel Order ID")
            {
                ApplicationArea = all;
            }
        }
    }
}
