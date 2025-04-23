pageextension 60063 "AssemblyOrdersExt" extends "Assembly Orders"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Item Category Code for the item';
            }
        }
    }
    actions
    {
        addlast(Category_Process)
        {
            actionref(DeletedSelected_Promoted; DeleteSelected)
            {

            }
        }
        addafter("Assembly BOM")
        {
            action(DeleteSelected)
            {
                Caption = 'Delete all';
                Image = Delete;
                ToolTip = 'Delete Selected Orders';
                ApplicationArea = all;
                trigger OnAction()
                var
                    AssemblyHeader: Record "Assembly Header";
                    AssemblyLines: Record "Assembly Line";
                    WH: Record "Warehouse Shipment Header";
                    WHL: Record "Warehouse Activity Line";
                begin
                    // WH.DeleteAll();
                    // WHL.DeleteAll();
                    // AssemblyHeader.DeleteAll();
                    // AssemblyLines.DeleteAll();

                    AssemblyHeader := Rec;
                    CurrPage.SetSelectionFilter(AssemblyHeader);
                    if AssemblyHeader.FindSet() then
                        repeat
                            AssemblyHeader.Delete(true);
                        until AssemblyHeader.Next() = 0;
                end;
            }
        }
        addlast(Category_Order)
        {
            actionref("Create Assembly Orders_Promoted"; "Create Assembly Orders")
            {

            }

        }

        addlast("F&unctions")
        {
            action("Create Assembly Orders")
            {
                ApplicationArea = Assembly;
                ToolTip = 'Create Assembly Order based on insufficient quantity.';
                Caption = 'Create Assembly Orders';
                Image = NewOrder;
                RunObject = Report "Create Assembly Order";
                Enabled = true;

            }

            action("Test Warehouse Pick")
            {
                ApplicationArea = Assembly;
                Visible = false; // for testing purposes
                trigger OnAction()
                var
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                    WhsePickRequest: Record "Whse. Pick Request";
                    WhsePickRequest2: Record "Whse. Pick Request";
                    LocationCode: Code[10];

                    DefaultTemplateNameTxt: Label 'PICK';
                    DefaultWhseNameTxt: Label 'Test1';
                begin
                    WhsePickRequest.SetRange("Document Type", WhsePickRequest."Document Type"::Assembly);
                    WhsePickRequest.SetRange(Status, WhsePickRequest.Status::Released);
                    WhsePickRequest.SetRange("Completely Picked", false);
                    if WhsePickRequest.FindSet() then
                        repeat
                            WarehouseActivityLine.SetRange("Source No.", WhsePickRequest."Document No.");
                            if WarehouseActivityLine.IsEmpty then //check if record is in warehouse pick
                                if WhsePickRequest."Document No." = 'A00008990' then
                                    WhsePickRequest.Mark(true)
                                else begin
                                    WhsePickRequest2.Get(WhsePickRequest."Document Type", WhsePickRequest."Document Subtype", WhsePickRequest."Document No.", WhsePickRequest."Location Code");
                                    WhsePickRequest2.Mark(true);
                                end;
                        until WhsePickRequest.Next() = 0;
                    if WhsePickRequest."Document No." <> '' then
                        LocationCode := WhsePickRequest."Location Code";
                    WhsePickRequest2.MarkedOnly(true);
                    WhsePickRequest.MarkedOnly(true);
                    if not WhsePickRequest.IsEmpty then begin
                        GenerateWhseWorksheetLine(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode, WhsePickRequest);
                        CreateAssemblyPick(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode);
                    end;
                    if not WhsePickRequest2.IsEmpty then begin
                        GenerateWhseWorksheetLine(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode, WhsePickRequest2);
                        CreateAssemblyPick(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode);
                    end;



                end;
            }
        }
    }

    local procedure GenerateWhseWorksheetLine(DefaultTemplateName: Text[10]; DefaultWhseName: Text[10]; LocationCode: Code[10]; var WhsePickRequest: Record "Whse. Pick Request")
    var
        GetWhseSourceDocuments: Report "Get Outbound Source Documents";
    begin
        GetWhseSourceDocuments.SetPickWkshName(DefaultTemplateName, DefaultWhseName, LocationCode);
        GetWhseSourceDocuments.UseRequestPage(false);
        GetWhseSourceDocuments.SetTableView(WhsePickRequest);
        GetWhseSourceDocuments.RunModal();
    end;

    local procedure CreateAssemblyPick(DefaultTemplateName: Text[10]; DefaultWhseName: Text[10]; LocationCode: Code[10])
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
        WhseCreatePick: Report "Create Pick";
    begin
        WhseWorksheetLine.SetRange("Worksheet Template Name", DefaultTemplateName);
        WhseWorksheetLine.SetRange(Name, DefaultWhseName);
        WhseWorksheetLine.SetRange("Location Code", LocationCode);
        if WhseWorksheetLine.FindSet() then begin
            WhseCreatePick.SetWkshPickLine(WhseWorksheetLine);
            WhseCreatePick.UseRequestPage(false);
            WhseCreatePick.RunModal();
        end;
    end;
}
