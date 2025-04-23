pageextension 60057 "WhseEntryPageExt" extends "Warehouse Entries"
{
    layout
    {
        addafter("Registering Date")
        {
            field("Entry Created At"; Rec.SystemCreatedAt)
            {
                ApplicationArea = Warehouse;
            }
        }

        addafter("Whse. Document No.")
        {
            field("Reference No."; Rec."Reference No.")
            {
                ApplicationArea = Warehouse;
            }
        }

    }

}