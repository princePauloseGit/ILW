pageextension 60047 "Bin Contents Ext" extends "Bin Contents"
{
    layout
    {
        addlast(Control37)
        {
            field("Safety Stock Qty"; Rec."Safety Stock Qty")
            {
                ApplicationArea = All;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        it: Record Item;
        myInt: Integer;
}