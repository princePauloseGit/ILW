pageextension 60050 "Item Card Ex." extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(Item)
        {
            field("Item Substrate Code"; Rec."Item Substrate Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the substrate  that the item belongs to. ';

            }

            field("Item Collection Code"; Rec."Item Collection Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the collection  that the item belongs to. ';

            }
        }
        addafter("Safety Stock Quantity")
        {
            // field("Safety Stock Proximity"; Rec."Safety Stock Proximity")
            // {
            //     ApplicationArea = Planning;
            // }

        }

        addafter("Order Multiple")
        {
            field("Minimum Pick Face Qty"; rec."Minimum Pick Face qty")
            {
                ApplicationArea = All;
            }
            field("Replanish Quantity"; Rec."Replanish Quantity")
            {
                Caption = 'Replenish Quantity';
                ApplicationArea = All;
            }
            field("Has Pictures"; Rec."Has Pictures")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Has Pictures field.';
            }
            field("Has Links"; Rec."Has Links")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Has Links field.';
            }
            field("Has Attachments"; Rec."Has Attachments")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Has Attachments field.';
            }
        }

        addafter(VariantMandatoryDefaultNo)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }

        }

        modify(ItemAttributesFactbox)
        {
            Visible = false;
        }

        modify(GTIN)
        {
            trigger OnAfterValidate()
            var
                ItemReference: Record "Item Reference";
            begin
                ItemReference.Reset();
                ItemReference.SetRange("Item No.", Rec."No.");
                ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
                if NOT ItemReference.FindFirst() then begin
                    if StrLen(Rec.GTIN) = 13 then begin
                        ItemReference.Init();
                        ItemReference."Item No." := Rec."No.";
                        ItemReference."Unit of Measure" := Rec."Base Unit of Measure";
                        ItemReference."Reference Type" := ItemReference."Reference Type"::"Bar Code";
                        ItemReference."Reference No." := Rec.GTIN;
                        ItemReference.Description := Rec.Description;
                        ItemReference.Insert(true);
                        Rec.Modify(true);
                    end else
                        Message('GTIN should be of 13 digits');
                end
                else begin
                    if ItemReference."Reference No." <> Rec.GTIN then begin
                        ItemReference.Rename(rec."No.", '', Rec."Base Unit of Measure", ItemReference."Reference Type"::"Bar Code", '', Rec.GTIN);
                        // ItemReference.Modify(true);
                        Rec.Modify(true);
                    end;
                end;
            end;
        }

        modify("Net Weight")
        {
            trigger OnAfterValidate()
            var
                ItemUOM: Record "Item Unit of Measure";
            begin
                if not ItemUOM.Get(Rec."No.", Rec."Base Unit of Measure") then
                    exit;

                ItemUOM.Weight := Rec."Net Weight" / ItemUOM."Qty. per Unit of Measure";
                ItemUOM.Modify(true);
            end;
        }

        addafter(ItemPicture)
        {
            part("Lot-Number-by-Item"; "Lot-Number-by-Item")
            {
                SubPageLink = "Item No." = field("No.");
                ApplicationArea = all;
                Caption = 'Bin Contents';
            }

        }

    }


    actions
    {

        addlast(Category_Process)
        {
            actionref(RunReport_Promoted; RunReport)
            {
            }
        }

        addafter(ApplyTemplate)
        {
            action(RunReport)
            {
                Caption = 'Print Templates';
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    repItemTemplate: Report ItemPrintTemplate;
                    recItem: Record Item;
                begin
                    recItem.Reset();
                    recItem.SetRange("No.", Rec."No.");
                    if recItem.FindFirst() then begin
                        Clear(repItemTemplate);
                        repItemTemplate.SetTableView(recItem);
                        repItemTemplate.Run();
                    end;

                end;
            }
        }
    }

    var
        myInt: Integer;
}