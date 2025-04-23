tableextension 60046 "Ext Purch Line" extends "Purchase Line"
{
    fields
    {
        field(60046; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Buy-from Vendor No.")));
        }
    }
}