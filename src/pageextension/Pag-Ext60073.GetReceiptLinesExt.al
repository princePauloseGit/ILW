pageextension 60073 GetReceiptLinesExt extends "Get Receipt Lines"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {

            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the order number this line is associated with.';
            }
        }
    }
}
