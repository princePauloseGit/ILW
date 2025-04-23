report 60043 "ImportAssemblyOrders"
{
    ApplicationArea = All;
    Caption = 'Import Assembly Orders';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(number) where(number = const(1));
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(ServerFileName; ServerFileName)
                    {
                        ApplicationArea = all;
                        Caption = 'File Name';
                        trigger OnAssistEdit()
                        begin
                            UploadIntoStream('Please Choose the Excel file.', '', '', FromServerFileName, Istream);
                            if FromServerFileName <> '' then
                                ServerFileName := FileMgt.GetFileName(FromServerFileName)
                            else
                                Error('File does not exit');
                        end;
                    }
                    /*field(SheetName; SheetName)
                    {
                        ApplicationArea = all;
                        Caption = 'Sheet Name';
                        trigger OnAssistEdit()
                        var
                            myInt: Integer;
                        begin
                            SheetName := ExcelBuffer.SelectSheetsNameStream(Istream);
                            IF SheetName = '' THEN
                                ERROR('');
                        end;
                    }*/
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var

        ExcelBuffer: record "Excel Buffer" temporary;
        FileMgt: Codeunit "File Management";
        Istream: InStream;
        TotalRows: Integer;
        X: Integer;
        FromServerFileName: Text;
        ServerFileName: Text;
        SheetName: Text;


    trigger OnPreReport()
    var
        ErrorMessage, SheetName : Text;
    begin
        ExcelBuffer.DELETEALL;
        ExcelBuffer.LOCKTABLE;
        SheetName := ExcelBuffer.SelectSheetsNameStream(Istream);
        ErrorMessage := ExcelBuffer.OpenBookStream(Istream, SheetName);
        if ErrorMessage <> '' then begin
            Error(ErrorMessage);
            exit;
        end;
        ExcelBuffer.ReadSheet;
        GetLastRow;
        FOR X := 2 TO TotalRows DO
            InsertData(X);
        ExcelBuffer.DELETEALL;
    end;

    local procedure GetLastRow()
    begin
        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    local procedure InsertData(RowNo: Integer)
    var
        AsmHdr: Record "Assembly Header";
        AsmLn: Record "Assembly Line";
        AssemblyLine: Record "Assembly Line";
        AsmSetup: Record "Assembly Setup";
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        L_ItemNo: Code[20];
        L_Qty: Decimal;
        L_QtytoConsume: Decimal; //Nikhil_30/05/2022_User Story 5590: Auto creation of Assembly Orders
    begin
        Clear(L_ItemNo);
        Clear(L_Qty);
        Clear(L_QtytoConsume);

        IF GetValueAtCell(RowNo, 1) <> '' THEN
            L_ItemNo := GetValueAtCell(RowNo, 1)
        ELSE
            ERROR('Item No. must not be blank');

        IF GetValueAtCell(RowNo, 2) <> '0' THEN
            Evaluate(L_Qty, GetValueAtCell(RowNo, 2))
        ELSE
            ERROR('Qty must not be blank');

        IF (GetValueAtCell(RowNo, 3) <> '0') AND (GetValueAtCell(RowNo, 3) <> '') THEN
            Evaluate(L_QtytoConsume, GetValueAtCell(RowNo, 3));

        if Item.Get(L_ItemNo) then begin
            AsmSetup.Get();
            AsmHdr.Init();
            AsmHdr.Validate("Document Type", AsmHdr."Document Type"::Order);
            //AsmHdr.Validate("No.", NoSeriesMgt.GetNextNo(AsmSetup."Assembly Order Nos.", Today, true));
            //AsmHdr.Validate("Posting Date", Today);
            AsmHdr.Insert(true);
            AsmHdr.Validate("Due Date", Today);
            AsmHdr.Validate("Item No.", Item."No.");
            AsmHdr.Validate("Location Code", 'OAKESWAY');
            AsmHdr.Validate(Quantity, L_Qty);
            AsmHdr.Modify(true);

            //Nikhil_30/05/2022_User Story 5590: Auto creation of Assembly Orders
            if L_QtytoConsume <> 0 then begin
                AsmLn.Reset();
                AsmLn.SetRange("Document Type", AsmHdr."Document Type");
                AsmLn.SetRange("Document No.", AsmHdr."No.");
                if AsmLn.FindSet() then
                    repeat
                        AsmLn.Validate("Quantity to Consume", L_QtytoConsume);
                        AsmLn.Modify(true);
                    until AsmLn.Next() = 0;
            end;

            //AsmHdr.Validate(Status, AsmHdr.Status::Released);
            //AsmHdr.Modify();
            AssemblyLine.SetRange("Document Type", AsmHdr."Document Type");
            AssemblyLine.SetRange("Document No.", AsmHdr."No.");
            AssemblyLine.SetFilter(Type, '<>%1', AssemblyLine.Type::" ");
            AssemblyLine.SetFilter(Quantity, '<>0');
            if not AssemblyLine.Find('-') then
                Error(StrSubstNo('There is nothing to release for %1 %2 with Product %3.', AsmHdr."Document Type", AsmHdr."No.", AsmHdr."Item No."));

            CODEUNIT.Run(CODEUNIT::"Release Assembly Document", AsmHdr);
            Commit();
            //Nikhil_30/05/2022_User Story 5590: Auto creation of Assembly Orders
        end
        else
            Error('%1 Item not found in the system', L_ItemNo);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): text
    var
        myInt: Integer;
    begin
        ExcelBuffer.Reset();
        ExcelBuffer.SetRange("Row No.", RowNo);
        ExcelBuffer.SetRange("Column No.", ColNo);
        if ExcelBuffer.FindFirst() then
            EXIT(ExcelBuffer."Cell Value as Text");
    end;

}
