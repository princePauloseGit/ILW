page 60047 "Item Collections"
{
    ApplicationArea = All;
    Caption = 'Item Collections';
    PageType = List;
    SourceTable = "Item Collection";
    RefreshOnActivate = true;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                IndentationControls = "Code";
                ShowAsTree = true;
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
