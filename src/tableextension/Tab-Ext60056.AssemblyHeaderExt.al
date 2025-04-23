tableextension 60056 "AssemblyHeaderExt ILW" extends "Assembly Header"
{
    fields
    {
        field(60041; "Item Category Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Item Category Code" where("No." = field("Item No.")));
        }
    }


    internal procedure PerformManualRelease()
    begin
        if Rec.Status <> Rec.Status::Released then begin
            CODEUNIT.Run(CODEUNIT::"Release Assembly Document", Rec);
            Commit();
        end;
    end;
}

