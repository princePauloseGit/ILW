pageextension 60058 "Ext Invoice Card" extends "Sales Invoice List"
{
    actions
    {
        addbefore(Dimensions)
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
                    L_InvoiceHeader: Record "Sales Header";
                    L_InvoiceLine: Record "Sales Line";
                begin
                    L_InvoiceHeader.Reset();
                    L_InvoiceHeader := Rec;
                    CurrPage.SetSelectionFilter(L_InvoiceHeader);
                    L_InvoiceHeader.SetRange("Document Type", L_InvoiceHeader."Document Type"::Invoice);
                    //L_InvoiceHeader.SetFilter("Posting Date", '<=%1', 20230228D);
                    if L_InvoiceHeader.FindSet() then begin
                        repeat
                            L_InvoiceLine.Reset();
                            L_InvoiceLine.SetRange("Document Type", L_InvoiceHeader."Document Type");
                            L_InvoiceLine.SetRange("Document No.", L_InvoiceHeader."No.");
                            if L_InvoiceLine.FindSet() then begin
                                repeat
                                    if L_InvoiceLine."Unit Price" <> 0 then begin
                                        L_InvoiceLine.Validate("Unit Price", 0);
                                        L_InvoiceLine.Modify(true);
                                    end;
                                until L_InvoiceLine.Next() = 0;
                            end;
                        until L_InvoiceHeader.Next() = 0;
                        Message('Price Updated');
                    end;

                end;
            }

            action("Delete Multiple Records")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    Clear(SalesHeader);
                    SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesHeader);

                    if SalesHeader.FindSet() then begin
                        repeat
                            SalesHeader.Delete(true);
                        until SalesHeader.Next() = 0;
                    end;
                end;
            }
        }
    }
}