tableextension 60057 SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(90001; "Channel Order ID"; Code[50])
        {
            Caption = 'Channel Order ID';
            DataClassification = ToBeClassified;
        }
    }
}
