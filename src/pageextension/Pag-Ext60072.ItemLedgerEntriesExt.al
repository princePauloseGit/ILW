pageextension 60072 "Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
            }
        }
    }
}

