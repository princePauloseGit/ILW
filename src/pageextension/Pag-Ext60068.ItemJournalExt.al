pageextension 60068 ItemJournalExt extends "Item Journal"
{
    trigger OnOpenPage()
    begin
        ValidatePostingDate(Rec);
    end;

    local procedure ValidatePostingDate(var Rec: Record "Item Journal Line")
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.SetRange("Journal Template Name", Rec.GetRangeMax("Journal Template Name"));
        ItemJnlLine.SetRange("Journal Batch Name", Rec.GetRangeMax("Journal Batch Name"));
        ItemJnlLine.SetRange("Item No.", '');
        ItemJnlLine.SetFilter("Posting Date", '<>%1', WorkDate());
        if not ItemJnlLine.FindSet() then
            exit;
        repeat
            ItemJnlLine."Posting Date" := WorkDate();
            ItemJnlLine.Modify();
        until ItemJnlLine.Next() = 0;
    end;
}
