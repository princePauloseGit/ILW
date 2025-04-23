pageextension 60060 "PostedSalesShipmentsExt" extends "Posted Sales Shipments"
{

    layout
    {
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
    }




}
