report 60049 "Sample Docket Bin"
{
    RDLCLayout = '.\src\reportlayouts\BinBarcode\SampleDocketLabel.rdl';
    // UseRequestPage = false;

    dataset
    {
        dataitem(Bin_; "Bin")
        {
            RequestFilterFields = Code, "Location Code", "Zone Code";
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


            trigger OnAfterGetRecord()
            begin

                Clear(BarcodeText);
                Clear(recTmpBlob1);
                Clear(recTmpBlob2);
                Clear(BarcodeMgt);
                BarcodeText := Bin_.Code;
                BarcodeMgt.EncodeCode128(BarcodeText, 1, false, recTmpBlob1);
                BarcodeMgt.EncodeCode128(BarcodeText, 1, false, recTmpBlob2);
            end;


        }


    }





    var


        G_BinTBA: Record Bin;
        recTmpBlob1: Record "Name/Value Buffer" temporary;//pranali
        recTmpBlob2: Record "Name/Value Buffer" temporary;//pranali
        BarcodeMgt: Codeunit "Barcode Management ROBO";//pranali
        Bin_ZoneCode: Code[10];
        BarcodeText: Code[20];

        G_Bincode: Text;

}

