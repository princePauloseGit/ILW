pageextension 60041 "Item List Ext" extends "Item List"
{
    layout
    {

        modify(GTIN)
        {
            Visible = true;
        }


        addafter("Vendor No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
        }

        addlast(Control1)
        {

            field(Status; rec.Status)
            {
                ApplicationArea = all;
            }
            field("Safety Stock Quantity"; rec."Safety Stock Quantity")
            {
                ApplicationArea = all;
                DecimalPlaces = 0;
            }
            field("Item Substrate Code"; Rec."Item Substrate Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Substrate Code field.';
            }
            field("Item Collection"; Rec."Item Collection Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Substrate Code field.';
            }


        }

        addlast(Control1)
        {
            field("Order Multiple"; Rec."Order Multiple")
            {
                ApplicationArea = All;
                DecimalPlaces = 0;
            }
            field("Has Links"; Rec."Has Links")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Has Links field.';
            }
            field("Has Pictures"; Rec."Has Pictures")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Has Pictures field.';
            }
            field("Has Attachments"; Rec."Has Attachments")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Has Attachments field.';
            }
            field("Parent Category Code"; Rec."Parent Category Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(UpdateAttachments)
            {
                Caption = 'Update Attachments';
                Image = UpdateDescription;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    FindAttachments: Codeunit "Item Attachments";
                // Item: Record Item;
                begin
                    FindAttachments.Run();
                    CurrPage.Update(false);
                end;
            }

            action(UpdateParentCategory)
            {
                Caption = 'Update Parent Category';
                Image = Category;
                ApplicationArea = All;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ItemCategoryRec, ItemCategoryRec2 : Record "Item Category";
                    recItem: Record Item;
                    PCC: Text;
                begin
                    recItem.Reset();
                    recItem.SetFilter("Item Category Code", '<>%1', '');
                    recItem.SetFilter("Parent Category Code", '=%1', '');
                    if recItem.FindSet() then begin
                        repeat
                            ItemCategoryRec.Reset();
                            ItemCategoryRec.SetRange(Code, recItem."Item Category Code");
                            if ItemCategoryRec.FindFirst() then begin
                                Clear(PCC);
                                PCC := ItemCategoryRec."Parent Category";

                                ItemCategoryRec2.Reset();
                                ItemCategoryRec.SetRange(Code, PCC);
                                if ItemCategoryRec.FindFirst() then begin
                                    if ItemCategoryRec."Parent Category" <> '' then begin
                                        recItem."Parent Category Code" := ItemCategoryRec."Parent Category";
                                    end else begin
                                        recItem."Parent Category Code" := PCC;
                                    end;
                                end;
                                recItem.Modify();
                            end;
                        until recItem.Next() = 0;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ItemCategoryRec, ItemCategoryRec2 : Record "Item Category";
        recItem: Record Item;
        PCC: Text;
    begin
        recItem.Reset();
        recItem.SetRange("No.", Rec."No.");
        if recItem.FindSet() then begin
            repeat
                if recItem."Parent Category Code" = '' then begin
                    ItemCategoryRec.Reset();
                    ItemCategoryRec.SetRange(Code, recItem."Item Category Code");
                    if ItemCategoryRec.FindFirst() then begin
                        Clear(PCC);
                        PCC := ItemCategoryRec."Parent Category";

                        ItemCategoryRec2.Reset();
                        ItemCategoryRec.SetRange(Code, PCC);
                        if ItemCategoryRec.FindFirst() then begin
                            if ItemCategoryRec."Parent Category" <> '' then begin
                                recItem."Parent Category Code" := ItemCategoryRec."Parent Category";
                            end else begin
                                recItem."Parent Category Code" := PCC;
                            end;
                        end;
                        recItem.Modify();
                    end;
                end;
            until recItem.Next() = 0;
        end;
    end;
}
