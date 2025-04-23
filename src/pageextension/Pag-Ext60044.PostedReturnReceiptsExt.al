pageextension 60044 "PostedReturnReceiptsExt" extends "Posted Return Receipts"
{
    layout
    {
        addafter("No.")
        {

            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = All;
            }

        }

        addafter("Sell-to Customer Name")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
            }
        }
    }

}
