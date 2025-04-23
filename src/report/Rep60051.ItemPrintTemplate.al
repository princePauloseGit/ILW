report 60051 ItemPrintTemplate
{
    ApplicationArea = All;
    Caption = 'ItemPrintTemplate';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = ItemLabel1;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(UnitPrice; "Unit Price")
            {
            }
            column(Picture; Picture) { }

            column(ItemPicture; ItemTenantMedia.Content)
            {
            }

            dataitem(Item_Attribute_Value_Mapping; "Item Attribute Value Mapping")
            {
                DataItemLink = "No." = field("No.");
                column(Table_ID; "Table ID")
                {
                }
                column(IAVMNo; "No.")
                {
                }
                column(Item_Attribute_ID; "Item Attribute ID")
                {
                }
                column(Item_Attribute_Value_ID; "Item Attribute Value ID")
                {
                }

                dataitem(QueryElement6; "Item Attribute")
                {
                    DataItemLink = ID = field("Item Attribute ID");
                    column(Name; Name)
                    {
                    }
                    column(Type; Type)
                    {
                    }
                    column(Unit_of_Measure; "Unit of Measure")
                    {
                    }
                    dataitem(QueryElement10; "Item Attribute Value")
                    {
                        DataItemLinkReference = Item_Attribute_Value_Mapping;
                        DataItemLink = "Attribute ID" = field("Item Attribute ID"), ID = field("Item Attribute Value ID");
                        column(Value; Value)
                        {
                        }
                        column(Numeric_Value; "Numeric Value")
                        {
                        }
                        column(Date_Value; "Date Value")
                        {
                        }
                        column(Blocked; Blocked)
                        {
                        }
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if ((QueryElement6.Name = 'Box Qty') or (QueryElement6.Name = 'Pattern Repeat (cm)')) then begin
                            CurrReport.Skip();
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                recDoc: Record "Document Attachment";
            begin
                recDoc.Reset();
                recDoc.SetRange("Table ID", 27);
                recDoc.SetRange("No.", Item."No.");
                if recDoc.FindFirst() then begin
                    ItemTenantMedia.Reset();
                    ItemTenantMedia.SetRange(ID, format(recDoc."Document Reference ID"));
                    if ItemTenantMedia.FindFirst() then begin
                        ItemTenantMedia.CalcFields(Content);
                    end;
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    rendering
    {
        layout(ItemLabel1)
        {
            Type = RDLC;
            LayoutFile = './ItemLabel1.rdl';
            Caption = 'Unit Price';
        }
        layout(ItemLabel2)
        {
            Type = RDLC;
            LayoutFile = './ItemLabel2.rdl';
            Caption = 'Unit Price & Description';
        }
        layout(ItemLabel3)
        {
            Type = RDLC;
            LayoutFile = './ItemLabel3.rdl';
            Caption = 'Unit Price & Description & logo';
        }
        layout(ItemLabel4)
        {
            Type = RDLC;
            LayoutFile = './ItemLabel4.rdl';
            Caption = 'Description, SKU, Item Attributes and an Attached Image';
        }
    }
    var
        ItemTenantMedia: Record "Tenant Media";
}
