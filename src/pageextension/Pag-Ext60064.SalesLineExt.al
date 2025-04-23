pageextension 60064 SalesLineExt extends "Sales Lines"
{
    actions
    {
        addlast(Processing)
        {
            action(DeleteSalesLine)
            {
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                PromotedIsBig = true;
                Image = Delete;

                trigger OnAction()
                var
                    DeleteSalesLine: Codeunit DeletingSalesLine;
                    test: Page "Whse. Phys. Invt. Journal";
                begin
                    DeleteSalesLine.Run();
                end;
            }
        }
    }
}
