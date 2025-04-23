report 60050 "Create Assembly Order"
{
    Caption = 'Create Assembly Order';
    ProcessingOnly = true;
    ApplicationArea = Assembly;
    UsageCategory = Tasks;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where("Assembly BOM" = filter(1));
            RequestFilterFields = "Item Category Code", "Item Substrate Code";
            trigger OnAfterGetRecord()
            begin
                i += 1;
                UpdateWindow(Round(i / NoofRecords * 10000, 1));
                if not TempAssemblyItemBuffer.Get(Item."No.") then
                    CurrReport.Skip();

                if TempAssemblyItemBuffer."Insufficient Stock" = true then
                    CurrReport.Skip();

                if TempAssemblyItemBuffer."Required Quantity" > -1 then
                    CreateMultipleAssemblyOrders(TempAssemblyItemBuffer."Required Quantity")
                else
                    Error('Required quantity is less than 0 for Item No. = %1', TempAssemblyItemBuffer."Item No.");

            end;

            trigger OnPostDataItem()
            begin
                Window.Open(Text002Lbl);
            end;

            trigger OnPreDataItem()
            var
                TempBOMBuffer: Record "BOM Buffer" temporary;
                L_Item: Record Item;
                ConfirmManagement: Codeunit "Confirm Management";
                IsInSufficient: Boolean;
                RequiredQuantity: Decimal;
                NoInsufficientStock: Integer;
                NoSelected: Integer;
                NoSkipped: Integer;
                RollsConsumed: Integer;
                ProcessConfirmQst: Text;
                SSP: Decimal;
            begin
                i := 0;
                Clear(SSP);
                SSP := SafetyStockProximity;
                // SetAutoCalcFields("W/H Inventory", "Assembly BOM");
                // L_Item.Reset();
                // L_Item.SetRange("No.", 'M0962-SAMPLE'); //testing
                L_Item.SetAutoCalcFields("W/H Inventory", "Assembly BOM", "Qty. on Assembly Order");
                L_Item.SetFilter("Item Category Code", Item.GetFilter("Item Category Code"));
                L_Item.SetFilter("Item Substrate Code", Item.GetFilter("Item Substrate Code"));
                L_Item.SetFilter(Status, '=%1|=%2', Status::Active, Status::"Pending DC");
                L_Item.SetLoadFields("Safety Stock Quantity", "Item Category Code");
                if L_Item.FindSet() then
                    SetDialogVariables(L_Item.Count);
                OpenWindow(Text000Lbl);
                repeat
                    i += 1;
                    UpdateWindow(Round(i / NoofRecords * 10000, 1));
                    IsInSufficient := false;
                    if not L_Item."Assembly BOM" then
                        NoSkipped += 1
                    else
                        if (L_Item."W/H Inventory" + L_Item."Qty. on Assembly Order") < (SSP + L_Item."Safety Stock Quantity") then begin
                            GenerateBOMBuffer(L_Item, TempBOMBuffer);
                            RequiredQuantity := GetRequiredQuantity(L_Item."W/H Inventory", L_Item."Qty. on Assembly Order", SSP, L_Item."Safety Stock Quantity");
                            TempBOMBuffer.Get(1); // Get sample item aka parent item from bom buffer refer item availavility by bom level for details
                            if TempBOMBuffer."Able to Make Parent" < RequiredQuantity then begin //currently only one level no need to check multiple
                                NoInsufficientStock += 1;
                                IsInSufficient := true;
                            end else begin
                                NoSelected += 1;
                                RollsConsumed += RequiredQuantity / 30
                            end;

                            TempAssemblyItemBuffer.InsertIntoBuffer(L_Item."No.", RequiredQuantity, IsInSufficient, L_Item."Item Category Code");
                        end;
                until L_Item.Next() = 0;

                if (NoSkipped <> 0) or (NoSelected <> 0) then begin
                    if NoSkipped <> 0 then
                        ProcessConfirmQst := StrSubstNo(ProcessConfirmWithSkipQst, NoSelected, Count, NoSkipped, NoInsufficientStock, RollsConsumed)
                    else
                        ProcessConfirmQst := StrSubstNo(ProcessConfirmWithoutSkipQst, NoSelected, Count, NoSkipped, RollsConsumed);

                    if not ConfirmManagement.GetResponseOrDefault(ProcessConfirmQst, true) then
                        CurrReport.Quit();
                end;
                Window.Open(Text001Lbl);
                SetDialogVariables(Item.Count);
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    Visible = true;
                    field("Safety Stock Proximity"; SafetyStockProximity)
                    {
                        Caption = 'Safety Stock Proximity';
                        ApplicationArea = all;
                        Visible = true;

                    }
                }
            }
        }
    }


    trigger OnPostReport()
    begin
        CreateCombinedExcelFile();
        Window.Open(Text003Lbl);
        CreateConsilatedPick();
        // OpenGeneratedFiles();
    end;

    local procedure CreateCombinedExcelFile()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        CombinedFileNameLbl: Label 'Combined_Report_%1.xlsx', Comment = '%1= todaydatetime';
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        // Step 1: Generate the combined Excel file name
        FileName := StrSubstNo(CombinedFileNameLbl, GetTodayDatetime());

        // Step 2: Create the workbook and first sheet - MPN Report
        TempExcelBuffer.CreateNewBook('MPN Report');
        PopulateMPNSheet(TempExcelBuffer);  // Fill data using FillExcelRow
        TempExcelBuffer.WriteSheet('MPN Report', CompanyName, UserId);

        // Step 3: Add the second sheet - Insufficient Stock Report
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.SetCurrent(0, 0);   // Reset Row/Column for new sheet
        TempExcelBuffer.SelectOrAddSheet('Insufficient Stock Report');
        PopulateInsufficientStockSheet(TempExcelBuffer);  // Fill data using FillExcelRow
        TempExcelBuffer.WriteSheet('Insufficient Stock Report', CompanyName, UserId);

        // Step 4: Finalize and download the Excel file
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(FileName);
        TempExcelBuffer.OpenExcel();
    end;


    local procedure PopulateMPNSheet(var TempExcelBuf: Record "Excel Buffer" temporary)
    var
        ItemCategory: Record "Item Category";
    begin
        // Filter the categories with "Download MPN Report" = true
        ItemCategory.SetRange("Download MPN Report", true);
        if not ItemCategory.FindSet() then
            exit;

        // Add Rows
        repeat
            TempAssemblyItemBuffer.Reset();
            TempAssemblyItemBuffer.SetRange("Item Category Code", ItemCategory.Code);
            if TempAssemblyItemBuffer.FindSet() then
                repeat
                    FillExcelRow(TempExcelBuf); // Use FillExcelRow for MPN data
                until TempAssemblyItemBuffer.Next() = 0;
        until ItemCategory.Next() = 0;
    end;


    local procedure PopulateInsufficientStockSheet(var TempExcelBuf: Record "Excel Buffer" temporary)
    begin
        TempAssemblyItemBuffer.Reset();
        TempAssemblyItemBuffer.SetRange("Insufficient Stock", true);
        if not TempAssemblyItemBuffer.FindSet() then
            exit;

        repeat
            FillExcelRowforInSufficientStock(TempExcelBuf); // Use FillExcelRowforInSufficientStock
        until TempAssemblyItemBuffer.Next() = 0;
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary; // Single global buffer for both sheets
        CombinedFileNameLbl: Label 'Combined_Report_%1.xlsx', Comment = '%1= todaydatetime';
        FileNames: List of [Text];
        AssemblyHeader: Record "Assembly Header";
        TempAssemblyItemBuffer: Record "Assembly Item Buffer" temporary;
        WindowUpdateDateTime: Datetime;
        Window: Dialog;
        i: Integer;
        NoofRecords: Integer;
        AssemblyCommentLbl: Label '%1 Pick List', Comment = '%1= Item Category Code';
        MPNCommentLbl: Label 'MPN %1 Pick List', Comment = '%1= Item Category Code';
        ProcessConfirmWithoutSkipQst: Label '%1 item(s) out of %2 have been selected for Order creation (Selecting %1, Skipping 0,Insufficient %3 )\%4 Rolls willl be consumed. \\Do you want to continue?', Comment = '%1=integer(number of items) ,%2= total items ,%3= insufficient, %4= total rolls';

        ProcessConfirmWithSkipQst: Label '%1 item(s) out of  %2 have been selected for Order creation.\Some of the items do not have Assembly BOM or have insufficient stock and will be skipped. (Selecting %1, Skipping %3, Insufficient %4)\%5 Rolls will be consumed. \\Do you want to continue?', Comment = '%1=integer(number of item )%2 = total number of items  %3=integer(number of items skipped) %4=Insufficient %5= no of rolls';
        Text000Lbl: Label 'Calculating stock   @1@@@@';
        Text001Lbl: Label 'Inserting into Assembly Table @1@@@@';
        Text002Lbl: Label 'Downloading Reports';
        Text003Lbl: Label 'Creating Consolidated Pick';
        AssemblyOrderList: List of [Code[20]];
        MPNOrderList: List of [Code[20]];
        SafetyStockProximity: Decimal;

    local procedure CreateMultipleAssemblyOrders(RequiredQuantity: Decimal)
    var
        RemainingQuantity: Decimal;
    begin
        RemainingQuantity := RequiredQuantity;

        // Loop to create multiple Assembly Orders for chunks of 30 units
        while RemainingQuantity > 0 do begin
            if RemainingQuantity >= 30 then begin
                CreateAssemblyHeader(30); // Create Assembly Order for 30 units
                RemainingQuantity -= 30;
            end else begin
                CreateAssemblyHeader(RemainingQuantity); // Create Assembly Order for remaining quantity
                RemainingQuantity := 0;
            end;
        end;
    end;

    local procedure CreateAssemblyHeader(RequiredQuantity: Integer)
    begin
        Clear(AssemblyHeader);
        AssemblyHeader.Validate("Document Type", AssemblyHeader."Document Type"::Order);
        AssemblyHeader.Insert(true);
        AssemblyHeader.Validate("Item No.", Item."No.");
        AssemblyHeader.Validate("Location Code", 'OAKESWAY'); //hardcoding based on old code 
        AssemblyHeader.Validate(Quantity, RequiredQuantity);
        AssemblyHeader.Validate("Due Date", Today);
        AssemblyHeader.Modify(true);
        if IsMPNCategoryCode(Item."Item Category Code") then begin
            MPNOrderList.Add(AssemblyHeader."No.");
            AssemblyHeader.Validate(Comments, StrSubstNo(MPNCommentLbl, Item.GetFilter("Item Category Code")));
        end
        else begin
            AssemblyOrderList.Add(AssemblyHeader."No.");
            AssemblyHeader.Validate(Comments, StrSubstNo(AssemblyCommentLbl, Item.GetFilter("Item Category Code")));
        end;
        AssemblyHeader.Modify(true);
        AssemblyHeader.PerformManualRelease(); //creates warehouse pick request
    end;

    local procedure GetRequiredQuantity(WHInventory: Decimal; QtyOnAssemblyOrder: Decimal; SafetyStockProximity: Decimal; SafetyStockQuantity: Decimal): Decimal
    var
        Multiple: Decimal;
        CombinedInventory: Decimal;
    begin
        // Combine Warehouse Inventory and Quantity on Assembly Orders
        CombinedInventory := WHInventory + QtyOnAssemblyOrder;
        if CombinedInventory < SafetyStockProximity + SafetyStockQuantity then begin
            Multiple := Round(((SafetyStockProximity + SafetyStockQuantity - CombinedInventory) / 30), 1, '>');// if value is 32 returns 2
            exit(Multiple * 30);
        end else
            exit(-1);
    end;

    local procedure GenerateBOMBuffer(var L_Item: Record Item; var BOMBuffer: Record "BOM Buffer" temporary)
    var
        CalcBOMTree: Codeunit "Calculate BOM Tree";
    begin
        CalcBOMTree.SetItemFilter(L_Item);
        CalcBOMTree.SetShowTotalAvailability(true);
        CalcBOMTree.GenerateTreeForItem(L_Item, BOMBuffer, Today, 1);
    end;

    local procedure OpenWindow(Text000: Text)
    begin
        if not GuiAllowed() then
            exit;
        Window.Open(Text000);
        WindowUpdateDateTime := CurrentDateTime;
    end;

    local procedure UpdateWindow(ProgressValue: Integer)
    begin
        if not GuiAllowed() then
            exit;

        if CurrentDateTime - WindowUpdateDateTime >= 300 then begin
            WindowUpdateDateTime := CurrentDateTime;
            Window.Update(1, ProgressValue);
        end;
    end;

    local procedure SetDialogVariables(Count: Integer)
    begin
        i := 0;
        NoofRecords := Count;
    end;

    local procedure CreateExcelBufferInsufficientItem(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        if TempExcelBuffer.IsEmpty then
            TempExcelBuffer.CreateNewBook('Items');
        repeat
            FillExcelRowForInsufficientStock(TempExcelBuffer);
        until TempAssemblyItemBuffer.Next() = 0;
    end;

    local procedure CreateExcelBufferMPN(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        if TempExcelBuffer.IsEmpty then
            TempExcelBuffer.CreateNewBook('Items');
        repeat
            FillExcelRow(TempExcelBuffer);
        until TempAssemblyItemBuffer.Next() = 0;
    end;

    local procedure GetTodayDatetime() TodayDate: Text
    begin
        TodayDate := FORMAT(TODAY, 0, '<Month,2>_<Day,2>_<Year4>');
        TodayDate := DELCHR(TodayDate, '=', '/');
        TodayDate += (FORMAT(TIME, 0, '<hours24,2><Filler Character,0><minutes,2><seconds,2>'));
    end;

    local procedure FillExcelRow(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(TempAssemblyItemBuffer."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TempAssemblyItemBuffer."Required Quantity", false, '', false, false, false, '0', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure FillExcelRowforInSufficientStock(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(TempAssemblyItemBuffer."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure IsMPNCategoryCode(ItemCategoryCode: Code[20]): Boolean
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.LoadFields("Download MPN Report");
        ItemCategory.Get(ItemCategoryCode);
        if ItemCategory."Download MPN Report" then
            exit(true);
        exit(false);
    end;


    local procedure CreateConsilatedPick()
    var
        MPNPickRequest: Record "Whse. Pick Request";
        AssemblyPickRequest: Record "Whse. Pick Request";
        DefaultTemplateNameTxt: Label 'PICK';
        DefaultWhseNameTxt: Label 'ASSEMBLY';
        LocationCode: Text[10];
    begin
        MPNPickRequest.SetRange("Document Type", MPNPickRequest."Document Type"::Assembly);
        MPNPickRequest.SetRange("Document Subtype", AssemblyHeader."Document Type"::Order);
        MPNPickRequest.SetRange("Completely Picked", false);
        MPNPickRequest.SetRange(Status, MPNPickRequest.Status::Released);
        if not MPNPickRequest.FindSet() then
            exit;
        repeat
            if not WhsePickLineExists(MPNPickRequest."Document No.") then begin
                if MPNOrderList.Contains(MPNPickRequest."Document No.") then
                    MPNPickRequest.Mark(true);

                if AssemblyOrderList.Contains(MPNPickRequest."Document No.") then
                    if AssemblyPickRequest.Get(MPNPickRequest."Document Type", MPNPickRequest."Document Subtype", MPNPickRequest."Document No.", MPNPickRequest."Location Code") then
                        AssemblyPickRequest.Mark(true);
            end;
        until MPNPickRequest.Next() = 0;
        LocationCode := MPNPickRequest."Location Code";
        MPNPickRequest.MarkedOnly(true);
        AssemblyPickRequest.MarkedOnly(true);

        if not MPNPickRequest.IsEmpty then begin
            GenerateWhseWorksheetLine(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode, MPNPickRequest);
            CreateAssemblyPick(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode);
        end;

        if not AssemblyPickRequest.IsEmpty then begin
            GenerateWhseWorksheetLine(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode, AssemblyPickRequest);
            CreateAssemblyPick(DefaultTemplateNameTxt, DefaultWhseNameTxt, LocationCode);
        end;


    end;

    local procedure WhsePickLineExists(DocumentNo: Code[20]): Boolean
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        WarehouseActivityLine.SetRange("Source No.", DocumentNo);
        if not WarehouseActivityLine.IsEmpty then
            exit(true);
        exit(false);
    end;

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
