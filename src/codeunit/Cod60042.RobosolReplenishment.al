codeunit 60042 "Robosol Replenishment"
{
    trigger OnRun()
    begin

    end;

    procedure ReplenishBin(Item: Record item)
    var
        binContent: record "Bin Content";
        FromBinContent: record "Bin Content";
        Location: record Location;
        WhseWkshLine2: Record "Whse. Worksheet Line";
        R7300m: Report 7300;
        ToBin: code[20];
        ToZone: code[20];
        MovementQtyBase: Decimal;
        QtyAvailToTakeBase: Decimal;
        TotalAvailableQuantity: Decimal;
    begin
        Location.Reset();
        if LocationCode <> '' then
            Location.SetRange(Code, LocationCode);
        Location.SetRange("Directed Put-away and Pick", true);
        Location.SetRange("Use As In-Transit", false);
        if Location.FindSet() then
            repeat
                binContent.Reset();
                binContent.SetRange("Location Code", Location.Code);
                binContent.SetRange("Item No.", Item."No.");
                binContent.SetFilter("Bin Type Code", 'Pick|PUTPICK');
                IF binContent.FindSet() then
                    repeat
                        TotalAvailableQuantity := TotalAvailableQuantity + binContent.CalcQtyAvailToTakeUOM();
                    until binContent.Next() = 0;

                RemainQtyToReplenishBase := Item."Replanish Quantity";

                if TotalAvailableQuantity < Item."Minimum Pick Face qty" then begin
                    FromBinContent.Reset();
                    FromBinContent.SetCurrentKey(
                        "Location Code", "Item No.", "Variant Code", "Cross-Dock Bin",
                        "Qty. per Unit of Measure", "Bin Ranking");
                    FromBinContent.Ascending(true);
                    FromBinContent.SetRange("Location Code", Location.Code);
                    FromBinContent.SetRange("Item No.", Item."No.");

                    //FromBinContent.SetRange("Variant Code", "Variant Code");
                    FromBinContent.SetRange("Cross-Dock Bin", false);
                    //FromBinContent.SetRange("Qty. per Unit of Measure", "Qty. per Unit of Measure");
                    //fromBinContent.SetFilter("Bin Ranking", '<%1', "Bin Ranking");
                    if FromBinContent.FindSet() then begin
                        WhseWkshLine2.Copy(TempWhseWkshLine);
                        TempWhseWkshLine.SetCurrentKey(
                              "Item No.", "From Bin Code", "Location Code", "Variant Code", "From Unit of Measure Code");
                        TempWhseWkshLine.SetRange("Item No.", FromBinContent."Item No.");
                        TempWhseWkshLine.SetRange("Location Code", FromBinContent."Location Code");
                        TempWhseWkshLine.SetRange("Variant Code", FromBinContent."Variant Code");
                        repeat
                            if UseForReplenishment(FromBinContent) then begin
                                QtyAvailToTakeBase := FromBinContent.CalcQtyAvailToTake(0);
                                TempWhseWkshLine.SetRange("From Bin Code", FromBinContent."Bin Code");
                                TempWhseWkshLine.SetRange("From Unit of Measure Code", FromBinContent."Unit of Measure Code");

                                TempWhseWkshLine.CalcSums("Qty. (Base)");
                                QtyAvailToTakeBase := QtyAvailToTakeBase - TempWhseWkshLine."Qty. (Base)";
                                if QtyAvailToTakeBase > 0 then begin
                                    if QtyAvailToTakeBase < RemainQtyToReplenishBase then
                                        MovementQtyBase := QtyAvailToTakeBase
                                    else
                                        MovementQtyBase := RemainQtyToReplenishBase;
                                    FindToBinandZone(ToBin, ToZone, FromBinContent."Item No.", FromBinContent."Location Code");
                                    CreateWhseWkshLine(ToBin, ToZone, FromBinContent, MovementQtyBase);
                                    RemainQtyToReplenishBase := RemainQtyToReplenishBase - MovementQtyBase;
                                end;
                            end;
                        until (FromBinContent.Next() = 0) or (RemainQtyToReplenishBase = 0);
                        TempWhseWkshLine.Copy(WhseWkshLine2);
                        //end; 
                    end;
                end;

            until Location.Next() = 0;
    end;

    local procedure UseForReplenishment(FromBinContent: Record "Bin Content"): Boolean
    begin
        if FromBinContent."Block Movement" in
           [FromBinContent."Block Movement"::Outbound,
            FromBinContent."Block Movement"::All]
        then
            exit(false);
        if not ((FromBinContent."Zone Code" = 'TEMWHSSTRG') or (FromBinContent."Zone Code" = 'WHSESTORGE')) then begin
            exit(false);
        end;
        GetBinType(FromBinContent."Bin Type Code");
        exit(not (BinType.Receive or BinType.Ship or BinType.Pick));
    end;

    local procedure FindToBinandZone(Var ToBin: code[20]; Var ToZone: code[20]; P_Item: code[20]; P_Location: code[20])
    var
        BinContent: record "Bin Content";
    begin
        BinContent.Reset();
        BinContent.SetCurrentKey(
                "Location Code", "Item No.", "Variant Code", "Cross-Dock Bin",
                "Qty. per Unit of Measure", "Bin Ranking");
        BinContent.Ascending(true);
        BinContent.SetRange("Location Code", P_Location);
        BinContent.SetRange("Item No.", P_Item);
        BinContent.SetRange("Cross-Dock Bin", false);
        if BinContent.FindFirst() then
            repeat
                GetBinType(BinContent."Bin Type Code");
                if (BinType.Pick) AND (NOT BinType."Put Away") then begin
                    BinContent.CalcFields("Quantity (Base)");
                    if BinContent."Quantity (Base)" > 0 then begin
                        ToBin := BinContent."Bin Code";
                        ToZone := BinContent."Zone Code";
                    end;
                end;
            Until BinContent.Next() = 0;
    end
    ;

    local procedure GetBinType(BinTypeCode: Code[10])
    begin
        if BinTypeCode = '' then
            BinType.Init
        else
            if BinType.Code <> BinTypeCode then
                BinType.Get(BinTypeCode);
    end;

    local procedure CreateWhseWkshLine(P_ToBin: Code[20]; P_ToZone: code[20]; FromBinContent: Record "Bin Content"; MovementQtyBase: Decimal)
    begin
        TempWhseWkshLine.Init();
        TempWhseWkshLine."Worksheet Template Name" := WhseWkshTemplateName;
        TempWhseWkshLine.Name := WhseWkshName;
        TempWhseWkshLine."Location Code" := FromBinContent."Location Code";
        TempWhseWkshLine."Line No." := NextLineNo;
        TempWhseWkshLine."From Bin Code" := FromBinContent."Bin Code";
        TempWhseWkshLine."From Zone Code" := FromBinContent."Zone Code";
        TempWhseWkshLine."From Unit of Measure Code" := FromBinContent."Unit of Measure Code";
        TempWhseWkshLine."Qty. per From Unit of Measure" := FromBinContent."Qty. per Unit of Measure";
        TempWhseWkshLine."To Bin Code" := P_ToBin;
        TempWhseWkshLine."To Zone Code" := P_ToZone;
        TempWhseWkshLine."Unit of Measure Code" := FromBinContent."Unit of Measure Code";
        TempWhseWkshLine."Qty. per Unit of Measure" := FromBinContent."Qty. per Unit of Measure";
        TempWhseWkshLine."Item No." := FromBinContent."Item No.";
        TempWhseWkshLine.Validate("Variant Code", FromBinContent."Variant Code");
        TempWhseWkshLine.Validate(Quantity, Round(MovementQtyBase / FromBinContent."Qty. per Unit of Measure", UOMMgt.QtyRndPrecision));

        TempWhseWkshLine."Qty. (Base)" := MovementQtyBase;
        TempWhseWkshLine."Qty. Outstanding (Base)" := MovementQtyBase;
        TempWhseWkshLine."Qty. to Handle (Base)" := MovementQtyBase;

        TempWhseWkshLine."Whse. Document Type" := TempWhseWkshLine."Whse. Document Type"::"Whse. Mov.-Worksheet";
        TempWhseWkshLine."Whse. Document No." := WhseWkshName;
        TempWhseWkshLine."Whse. Document Line No." := TempWhseWkshLine."Line No.";
        TempWhseWkshLine.Insert();

        NextLineNo := NextLineNo + 10000;
    end;

    procedure SetWhseWorksheet(WhseWkshTemplateName2: Code[10]; WhseWkshName2: Code[10]; LocationCode2: Code[10])
    var
        WhseWkshLine: Record "Whse. Worksheet Line";
    begin
        TempWhseWkshLine.DeleteAll();
        WhseWkshLine.SetRange("Worksheet Template Name", WhseWkshTemplateName2);
        WhseWkshLine.SetRange(Name, WhseWkshName2);
        WhseWkshLine.SetRange("Location Code", LocationCode2);
        if WhseWkshLine.FindLast() then
            NextLineNo := WhseWkshLine."Line No." + 10000
        else
            NextLineNo := 10000;

        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2
    end;

    procedure InsertWhseWkshLine() Result: Boolean
    var
        WhseWkshLine: Record "Whse. Worksheet Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Result);

        TempWhseWkshLine.Reset();
        TempWhseWkshLine.SetFilter(Quantity, '>0');
        if TempWhseWkshLine.Find('-') then begin
            repeat
                WhseWkshLine.Init();
                WhseWkshLine := TempWhseWkshLine;
                WhseWkshLine.Insert();
            until TempWhseWkshLine.Next() = 0;
            exit(true);
        end;
        exit(false);
    end;

    var
        BinType: Record "Bin Type";
        TempWhseWkshLine: Record "Whse. Worksheet Line" temporary;
        UOMMgt: Codeunit "Unit of Measure Management";
        WhseWkshName: Code[10];
        WhseWkshTemplateName: Code[10];
        LocationCode: Code[20];
        RemainQtyToReplenishBase: Decimal;
        NextLineNo: Integer;
}