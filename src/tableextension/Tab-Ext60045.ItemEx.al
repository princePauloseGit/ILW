tableextension 60045 "Item_Ex" extends Item
{
    fields
    {
        // Add changes to table fields here
        field(60010; "Minimum Pick Face qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(60011; "Replanish Quantity"; Decimal)
        {
            Caption = 'Replenish Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(60041; "Has Pictures"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(60042; "Has Links"; Boolean)
        {
            DataClassification = SystemMetadata;
        }
        field(60043; "Has Attachments"; Boolean)
        {
            DataClassification = SystemMetadata;
        }

        field(60044; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = New,Active,"Pending DC",Discontinued,"On Hold",Other;
        }

        field(60045; "Item Substrate Code"; Code[20])
        {
            DataClassification = SystemMetadata;
            Caption = 'Item Substrate Code';
            TableRelation = "Item Substrate";

        }

        field(60046; "Safety Stock Proximity"; Decimal)
        {
            Caption = 'Safety Stock Proximity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(60047; "Item Collection Code"; Code[20])
        {
            Caption = 'Item Collection Code';
            TableRelation = "Item Collection";
            DataClassification = SystemMetadata;

        }
        field(60048; "Parent Category Code"; Code[20])
        {
            Caption = 'Parent Category Code';
            TableRelation = "Item Category";
            DataClassification = SystemMetadata;
        }

        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            var
                ItemCategoryRec, ItemCategoryRec2 : Record "Item Category";
                PCC: Text;
            begin
                ItemCategoryRec.Reset();
                ItemCategoryRec.SetRange(Code, Rec."Item Category Code");
                if ItemCategoryRec.FindFirst() then begin
                    PCC := ItemCategoryRec."Parent Category";

                    ItemCategoryRec2.Reset();
                    ItemCategoryRec.SetRange(Code, PCC);
                    if ItemCategoryRec.FindFirst() then begin
                        if ItemCategoryRec."Parent Category" <> '' then begin
                            Rec."Parent Category Code" := ItemCategoryRec."Parent Category";
                        end else begin
                            Rec."Parent Category Code" := PCC;
                        end;
                    end;
                end;
            end;
        }

    }
}