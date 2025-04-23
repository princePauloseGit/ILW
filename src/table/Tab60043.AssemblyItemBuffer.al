table 60043 "Assembly Item Buffer"
{
    Caption = 'Assembly Item Buffer';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Item No."; Code[20])
        {
        }

        field(2; "Required Quantity"; Integer)
        {

        }

        field(3; "Insufficient Stock"; Boolean)
        {

        }

        field(4; "Item Category Code"; Code[20])
        {

        }

    }
    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }

    procedure InsertIntoBuffer(ItemNo: Code[20]; RequiredQuantity: Integer; InsufficientStock: Boolean; ItemCategoryCode: Code[20])
    begin
        "Item No." := ItemNo;
        "Required Quantity" := RequiredQuantity;
        "Insufficient Stock" := InsufficientStock;
        "Item Category Code" := ItemCategoryCode;
        if not Get(ItemNo) then
            Insert();
    end;
}
