pageextension 60051 "Ext Purch Doc" extends 6405
{
    layout
    {
        addafter(buyFromVendorNumber)
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
        }
    }
}