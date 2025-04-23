pageextension 60071 ItemCategoriesExt extends "Item Categories"
{
    layout
    {
        addafter("Auto Assembly Order")
        {

            field("Download MPN Report"; Rec."Download MPN Report")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies whether to download MPN report while auto creating assembly order';
            }
        }
    }
}
