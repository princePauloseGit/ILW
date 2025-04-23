pageextension 60065 PostedSalesCreditMemosExt extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
            }
        }
    }
}
