pageextension 60045 "AssemOrdr" extends "Assembly Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Order)
        {
            action(PrintLabel)
            {
                ApplicationArea = Assembly;
                Caption = 'Print Label';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
                ToolTip = 'Print the assembly order Label.';

                trigger OnAction()
                var
                    Recassembly: Record "Assembly Header";
                    RepAssemLabl: Report PrintAssemblyOrderLbl;
                begin
                    Recassembly.Reset();
                    Recassembly.SetRange("No.", Rec."No.");
                    if Recassembly.FindFirst() then begin
                        RepAssemLabl.GetnoofCpoies(Recassembly.Quantity);
                        RepAssemLabl.SetTableView(Recassembly);
                        RepAssemLabl.Run();
                        //Report.Run(90092, true, false, Recassembly);
                    end;

                end;
            }
        }
    }

    var
        myInt: Integer;
}