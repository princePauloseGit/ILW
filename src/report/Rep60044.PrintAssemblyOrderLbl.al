report 60044 "PrintAssemblyOrderLbl"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    // DefaultLayout = RDLC;
    // RDLCLayout = './AssmOrderLabel2.rdl';
    DefaultRenderingLayout = AssmOrderLabel1;


    dataset
    {
        dataitem(RecAssHdr; "Assembly Header")
        {
            RequestFilterFields = "No.";

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(No_; RecAssHdr."No.")
                    {

                    }
                    column(Item_No_; RecAssHdr."Item No.")
                    {

                    }
                    column(Description; RecAssHdr.Description)
                    {

                    }
                    column(Outputno; OutputNo) { }
                    column(CopyText; CopyText) { }
                    column(NoOfCopies; NoOfCopies) { }
                    column(FootterText; FootterText) { }
                    column(Barcode; EncodedText)
                    {
                    }
                    column(EncodedText; EncodedText) { }
                    column(QrCode; QrCode)
                    {

                    }
                    column(EncodeGTIN; EncodeGTIN) { }

                    column(BOMItemNames; BOMItemNames)
                    {
                    }
                }
                trigger OnAfterGetRecord();
                var
                    Item: Record Item;
                    RecItecCrossReff: Record "Item Reference";
                    RecordLink: Record "Record Link";
                    BarcodeSymbology: Enum "Barcode Symbology";
                    BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    BarcodeFontProvider: Interface "Barcode Font Provider";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                    BarcodeString: Text;
                    QrText: Text;
                    BOMLine: Record "Assembly Line";
                begin
                    Clear(FootterText);
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;

                    if OutputNo = NoOfCopies then begin
                        FootterText := '1 of 1';
                    end else begin
                        FootterText := Format(OutputNo) + ' of ' + Format(NoOfCopies - 1);
                    end;

                    // Reset BOM item names
                    Clear(BOMItemNames);

                    // Loop through BOM components for the Item and concatenate names
                    BOMLine.Reset();
                    BOMLine.SetRange("Document No.", RecAssHdr."No.");
                    BOMLine.SetRange("Document Type", "Assembly Document Type"::Order);
                    BOMLine.SetRange(Type, "BOM Component Type"::Item);
                    if BOMLine.FindSet() then begin
                        repeat
                            if BOMItemNames <> '' then
                                BOMItemNames := BOMItemNames + ', ';

                            BOMItemNames := BOMItemNames + BOMLine.Description;
                        until BOMLine.Next() = 0;
                    end;

                    Clear(BarcodeFontProvider);
                    Clear(BarcodeSymbology);
                    Clear(BarcodeString);
                    Clear(EncodedText);

                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbology := Enum::"Barcode Symbology"::Code128;

                    RecItecCrossReff.Reset();
                    RecItecCrossReff.SetRange("Item No.", RecAssHdr."Item No.");
                    RecItecCrossReff.SetRange("Reference Type", RecItecCrossReff."Reference Type"::"Bar Code");
                    RecItecCrossReff.SetRange(isQRLabel, true);

                    if RecItecCrossReff.FindFirst() then begin
                        BarcodeString := RecItecCrossReff."Reference No.";

                        // Validate the input. This method is n5ot available for 2D provider
                        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);

                        Clear(EncodeGTIN);
                        Clear(BarcodeString);
                        BarcodeString := RecItecCrossReff."Reference No.";
                        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                        EncodeGTIN := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
                    end;

                    Clear(BarcodeFontProvider);
                    Clear(BarcodeSymbology);
                    Clear(BarcodeString);
                    Clear(EncodedText);

                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbology := Enum::"Barcode Symbology"::Code128;

                    RecItecCrossReff.Reset();
                    RecItecCrossReff.SetRange("Item No.", RecAssHdr."Item No.");
                    RecItecCrossReff.SetRange("Reference Type", RecItecCrossReff."Reference Type"::"Bar Code");
                    RecItecCrossReff.SetRange(isLabelBarcode, true);
                    if RecItecCrossReff.FindFirst() then begin
                        EncodedText := RecItecCrossReff."Reference No.";
                        BarcodeFontProvider.ValidateInput(EncodedText, BarcodeSymbology);
                        EncodedText := BarcodeFontProvider.EncodeFont(EncodedText, BarcodeSymbology);
                    end;


                    //Create QrCode
                    Clear(QrText);
                    Clear(QrCode);
                    Clear(BarcodeFontProvider);
                    Clear(BarcodeSymbology);

                    BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                    BarcodeSymbology := Enum::"Barcode Symbology"::Code128;
                    Item.Reset();
                    Item.SetRange("No.", RecAssHdr."Item No.");
                    if Item.FindFirst() then begin
                        RecordLink.Reset();
                        RecordLink.SetRange("Record ID", Item.RecordId);
                        RecordLink.SetRange(Type, RecordLink.Type::Link);
                        if RecordLink.FindFirst() then begin
                            QrText := RecordLink.URL1;
                            BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                            BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                            QrCode := BarcodeFontProvider2D.EncodeFont(QrText, BarcodeSymbology2D);
                        end;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies);
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
            begin

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
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No Of Copies';
                        ApplicationArea = all;
                        Visible = true;

                    }
                }
            }
        }
        trigger OnOpenPage()
        var
        begin

        end;

    }

    rendering
    {
        layout(AssmOrderLabel1)
        {
            Type = RDLC;
            LayoutFile = './AssmOrderLabel2.rdl';
        }
        layout(AssmOrderLabel2)
        {
            Type = RDLC;
            LayoutFile = './AssemblyOrderLabelNewTemplate.rdl';
        }
    }


    var
        FormatDocument: Codeunit "Format Document";
        ShowUnitCost: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        EncodedText, BOMItemNames : Text;
        EncodeGTIN: Text;
        FootterText: Text;
        QrCode: Text;
        CopyText: Text[30];

    procedure GetnoofCpoies(VarNoofCopies: Integer)
    var
    begin
        Clear(NoOfCopies);
        NoOfCopies := VarNoofCopies;
    end;
}