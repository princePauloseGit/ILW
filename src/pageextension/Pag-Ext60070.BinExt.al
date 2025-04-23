pageextension 60070 BinExt extends Bins
{
    actions
    {
        addafter(Contents_Promoted)
        {
            actionref("PrintLabel_Promoted"; PrintLabel) { }
        }
        addafter("&Contents")
        {
            action(PrintLabel)
            {
                Caption = 'Print Label';
                Image = Print;
                ApplicationArea = Warehouse;
                //Enabled = false;
                Scope = Repeater;
                trigger OnAction()
                var
                    Bin: Record Bin;
                    BinLabelReport: Report "Bin Label";
                begin
                    CurrPage.SetSelectionFilter(Bin);
                    BinLabelReport.SetTableView(Bin);
                    BinLabelReport.RunModal();
                end;


            }
        }

    }
}
