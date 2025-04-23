pageextension 60075 ExtPostesSalesInvoiceSubform extends "Posted Sales Invoice Subform"
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
