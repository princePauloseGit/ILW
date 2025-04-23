tableextension 60054 PostedWhseShipmentHeaderExt extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(60041; "Scanned By"; Code[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Whse. Shipment Line"."Scanned By" where("No." = field("No."), "Line No." = const(10000)));
        }
    }
}
