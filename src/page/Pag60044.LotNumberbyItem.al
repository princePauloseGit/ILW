page 60044 "Lot-Number-by-Item"
{

    Caption = 'Lot No. by Item';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = 7351;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    Visible = false;

                }

                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }

                field("Quantity (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
    }



    trigger OnFindRecord(Which: Text): Boolean
    begin
        FillTempTable;
        EXIT(Rec.FIND(Which));
    end;

    var
        UserSetup: Record 91;
        ResponsibilityCenter: Record 5714;


    local procedure FillTempTable()
    var
        LotNosByBinCode: Query "LotNumber WarehouseEntry New";
    begin
        Rec.DELETEALL;
        LotNosByBinCode.SETRANGE(Item_No, Rec.GETRANGEMIN("Item No."));
        // Manish ++
        IF UserSetup.GET(USERID) THEN BEGIN
            IF ResponsibilityCenter.GET(UserSetup."Sales Resp. Ctr. Filter") THEN BEGIN
                //SETFILTER("Location Filter",ResponsibilityCenter."Location Code");
                //CALCFIELDS(Inventory);
                LotNosByBinCode.SETRANGE(LotNosByBinCode.Location_Code, ResponsibilityCenter."Location Code");
            END
        END;
        // Manish --

        LotNosByBinCode.OPEN;

        WHILE LotNosByBinCode.READ DO BEGIN
            Rec.INIT;
            Rec."Item No." := LotNosByBinCode.Item_No;
            Rec."Variant Code" := LotNosByBinCode.Variant_Code;
            Rec."Location Code" := LotNosByBinCode.Location_Code;
            Rec."Zone Code" := LotNosByBinCode.Zone_Code;
            Rec."Bin Code" := LotNosByBinCode.Bin_Code;
            Rec."Qty. (Base)" := LotNosByBinCode.Sum_Quantity;
            IF Rec."Qty. (Base)" <> 0 THEN
                Rec.INSERT;
        END;
    end;

}


