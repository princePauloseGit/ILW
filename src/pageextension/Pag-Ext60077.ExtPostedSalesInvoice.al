pageextension 60077 ExtPostedSalesInvoice extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Due Date")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
