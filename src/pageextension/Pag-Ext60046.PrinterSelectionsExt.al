pageextension 60046 "Printer Selections Ext" extends "Printer Selections"
{
    //Nikhil_31/05/2022_User Story 6580: Printer set up - Permissions as per User Id
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(1);
        rec.SetFilter("User ID", UserId);
    end;
    //Nikhil_31/05/2022_User Story 6580: Printer set up - Permissions as per User Id
}
