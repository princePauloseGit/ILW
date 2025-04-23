page 60042 "Registered WH Pick lines"
{
    Caption = 'Registered WH Pick lines';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Registered Whse. Activity Line";
    SourceTableView = where("Activity Type" = const(Pick));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the type of document that the line relates to.';
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the item number of the item to be handled, such as picked or put away.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a description of the item on the line.';
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the quantity of the item that was put-away, picked or moved.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Trolley No."; Rec."Trolley No.")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Created At';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; GetUserName(Rec.SystemCreatedBy))
                {
                    Caption = 'Created By';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Show Document")
            {
                ApplicationArea = All;
                Image = Document;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    R_RegisterWhsActivityHeader: Record "Registered Whse. Activity Hdr.";
                    P_RegisterPick: Page "Registered Pick";
                begin
                    R_RegisterWhsActivityHeader.Reset();
                    R_RegisterWhsActivityHeader.SetRange("No.", Rec."No.");
                    if R_RegisterWhsActivityHeader.FindFirst() then begin
                        Clear(P_RegisterPick);
                        P_RegisterPick.SetTableView(R_RegisterWhsActivityHeader);
                        P_RegisterPick.Run();
                    end;

                end;
            }
        }
    }
    local procedure GetUserName(UserGuid: Guid): Text
    var
        User: Record User;
    begin
        User.Reset();
        User.SetRange("User Security ID", UserGuid);
        IF User.FindFirst() THEN
            exit(User."Full Name");
    end;

}