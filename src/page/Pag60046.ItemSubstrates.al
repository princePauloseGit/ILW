page 60046 "Item Substrates"
{
    Caption = 'Item Substrates';
    PageType = List;
    SourceTable = "Item Substrate";
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
