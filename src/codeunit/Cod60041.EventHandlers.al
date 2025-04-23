codeunit 60041 "Event Handlers"
{
    permissions = tableData "Sales Shipment Header" = RIMD;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly Line Management", 'OnBeforeShowAvailability', '', true, true)]
    procedure OnBeforeShowAvailability(var TempAssemblyHeader: Record "Assembly Header"; var TempAssemblyLine: Record "Assembly Line"; ShowPageEvenIfEnoughComponentsAvailable: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Pick", 'OnGetPickOrderLines_OnAddStepsToAnyLine', '', true, true)]
    local procedure MyOnGetPickOrderLines_OnAddStepsToAnyLine(_RecRef: RecordRef; var _BaseOrderLineElement: Record "MOB Ns BaseDataModel Element")
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        _BaseOrderLineElement.Create_StepsByReferenceDataKey('CustomPickSteps');
        if (_RecRef.Number = Database::"Warehouse Activity Line") then begin
            _RecRef.SetTable(WarehouseActivityLine);
            _BaseOrderLineElement.SetValue('RegisterExtraInfo', STRSUBSTNO('CustomPickSteps{[Bay_No][defaultValue][%1]}',
            WarehouseActivityLine."Bay No."));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Reference Data", 'OnGetReferenceData_OnAddRegistrationCollectorConfigurations', '', true, true)]
    local procedure MyOnGetReferenceData_OnAddRegistrationCollectorConfigurations(var _Steps: Record "MOB Steps Element")
    begin
        _Steps.InitConfigurationKey('CustomPickSteps');
        _Steps.Create_TextStep(10000, 'Bay_No');
        _Steps.Set_autoForwardAfterScan(true);
        _Steps.Set_header('Bay No.');
        _Steps.Set_label('Bay No.:');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Pick", 'OnPostPickOrder_OnBeforeHandleRegistrationForWarehouseActivityLine', '', false, false)]
    local procedure OnPostPickOrder_OnBeforeHandleRegistrationForWarehouseActivityLine(var _Registration: Record "MOB WMS Registration"; var _WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        _WarehouseActivityLine."Bay No." := _Registration.GetValue('Bay_No');
        if _WarehouseActivityLine.Modify() then begin
            WarehouseShipmentLine.Reset();
            WarehouseShipmentLine.SetRange("No.", _WarehouseActivityLine."Whse. Document No.");
            WarehouseShipmentLine.SetRange("Line No.", _WarehouseActivityLine."Whse. Document Line No.");
            if WarehouseShipmentLine.FindFirst() then begin
                if WarehouseShipmentLine."Bay No." = '' then begin
                    WarehouseShipmentLine."Bay No." := _WarehouseActivityLine."Bay No.";
                    WarehouseShipmentLine.Modify();
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnAfterRegisteredWhseActivLineInsert', '', false, false)]
    local procedure UpdateBayNoInInternalPickOnAfterRegisteredWhseActivLine(var RegisteredWhseActivityLine: Record "Registered Whse. Activity Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        WhseInternalPickLn: Record "Whse. Internal Pick Line";
    begin
        //Start_NIKHIL_21/04/2022_(Update Bay No In Internal Pick OnAfter Registered WhseActivity Line)
        if (RegisteredWhseActivityLine."Action Type" = RegisteredWhseActivityLine."Action Type"::Take) AND
        (RegisteredWhseActivityLine."Whse. Document Type" = RegisteredWhseActivityLine."Whse. Document Type"::"Internal Pick") then begin
            WhseInternalPickLn.Reset();
            WhseInternalPickLn.SetRange("No.", RegisteredWhseActivityLine."Whse. Document No.");
            WhseInternalPickLn.SetRange("Line No.", RegisteredWhseActivityLine."Whse. Document Line No.");
            if WhseInternalPickLn.FindFirst() then begin
                WhseInternalPickLn.Validate("Bay No.", RegisteredWhseActivityLine."Bay No.");
                WhseInternalPickLn.Modify();
            end;
        end;
        //END_NIKHIL_21/04/2022_(Update Bay No In Internal Pick OnAfter Registered WhseActivity Line)
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterCreateWhseDocLine', '', true, true)]
    // local procedure TansferCommentsFromWIPtoPick(var WarehouseActivityLine: Record "Warehouse Activity Line")
    // var
    //     WAH: Record "Warehouse Activity Header";
    //     WIPH: Record "Whse. Internal Pick Header";
    // begin
    //     if WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Pick then begin
    //         WIPH.Reset();
    //         WIPH.SetRange("No.", WarehouseActivityLine."Whse. Document No.");
    //         if WIPH.FindFirst() then begin
    //             WAH.Reset();
    //             WAH.SetRange(Type, WAH.Type::Pick);
    //             WAH.SetRange("No.", WarehouseActivityLine."No.");
    //             if WAH.FindFirst() then begin
    //                 WAH.Validate(Comments, WIPH.Comments);
    //                 WAH.Modify();
    //             end;
    //         end;
    //     end;
    // end;


    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Pick", 'OnGetPickOrderLines_OnAfterSetFromWarehouseActivityLine', '', true, true)]
    local procedure MyOnGetPickOrderLines_OnAfterSetFromWarehouseActivityLine(_WhseActLineTake: Record "Warehouse Activity Line"; var _BaseOrderLineElement: Record "MOB Ns BaseDataModel Element")
    var
        Item: Record Item;
        WarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        WarehouseActivityHeader.Reset();
        WarehouseActivityHeader.SetRange(Type, _WhseActLineTake."Activity Type");
        WarehouseActivityHeader.SetRange("No.", _WhseActLineTake."No.");
        if WarehouseActivityHeader.FindFirst() then begin
            _BaseOrderLineElement.Set_DisplayLine4(_BaseOrderLineElement.DisplayLine4 + '  ' + StrSubstNo('Comments : %1', WarehouseActivityHeader.Comments));
        end;
    end;*/
    //Sofyan++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Pick", 'OnGetPickOrders_OnAfterSetFromWarehouseActivityHeader', '', true, true)]
    local procedure OnGetPickOrders_OnAfterSetFromWarehouseActivityHeader(_WhseActHeader: Record "Warehouse Activity Header"; var _BaseOrderElement: Record "MOB NS BaseDataModel Element")
    begin
        _BaseOrderElement.Set_DisplayLine4(_BaseOrderElement.DisplayLine4 + '  ' + StrSubstNo('Comments : %1', _WhseActHeader.Comments));
    end;
    //Sofyan--


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnCreateAssemblyPickLineOnAfterCalcQtyToPick', '', false, false)]
    local procedure OnCreateAssemblyPickLineOnAfterCalcQtyToPick(var AsmLine: Record "Assembly Line"; var QtyToPickBase: Decimal; var QtyToPick: Decimal)
    begin
        AsmLine.Validate(Quantity, AsmLine."Quantity to Consume");
        AsmLine.Validate("Quantity (Base)", AsmLine."Quantity to Consume (Base)");
        QtyToPick := AsmLine."Quantity to Consume";
        QtyToPickBase := AsmLine."Quantity to Consume (Base)";

    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Worksheet-Create", 'OnAfterTransferAllButWhseDocDetailsFromAssemblyLine', '', false, false)]
    local procedure OnAfterTransferAllButWhseDocDetailsFromAssemblyLine(var WhseWorksheetLine: Record "Whse. Worksheet Line"; AssemblyLine: Record "Assembly Line")
    begin
        WhseWorksheetLine.Validate(Quantity, AssemblyLine."Quantity to Consume");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Put Away", 'OnGetPutAwayOrders_OnAfterSetFromWarehouseActivityHeader', '', false, false)]

    local procedure OnGetPutAwayOrders_OnAfterSetFromWarehouseActivityHeader(_WhseActHeader: Record "Warehouse Activity Header"; var _BaseOrderElement: Record "MOB NS BaseDataModel Element")
    var
        L_WhsActivityLine: Record "Warehouse Activity Line";
        MobToolbox: Codeunit "MOB Toolbox";

    begin
        case _WhseActHeader.Type of
            _WhseActHeader.Type::"Put-away":
                begin
                    //Displying PO No++
                    L_WhsActivityLine.Reset();
                    L_WhsActivityLine.SetRange("Activity Type", _WhseActHeader.Type);
                    L_WhsActivityLine.SetRange("No.", _WhseActHeader."No.");
                    L_WhsActivityLine.SetRange("Source Document", L_WhsActivityLine."Source Document"::"Purchase Order");
                    if L_WhsActivityLine.FindFirst() then
                        _BaseOrderElement.Set_DisplayLine4(StrSubstNo('Source Document : %1', L_WhsActivityLine."Source Document") + MobToolbox.CRLFSeparator() + StrSubstNo('Document No. : %1', L_WhsActivityLine."Source No."));
                    // _BaseOrderLineElement.Set_DisplayLine5('WH Class Code' + ' :' + L_Item."Warehouse Class Code" + MobToolbox.CRLFSeparator() + 'Status: ' + _WhseActLineTake."Package No.");


                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", 'OnAfterCreateShptLineFromSalesLine', '', true, true)]
    local procedure OnAfterCreateShptLineFromSalesLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Validate(WarehouseShipmentNo, WarehouseShipmentHeader."No.");
        SalesHeader.Modify(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Pick", 'OnAfterCreateWhseDocument', '', true, true)]
    local procedure OnAfterCreateWhseDocument(var FirstWhseDocNo: Code[20]; var LastWhseDocNo: Code[20]; CreatePickParameters: Record "Create Pick Parameters")
    var

        Header: Record "Sales Header";
        WareActLine: Record "Warehouse Activity Line";
        WareShipHeader: Record "Warehouse Shipment Header";
        WareShipLine: Record "Warehouse Shipment Line";
        WareShipLine2: Record "Warehouse Shipment Line";
    begin
        WareActLine.Reset();
        WareActLine.SetRange("Activity Type", WareActLine."Activity Type"::Pick);
        WareActLine.SetRange("No.", FirstWhseDocNo);
        WareActLine.SetRange("Action Type", WareActLine."Action Type"::Place);
        if WareActLine.FindSet() then begin


            repeat
                Header.Reset();
                Header.SetRange("No.", WareActLine."Source No.");
                if Header.FindFirst() then begin
                    Header.Validate(WarehousePick, WareActLine."No.");
                    Header.Modify(true);
                end;
                WareShipLine.Reset();
                WareShipLine.SetRange("No.", WareActLine."Whse. Document No.");
                WareShipLine.SetRange("Line No.", WareActLine."Whse. Document Line No.");
                if WareShipLine.FindFirst() then begin
                    WareShipLine.Validate("Warehouse Pick No", WareActLine."No.");
                    WareShipLine.Modify(true);
                end;
            until WareActLine.Next() = 0;
            // WareShipLine2.Reset();
            // WareShipLine2.SetCurrentKey("Warehouse Pick No");
            // WareShipLine2.SetAscending("Warehouse Pick No", true);
            // WareShipLine2.SetRange("No.", WareShipLine."No.");
            // if WareShipLine2.FindSet() then begin
            // repeat
            WareShipHeader.Reset();
            WareShipHeader.SetRange("No.", WareShipLine."No.");
            if WareShipHeader.FindFirst() then begin
                if WareShipHeader."Warehouse Pick" = '' then begin
                    WareShipHeader.Validate("Warehouse Pick", WareShipLine."Warehouse Pick No");
                    WareShipHeader.Modify(true);
                end else begin
                    if WareShipHeader."Warehouse Pick" <> WareShipLine."Warehouse Pick No" then begin
                        WareShipHeader.Validate("Warehouse Pick", WareShipHeader."Warehouse Pick" + ',' + WareShipLine."Warehouse Pick No");
                        WareShipHeader.Modify(true);
                    end;
                end;
            end;
            // until WareShipLine2.Next() = 0;
            // end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterPostWhseShipment', '', true, true)]
    local procedure OnAfterPostWhseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SuppressCommit: Boolean; var IsHandled: Boolean)
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        SH: Record "Sales Header";
        PostedSalesShipment: Record "Sales Shipment Header";
    begin
        PostedWhseShipmentHeader.Reset();
        PostedWhseShipmentHeader.SetRange("Whse. Shipment No.", WarehouseShipmentHeader."No.");


        if PostedWhseShipmentHeader.FindFirst() then begin

            PostedWhseShipmentLine.Reset();
            PostedWhseShipmentLine.SetRange("No.", PostedWhseShipmentHeader."No.");
            if PostedWhseShipmentLine.FindSet() then begin
                repeat
                    SH.Reset();
                    SH.SetRange("Document Type", SH."Document Type"::Order);
                    SH.SetRange("No.", PostedWhseShipmentLine."Source No.");
                    if SH.FindFirst() then begin
                        SH.Validate(WarehouseShipmentNo, PostedWhseShipmentLine."No.");
                        SH.Modify(true);
                        PostedSalesShipment.SetRange("Order No.", SH."No.");
                        if PostedSalesShipment.FindFirst() then begin
                            PostedSalesShipment.Validate(WarehouseShipmentNo, PostedWhseShipmentLine."No.");
                            PostedSalesShipment.Modify(true);
                        end;
                    end;

                until PostedWhseShipmentLine.Next() = 0;
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnAfterRegisterWhseActivity', '', true, true)]
    local procedure OnAfterRegisterWhseActivity(var WarehouseActivityHeader: Record "Warehouse Activity Header")
    var
        RegisWhseActivityHeader: Record "Registered Whse. Activity Hdr.";
        RegisWhseActivityLine: Record "Registered Whse. Activity Line";
        SH: Record "Sales Header";
    begin
        RegisWhseActivityHeader.Reset();
        RegisWhseActivityHeader.SetRange("Whse. Activity No.", WarehouseActivityHeader."No.");

        if RegisWhseActivityHeader.FindFirst() then begin
            RegisWhseActivityLine.SetRange("No.", RegisWhseActivityHeader."No.");
            repeat
                SH.Reset();
                SH.SetRange("Document Type", SH."Document Type"::Order);
                SH.SetRange("No.", RegisWhseActivityLine."Source No.");
                if SH.FindFirst() then begin
                    SH.Validate(WarehousePick, RegisWhseActivityLine."No.");
                    SH.Modify(true);
                end;
            until RegisWhseActivityLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        DefaultOption := 1;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", 'OnAfterCreateRegActivLine', '', true, true)]
    local procedure OnAfterCreateRegActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line"; var RegisteredWhseActivLine: Record "Registered Whse. Activity Line"; var RegisteredInvtMovementLine: Record "Registered Invt. Movement Line")
    var
        WhseActivLn: Record "Warehouse Activity Line";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";

    begin
        clear(WhseActivLn);
        WhseActivLn.CopyFilters(WarehouseActivityLine);
        // WhseActivLn := WarehouseActivityLine;
        WhseActivLn.SetRange("Action Type", WhseActivLn."Action Type"::Place);
        if WhseActivLn.FindSet() then
            repeat
                WarehouseShipmentLine.Reset();
                WarehouseShipmentLine.SetRange("No.", WhseActivLn."Whse. Document No.");
                WarehouseShipmentLine.SetRange("Line No.", WhseActivLn."Whse. Document Line No.");
                if WarehouseShipmentLine.FindFirst() then begin
                    WarehouseShipmentLine."Picked by Username" := GetUserName(WhseActivLn.SystemCreatedBy);
                    WarehouseShipmentLine.Modify();
                end;
            until WhseActivLn.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Return Order Screen", 'OnAfterCreateSalesReturn', '', true, true)]
    local procedure OnAfterCreateSalesReturn(P_HISH: Record "Handled Interim Sales Header"; P_OrderNo: Code[20])
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        SalesShipmentHeader.Reset();
        SalesShipmentHeader.SetRange("Order No.", P_HISH."Destination Doc No.");
        if SalesShipmentHeader.FindFirst() then begin
            SalesShipmentHeader.Validate(SalesOrderReturnNo, P_OrderNo);
            SalesShipmentHeader.Modify(true);
        end;
    end;

    local procedure GetUserName(SystemCreatedBy: Guid): Text[100]
    var
        User: Record User;
    begin
        User.Reset();
        User.SetRange("User Security ID", SystemCreatedBy);
        if User.FindFirst() then
            exit(User."Full Name");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Planning Component", 'OnBeforeUpdateExpectedQuantityForPlanningNeeds', '', false, false)]

    local procedure OnBeforeUpdateExpectedQuantityForPlanningNeeds(var PlanningComponent: Record "Planning Component"; var IsHandled: Boolean)
    var
        CalcPlan: Report "Calculate Plan - Plan. Wksh.";
        UOMMgt: Codeunit "Unit of Measure Management";
        P: page 99000852;
    begin
        if PlanningComponent."Ref. Order Type" = PlanningComponent."Ref. Order Type"::Assembly then begin
            PlanningComponent.Quantity := Round(PlanningComponent.Quantity, 1, '>');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnAfterInsertAsmHeader', '', false, false)]
    local procedure OnAfterInsertAsmHeader(var AsmHeader: Record "Assembly Header")
    begin
        ReleaseAssemblyDocument.Run(AsmHeader);
    end;


    [EventSubscriber(ObjectType::Report, Report::"Carry Out Action Msg. - Plan.", 'OnBeforeRequisitionLineOnAfterGetRecord', '', false, false)]
    local procedure OnBeforeRequisitionLineOnAfterGetRecord(var RequisitionLine: Record "Requisition Line")
    var
        AsmHeader: Record "Assembly Header";
        BOMComponent: Record "BOM Component";
        Item: Record Item;

    begin
        if RequisitionLine."Ref. Order Type" = RequisitionLine."Ref. Order Type"::Assembly then begin
            BOMComponent.Reset();
            BOMComponent.SetRange("Parent Item No.", RequisitionLine."No.");
            if BOMComponent.FindSet() then
                repeat
                    Item.Get(BOMComponent."No.");
                    item.CalcFields(Inventory);
                    if Item.Inventory < BOMComponent."Quantity per" then begin
                        RequisitionLine."Accept Action Message" := false;
                        RequisitionLine."Component Out Of Stock" := true;
                        RequisitionLine.Modify();
                    end;
                until BOMComponent.Next() = 0;

            if RequisitionLine."Action Message" = RequisitionLine."Action Message"::"Change Qty." then begin
                if AsmHeader.Get(AsmHeader."Document Type"::Order, RequisitionLine."Ref. Order No.") then begin
                    ReleaseAssemblyDocument.Reopen(AsmHeader);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Item Unit of Measure", 'OnAfterCalcWeight', '', false, false)]
    local procedure OnAfterCalcWeight(var ItemUnitOfMeasure: Record "Item Unit of Measure")
    begin
        ItemUnitOfMeasure."Qty. Rounding Precision" := 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Phys. Invt. Count.-Management", 'OnRunOnAfterSetItemFilters', '', false, false)]
    local procedure OnRunOnAfterSetItemFilters(var Item: Record Item; SourceJnl: Option ItemJnl,WhseJnl,PhysInvtOrder,Custom)
    begin
        Item.CalcFields("Stockkeeping Unit Exists");
        Item.SetRange("Stockkeeping Unit Exists", false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Assembly Document", 'OnBeforeReleaseAssemblyDoc', '', false, false)]
    local procedure OnBeforeReleaseAssemblyDoc(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
    begin
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetFilter(Type, '<>%1', AssemblyLine.Type::" ");
        AssemblyLine.SetFilter(Quantity, '<>0');
        if not AssemblyLine.Find('-') then
            Error(StrSubstNo('There is nothing to release for %1 %2 with Product %3.', AssemblyHeader."Document Type", AssemblyHeader."No.", AssemblyHeader."Item No."));
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Bin Content", 'OnAfterBinContentExists', '', false, false)]
    local procedure OnAfterBinContentExists(var BinContent: Record "Bin Content")
    begin
        BinContent.Ascending(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean; TempSalesLine: Record "Sales Line" temporary; SalesInvHeader: Record "Sales Header")
    begin
        SalesLine."Channel Order ID" := SalesShptLine."Channel Order ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Assembly", 'OnGetAssemblyOrders_OnSetFilterAssemblyHeader', '', true, true)]
    local procedure MyOnGetAssemblyOrders_OnSetFilterAssemblyHeader(_HeaderFilter: Record "MOB NS Request Element"; var _AssemblyHeader: Record "Assembly Header"; var _AssemblyLine: Record "Assembly Line"; var _IsHandled: Boolean)
    var
        MobItemReferenceMgt: Codeunit "MOB Item Reference Mgt.";
        VariantCode: Code[10];
    begin
        if _HeaderFilter.Name = 'ScannedValue' then begin
            _AssemblyHeader.SetRange("Item No.", MobItemReferenceMgt.SearchItemReference(_HeaderFilter."Value", VariantCode));
            if VariantCode <> '' then
                _AssemblyHeader.SetRange("Variant Code", VariantCode);
        end;
        _IsHandled := true;
    end;


    var
        ReleaseAssemblyDocument: Codeunit "Release Assembly Document";
}
