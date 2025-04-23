tableextension 60044 "Bin Content Ext" extends "Bin Content"
{
    fields
    {
        // Add changes to table fields here
        field(60041; "Safety Stock Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Safety Stock Quantity" where("No." = field("Item No.")));
        }
        field(60042; "Blocked"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
        }
    }

    var
        myInt: Integer;
}