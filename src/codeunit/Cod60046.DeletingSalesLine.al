codeunit 60046 DeletingSalesLine
{
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        dialog: Dialog;
        Counter: Integer;
        Text000: text;
    begin
        Counter := 0;
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Description, '');
        Text000 := StrSubstNo('Progress from 0 to %1 @1@@@@', SalesLine.Count);
        dialog.Open(Text000, Counter);
        if SalesLine.FindSet() then begin
            repeat
                SalesHeader.Reset();
                SalesHeader.SetRange("Document Type", SalesLine."Document Type");
                SalesHeader.SetRange("No.", SalesLine."Document No.");
                if not SalesHeader.FindFirst() then begin
                    SalesLine.Delete();
                    Counter := Counter + 1;
                    dialog.Update();
                end;
            until SalesLine.Next() = 0;
            dialog.Close();
        end;
    end;

}
