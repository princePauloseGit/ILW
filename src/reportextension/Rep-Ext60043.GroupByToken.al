reportextension 60043 "Group By Token" extends "Picking List"
{
    RDLCLayout = 'PickingList_V19_Latest.rdl';

    dataset
    {
        add("Warehouse Activity Header")
        {
            column(recTmpBlob2; recTmpBlob2."Value BLOB")
            {

            }
            column(TrolleyNoBarcode; TrolleyNoBarcode)
            {

            }
            column(Trolley_No_Header; "Trolley No.")
            {

            }
            column(recTemBlob4; recTemBlob4."Value BLOB")
            {

            }
            column(PickNoBarcode; PickNoBarcode)
            {

            }
            column(G_Flag; G_Flag)
            {

            }
            column(G_TrollyNocode; G_TrollyNocode)
            {

            }
            column(Total_Picked_Qty; Total_Picked_Qty)
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Comments; Comments)
            {

            }

        }
        modify("Warehouse Activity Header")
        {

            trigger OnAfterAfterGetRecord()
            begin
                Clear(TrolleyNoBarcode);
                Clear(recTmpBlob2);
                Clear(cduBarcodeMgt);
                TrolleyNoBarcode := "Warehouse Activity Header"."Trolley No.";
                cduBarcodeMgt.EncodeCode128(TrolleyNoBarcode, 1, false, recTmpBlob2);
                G_TrollyNocode := "Warehouse Activity Header"."Trolley No.";
                //Pranali++
                Clear(PickNoBarcode);
                Clear(recTemBlob4);
                Clear(cduBarcodeMgt);
                PickNoBarcode := "Warehouse Activity Header"."No.";
                cduBarcodeMgt.EncodeCode128(PickNoBarcode, 1, false, recTemBlob4);
                //Pranali--

                Clear(G_Flag);
                if "Warehouse Activity Header"."Trolley No." <> '' then
                    G_Flag := false
                else
                    G_Flag := true;
            end;

        }

        add(WhseActLine)
        {


            column(Source_No_; "Source No.")
            {

            }
            column(Whse__Document_No_; "Whse. Document No.")
            {

            }
            column(Trolley_Bay_No_; "Trolley No.")
            {

            }
            column(Bay_No_; "Bay No.")
            {

            }
            column(BarcodeText; BarcodeText)
            {

            }
            column(recTmpBlob3; recTmpBlob3."Value BLOB")
            {

            }
            column(GroupByBay; GroupByBay)
            {

            }
            column(G_Caption; G_Caption)
            {

            }
            column(G_BayNocode; G_BayNocode)
            {

            }
            column(Channel_Order_ID; "Channel Order ID")
            {

            }
            column(ExternalReferenceNo; ExternalReferenceNo)
            {

            }

        }

        modify(WhseActLine)
        {


            trigger OnAfterAfterGetRecord()
            var
                SH: Record "Sales Header";
            begin
                Clear(BarcodeText);
                Clear(recTmpBlob3);
                Clear(cduBarcodeMgt);
                if WhseActLine."Source Document" = WhseActLine."Source Document"::" " then begin
                    BarcodeText := WhseActLine."Bay No.";
                    // G_BayNocode := WhseActLine."Bay No.";
                end
                else
                    BarcodeText := WhseActLine."Whse. Document No.";
                if BarcodeText <> '' then
                    cduBarcodeMgt.EncodeCode128(BarcodeText, 1, false, recTmpBlob3);


                Clear(GroupByBay);
                if WhseActLine."Bay No." = '' then
                    GroupByBay := WhseActLine."Trolley No."
                else
                    GroupByBay := WhseActLine."Bay No.";


                Clear(G_Caption);
                if WhseActLine."Source Document" = WhseActLine."Source Document"::" " then
                    G_Caption := 'Bay No.'
                else
                    G_Caption := 'Warehouse Shipment No.';

                Clear(ExternalReferenceNo);
                if WhseActLine."Source Document" = WhseActLine."Source Document"::"Sales Order" then begin
                    SH.Reset();
                    SH.SetRange("Document Type", SH."Document Type"::Order);
                    SH.SetRange("No.", WhseActLine."Source No.");
                    if SH.FindFirst() then
                        ExternalReferenceNo := SH."External Document No.";
                end;
            end;
        }
        modify("Warehouse Activity Line")
        {
            trigger OnBeforePreDataItem()
            begin
                "Warehouse Activity Line".SetFilter("Action Type", '<>%1', "Warehouse Activity Line"."Action Type"::Place);

            end;
        }


    }
    var
        recTemBlob4: Record "Name/Value Buffer" temporary;//Pranali
        recTmpBlob2: Record "Name/Value Buffer" temporary;
        recTmpBlob3: Record "Name/Value Buffer" temporary;
        cduBarcodeMgt: Codeunit "Barcode Management ROBO";
        G_Flag: Boolean;
        BarcodeText: Code[20];

        G_BayNocode: code[20];
        G_TrollyNocode: code[20];
        GroupByBay: Code[20];
        PickNoBarcode: Code[20];//Pranali
        TrolleyNoBarcode: Code[20];
        ExternalReferenceNo: Code[35];
        Total_Picked_Qty: Decimal;
        G_Caption: Text[250];
}