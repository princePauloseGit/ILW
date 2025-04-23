pageextension 60042 "WhseInternalPickPageExt" extends "Whse. Internal Pick"
{
    layout
    {
        addafter("Trolley No.")
        {
            field(Comments; rec.Comments)
            {
                ApplicationArea = all;
            }
        }
    }
}
