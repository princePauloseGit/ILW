pageextension 60069 WhseJournalExt extends "Whse. Item Journal"
{
    trigger OnOpenPage()
    begin
        ValidatePostingDate(Rec);
    end;

    local procedure ValidatePostingDate(var Rec: Record "Warehouse Journal Line")
    var
        WhseJnlLine: Record "Warehouse Journal Line";
    begin
        WhseJnlLine.SetRange("Journal Template Name", Rec.GetRangeMax("Journal Template Name"));
        WhseJnlLine.SetRange("Journal Batch Name", Rec.GetRangeMax("Journal Batch Name"));
        WhseJnlLine.SetRange("Item No.", '');
        WhseJnlLine.SetFilter("Registering Date", '<>%1', WorkDate());
        if not WhseJnlLine.FindSet() then
            exit;
        repeat
            WhseJnlLine."Registering Date" := WorkDate();
            WhseJnlLine.Modify();
        until WhseJnlLine.Next() = 0;
    end;
}
