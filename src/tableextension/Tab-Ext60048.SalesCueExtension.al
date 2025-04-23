tableextension 60048 "Sales Cue Extension" extends "Sales Cue"
{
    fields
    {
        // Add changes to table fields here
        // field(90000; "Orders Received Today"; Integer)
        // {
        //     AccessByPermission = TableData "Interim Sales Header" = R;
        //     CalcFormula = Count("Interim Sales Header" WHERE("Document Type" = const(Order),
        //                                               "Document Date" = field("Channel Date Filter")));

        //     Caption = 'Orders Received Today';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(60000; "Total orders in today"; Integer)
        {
            Caption = 'Total orders today';
            //CalcFormula = Count("Sales Header" WHERE("Document Type" = const(Order),
            //"Document Date" = field("Date Filter")));
            Editable = false;
            //FieldClass = FlowField;
        }
        field(60001; "Outstanding Orders"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = const(Order),
            "Completely Shipped" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60002; "Overdue Orders"; Integer)
        {
            /*CalcFormula = Count("Sales Header" WHERE("Document Type" = const(Order),
            "Document Date" = filter(<WorkDate())));*/
            Editable = false;
            //FieldClass = FlowField;
        }

        field(60003; "Orders with Error"; Integer)
        {
            CalcFormula = Count("Interim Sales Header" WHERE("No of Error" = filter(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }

        field(60004; "Order on Shipment"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = const(Order), "Qty On Shipment" = filter(> 0), "Qty Picked" = filter(0)));
            //CalcFormula = sum("Warehouse Shipment Line"."Qty. Outstanding");
            Editable = false;
            FieldClass = FlowField;
        }

        field(60005; "Order ready to be scanned"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Document Type" = const(Order), "Qty Picked" = filter(> 0)));
            //CalcFormula = sum("Warehouse Shipment Line"."Qty. Picked");
            Editable = false;
            FieldClass = FlowField;
        }

        field(60006; "Orders Despatched Today"; Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE("Scanned Date" = FIELD("Activities Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        // field(90001; "Released for Pick Today"; Integer)
        // {
        //     AccessByPermission = TableData "Whse. Internal Pick Header" = R;
        //     CalcFormula = Count("Whse. Internal Pick Header" WHERE("Created Date" = field("Channel Date Filter")));
        //     Caption = 'Released for Pick Today';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(90002; "In Pick Today"; Integer)
        // {
        //     AccessByPermission = TableData "Warehouse Activity Header" = R;
        //     CalcFormula = Count("Warehouse Activity Header" WHERE(Type = const(Pick), "Created Date" = field("Channel Date Filter")));

        //     Caption = 'In Pick Today';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(90003; "Picked Today"; Integer)
        // {
        //     AccessByPermission = TableData "Registered Whse. Activity Hdr." = R;
        //     CalcFormula = Count("Registered Whse. Activity Hdr." WHERE(Type = const(Pick), "Created Date" = field("Channel Date Filter")));

        //     Caption = 'Picked Today';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }

        // field(90004; "Shipments Today"; Integer)
        // {
        //     AccessByPermission = TableData "Handled Interim Sales Header" = R;
        //     CalcFormula = Count("Handled Interim Sales Header" WHERE("Document Type" = const(Order), "Order Date" = field("Channel Date Filter")));

        //     Caption = 'Shipments Today';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(90005; "Returns Today"; Integer)
        // {
        //     AccessByPermission = TableData "Sales Header" = R;
        //     CalcFormula = Count("Sales Header" WHERE("Document Type" = const("Return Order"), "Order Date" = field("Channel Date Filter")));

        //     Caption = 'Returns Today';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(90006; "Total Outstanding"; Integer)
        // {
        //     AccessByPermission = TableData "Interim Sales Header" = R;
        //     CalcFormula = Count("Interim Sales Header" WHERE("Destination Doc No." = const('')));

        //     Caption = 'Total Outstanding';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(60007; "Activities Date Filter"; Date)
        {
        }



    }

    var
        SalOrdPage: Page "Sales Order List";


}