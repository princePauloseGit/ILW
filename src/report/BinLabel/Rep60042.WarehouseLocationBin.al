
report 60042 "Bin Label"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Warehouse Location Bin';
    DefaultLayout = RDLC;
    RDLCLayout = '.\src\reportlayouts\BinBarcode\WarehouseLocationLabel.rdl'; // this will print warehouse location label   by default

    dataset
    {
        dataitem(Bin_; "Bin")
        {
            //RequestFilterFields = "Location Code", "Zone Code", Code;
            column(recTmpBlob1_Blob; recTmpBlob1."Value BLOB")
            {
            }
            column(recTmpBlob2_Blob; recTmpBlob2."Value BLOB")
            {
            }
            column(BarcodeText; BarcodeText)
            {

            }
            column(Bin_Code; Code)
            {

            }
            // column(Label1; Label1)
            // {

            // }
            // column(Label2; Label2)
            // {

            // }
            trigger OnAfterGetRecord()
            begin

                Clear(BarcodeText);
                Clear(recTmpBlob1);
                Clear(recTmpBlob2);
                Clear(BarcodeMgt);
                BarcodeText := Bin_.Code;
                BarcodeMgt.EncodeCode128(BarcodeText, 1, true, recTmpBlob1);
                BarcodeMgt.EncodeCode128(BarcodeText, 1, true, recTmpBlob2);

            end;


        }


    }



    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Bin Label")
                {

                    field("Label Type"; BinLabelType)
                    {

                        ApplicationArea = all;
                        Caption = 'Label Size';


                    }
                }

            }
        }
    }


    trigger OnPreReport()
    var
        PortableBarcodeBinReport: Report "Portable Barcode Bin";
        SampleDocketBinReport: Report "Sample Docket Bin";
        WarehouseDocketBinReport: Report "Warehouse Docket Bin";
    begin
        if BinLabelType = Enum::BinLabelType::None then
            Error('Select a Bin Label Type');

        if BinLabelType = Enum::BinLabelType::"Warehouse Location Barcode" then
            exit;

        if BinLabelType = Enum::BinLabelType::"Sample Docket Barcode" then begin
            SampleDocketBinReport.SetTableView(Bin_);
            SampleDocketBinReport.UseRequestPage(false);
            SampleDocketBinReport.RunModal();
            CurrReport.Quit();
        end;

        if BinLabelType = Enum::BinLabelType::"Warehouse Docket Barcode" then begin
            WarehouseDocketBinReport.SetTableView(Bin_);
            WarehouseDocketBinReport.UseRequestPage(false);
            WarehouseDocketBinReport.RunModal();
            CurrReport.Quit();
        end;

        if BinLabelType = Enum::BinLabelType::"Portable Barcode" then begin
            PortableBarcodeBinReport.SetTableView(Bin_);
            PortableBarcodeBinReport.UseRequestPage(false);
            PortableBarcodeBinReport.RunModal();
            CurrReport.Quit();
        end;
    end;









    var

        recTmpBlob1: Record "Name/Value Buffer" temporary;//pranali
        recTmpBlob2: Record "Name/Value Buffer" temporary;//pranali
        BarcodeMgt: Codeunit "Barcode Management ROBO";//pranali
        Bin_ZoneCode: Code[10];
        BarcodeText: Code[20];

        BinLabelType: Enum BinLabelType;
        G_Bincode: Text;

}

