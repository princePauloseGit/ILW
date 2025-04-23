pageextension 60043 "WSHP" extends "Warehouse Shipment"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        // Message(Rec."Warehouse Pick");
    end;

    var
        myInt: Integer;
}