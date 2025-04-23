pageextension 60061 "Ext Sales Return List" extends "Sales Return Order List"
{
    actions
    {
        addafter("Delete Invoiced Orders")
        {
            action("Update Price")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    L_ReturnHeader: Record "Sales Header";
                    L_ReturnLine: Record "Sales Line";
                    ReleaseSalesDoc: Codeunit "Release Sales Document";
                    Flag: Boolean;
                begin
                    Clear(L_ReturnHeader);
                    L_ReturnHeader := Rec;
                    CurrPage.SetSelectionFilter(L_ReturnHeader);
                    //L_ReturnHeader.SetFilter("Posting Date", '<=%1', 20230228D);
                    if L_ReturnHeader.FindSet() then begin
                        repeat
                            Flag := false;
                            if L_ReturnHeader.Status = L_ReturnHeader.Status::Released then begin
                                ReleaseSalesDoc.PerformManualReopen(L_ReturnHeader);
                                Flag := true;
                            end;

                            L_ReturnLine.Reset();
                            L_ReturnLine.SetRange("Document Type", L_ReturnHeader."Document Type");
                            L_ReturnLine.SetRange("Document No.", L_ReturnHeader."No.");
                            if L_ReturnLine.FindSet() then begin
                                repeat
                                    if L_ReturnLine."Unit Price" <> 0 then begin
                                        L_ReturnLine.Validate("Unit Price", 0);
                                        L_ReturnLine.Modify(true);
                                    end;
                                until L_ReturnLine.Next() = 0;
                                if Flag = true then
                                    ReleaseSalesDoc.PerformManualRelease(L_ReturnHeader);
                            end;
                        until L_ReturnHeader.Next() = 0;
                        Message('Price Updated');
                    end;
                end;
            }
        }
    }
}