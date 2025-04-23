pageextension 60048 "MyExtension" extends "Movement Worksheet"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify("Calculate Bin &Replenishment")
        {
            Visible = false;
        }
        addafter("Calculate Bin &Replenishment")
        {
            action("Calculate Bin &Replenishment1")
            {
                ApplicationArea = Warehouse;
                Caption = 'Calculate Bin &Replenishment';
                Ellipsis = true;
                Image = CalculateBinReplenishment;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calculate the movement of items from bulk storage bins with lower bin rankings to bins with a high bin ranking in the picking areas.';
                trigger OnAction()
                var
                    BinContent: Record "Bin Content";
                    Location: Record Location;
                    ReplenishBinContent: Report "Calculate Item Replanishment";
                begin
                    //Location.Get("Location Code");
                    ReplenishBinContent.InitializeRequest(
                            rec."Worksheet Template Name", rec.Name, rec."Location Code",
                            Location."Allow Breakbulk", false, false);

                    //ReplenishBinContent.SetTableView(BinContent);
                    ReplenishBinContent.Run();
                    Clear(ReplenishBinContent);
                End;
            }
        }
    }

    var
        myInt: Integer;
}