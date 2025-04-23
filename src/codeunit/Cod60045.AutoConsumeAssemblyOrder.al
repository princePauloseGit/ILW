codeunit 60045 "Auto Consume Assembly Order"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MOB WMS Assembly", 'OnGetAssemblyOrderLines_OnSetFilterAssemblyLine', '', true, true)]
    local procedure OnGetAssemblyOrderLines_OnSetFilterAssemblyLine(var _AssemblyLine: Record "Assembly Line")
    begin
        _AssemblyLine.SetRange("No.");
        _AssemblyLine.SetFilter("No.", '0');
    end;
}