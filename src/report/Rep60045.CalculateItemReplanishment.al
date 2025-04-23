report 60045 "Calculate Item Replanishment"
{
    Caption = 'Calculate Item Replenishment';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") ORDER(ascending) WHERE(Blocked = FILTER(false));
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin
                Replenishmt.ReplenishBin(Item);
            end;

            trigger OnPostDataItem()
            begin
                if not Replenishmt.InsertWhseWkshLine then
                    if not HideDialog then
                        Message(Text000);
            end;

            trigger OnPreDataItem()
            begin
                //SetRange("Location Code", LocationCode);
                Replenishmt.SetWhseWorksheet(
                  WhseWkshTemplateName, WhseWkshName, LocationCode);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(WorksheetTemplateName; WhseWkshTemplateName)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Worksheet Template Name';
                        TableRelation = "Whse. Worksheet Template";
                        ToolTip = 'Specifies the name of the worksheet template that applies to the movement lines.';

                        trigger OnValidate()
                        begin
                            if WhseWkshTemplateName = '' then
                                WhseWkshName := '';
                        end;
                    }
                    field(WorksheetName; WhseWkshName)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Worksheet Name';
                        ToolTip = 'Specifies the name of the worksheet the movement lines will belong to.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            WhseWorksheetName.SetRange("Worksheet Template Name", WhseWkshTemplateName);
                            WhseWorksheetName.SetRange("Location Code", LocationCode);
                            if PAGE.RunModal(0, WhseWorksheetName) = ACTION::LookupOK then
                                WhseWkshName := WhseWorksheetName.Name;
                        end;

                        trigger OnValidate()
                        begin
                            WhseWorksheetName.Get(WhseWkshTemplateName, WhseWkshName, LocationCode);
                        end;
                    }
                    field(LocCode; LocationCode)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Location Code';
                        TableRelation = Location;
                        ToolTip = 'Specifies the location at which bin replenishment will be calculated.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    procedure InitializeRequest(WhseWkshTemplateName2: Code[10]; WhseWkshName2: Code[10]; LocationCode2: Code[10]; AllowBreakbulk2: Boolean; HideDialog2: Boolean; DoNotFillQtytoHandle2: Boolean)
    begin
        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
        HideDialog := HideDialog2;
    end;

    var
        WhseWorksheetName: Record "Whse. Worksheet Name";
        Replenishmt: Codeunit "Robosol Replenishment";
        HideDialog: Boolean;
        LocationCode: Code[10];
        WhseWkshName: Code[10];
        WhseWkshTemplateName: Code[10];
        Text000: Label 'There is nothing to replenish.';
}