report 60047 "Combine Shipments Robosol"
{
    ApplicationArea = All;
    Caption = 'Combine Shipments Robosol';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesOrderHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "Payment Method Code", "VAT Bus. Posting Group", "Order Date", "No.") where("Document Type" = const(Order), "Combine Shipments" = const(true));
            RequestFilterFields = "Sell-to Customer No.", "Bill-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                DataItemLink = "Order No." = field("No.");
                DataItemTableView = sorting("Order No.");
                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Posted Sales Shipment';
                dataitem("Sales Shipment Line"; "Sales Shipment Line")
                {
                    DataItemLink = "Document No." = field("No.");
                    DataItemTableView = sorting("Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    var
                        CustIsBlocked: Boolean;
                        IsHandled: Boolean;
                    begin
                        IsHandled := false;
                        OnBeforeSalesShipmentLineOnAfterGetRecord("Sales Shipment Line", IsHandled);
                        if IsHandled then
                            CurrReport.Skip();

                        if Type = Type::" " then
                            if (not CopyTextLines) or ("Attached to Line No." <> 0) then
                                CurrReport.Skip();

                        if "Authorized for Credit Card" then
                            CurrReport.Skip();

                        if ("Qty. Shipped Not Invoiced" <> 0) or (Type = Type::" ") then begin
                            if ("Bill-to Customer No." <> Cust."No.") and
                               ("Sell-to Customer No." <> '')
                            then
                                if "Bill-to Customer No." <> '' then
                                    Cust.Get("Bill-to Customer No.")
                                else
                                    if "Sell-to Customer No." <> '' then
                                        Cust.Get("Sell-to Customer No.");

                            CustIsBlocked := Cust.Blocked in [Cust.Blocked::All, Cust.Blocked::Invoice];
                            OnBeforeCustIsBlockedOnAfterGetRecord(SalesOrderHeader, SalesHeader, "Sales Shipment Line", Cust, CustIsBlocked);
                            if not CustIsBlocked then begin
                                if ShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, "Sales Shipment Line") then begin
                                    if SalesHeader."No." <> '' then
                                        FinalizeSalesInvHeader();
                                    InsertSalesInvHeader();
                                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                                    SalesLine."Document Type" := SalesHeader."Document Type";
                                    SalesLine."Document No." := SalesHeader."No.";
                                end;
                                SalesShptLine := "Sales Shipment Line";
                                HasAmount := HasAmount or ("Qty. Shipped Not Invoiced" <> 0);
                                OnSalesShipmentLineOnAfterGetRecordOnBeforeInsertInvLineFromShptLine(SalesLine, SalesShptLine);
                                SalesShptLine.InsertInvLineFromShptLine(SalesLine);
                            end else
                                NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
                        end;
                    end;

                    trigger OnPostDataItem()
                    var
                        SalesLineInvoice: Record "Sales Line";
                        SalesShipmentLine: Record "Sales Shipment Line";
                        SalesGetShpt: Codeunit "Sales-Get Shipment";
                    begin
                        SalesShipmentLine.SetRange("Document No.", "Document No.");
                        SalesShipmentLine.SetRange(Type, Type::"Charge (Item)");
                        if SalesShipmentLine.FindSet() then
                            repeat
                                SalesLineInvoice.SetRange("Document Type", SalesLineInvoice."Document Type"::Invoice);
                                SalesLineInvoice.SetRange("Document No.", SalesHeader."No.");
                                SalesLineInvoice.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
                                if SalesLineInvoice.FindFirst() then
                                    SalesGetShpt.GetItemChargeAssgnt(SalesShipmentLine, SalesLineInvoice."Qty. to Invoice");
                            until SalesShipmentLine.Next() = 0;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DueDate: Date;
                    PmtDiscDate: Date;
                    PmtDiscPct: Decimal;
                begin
                    Window.Update(3, "No.");

                    if IsCompletlyInvoiced() then
                        CurrReport.Skip();

                    if OnlyStdPmtTerms then begin
                        Cust.Get("Bill-to Customer No.");
                        PmtTerms.Get(Cust."Payment Terms Code");
                        if PmtTerms.Code = "Payment Terms Code" then begin
                            DueDate := CalcDate(PmtTerms."Due Date Calculation", "Document Date");
                            PmtDiscDate := CalcDate(PmtTerms."Discount Date Calculation", "Document Date");
                            PmtDiscPct := PmtTerms."Discount %";
                            if (DueDate <> "Due Date") or
                               (PmtDiscDate <> "Pmt. Discount Date") or
                               (PmtDiscPct <> "Payment Discount %")
                            then begin
                                NoOfskippedShiment := NoOfskippedShiment + 1;
                                CurrReport.Skip();
                            end;
                        end else begin
                            NoOfskippedShiment := NoOfskippedShiment + 1;
                            CurrReport.Skip();
                        end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnAfterGetRecordSalesOrderHeader(SalesOrderHeader, IsHandled);
                if IsHandled then
                    CurrReport.Skip();

                CurrReport.Language := G_Language.GetLanguageIdOrDefault("Language Code");
                CurrReport.FormatRegion := G_Language.GetFormatRegionOrDefault("Format Region");

                Window.Update(1, "Bill-to Customer No.");
                Window.Update(2, "No.");
            end;

            trigger OnPostDataItem()
            begin
                CurrReport.Language := ReportLanguage;
                if ReportFormatRegion <> '' then
                    CurrReport.FormatRegion := ReportFormatRegion;
                Window.Close();
                ShowResult();
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Sell-to Customer No.", "Bill-to Customer No.", "Currency Code", "EU 3-Party Trade", "Dimension Set ID", "Payment Method Code", "VAT Bus. Posting Group", "Order Date");  //Payment method Code Added by Shubham

                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);
                if VATDateReq = 0D then
                    Error(VATDateEmptyErr);

                Window.Open(
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);

                OnSalesOrderHeaderOnPreDataItem(SalesOrderHeader);
                ReportLanguage := CurrReport.Language();
                ReportFormatRegion := CopyStr(CurrReport.FormatRegion(), 1, StrLen(ReportFormatRegion));
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the invoice(s) that the batch job creates. This field must be filled in.';

                        trigger OnValidate()
                        begin
                            UpdateVATDate();
                        end;
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date';
                        ToolTip = 'Specifies the document date for the invoice(s) that the batch job creates. This field must be filled in.';

                        trigger OnValidate()
                        begin
                            UpdateVATDate();
                        end;
                    }
                    field(VATDate; VATDateReq)
                    {
                        ApplicationArea = VAT;
                        Caption = 'VAT Date';
                        Editable = VATDateEnabled;
                        Visible = VATDateEnabled;
                        ToolTip = 'Specifies the VAT Date for the invoice(s) that the batch job creates. This field must be filled in.';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies if you want the invoice discount amount to be automatically calculated on the shipment.';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get();
                            SalesSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                    field(PostInv; PostInv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Invoices';
                        ToolTip = 'Specifies if you want to have the invoices posted immediately.';
                    }
                    field(OnlyStdPmtTerms; OnlyStdPmtTerms)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Only Std. Payment Terms';
                        ToolTip = 'Specifies if you want to include shipments with standard payments terms. If you select this option, you must manually invoice all other shipments.';
                    }
                    field(CopyTextLines; CopyTextLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Copy Text Lines';
                        ToolTip = 'Specifies if you want manually written text on the shipment lines to be copied to the invoice.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            VATReportingDateMgt: Codeunit "VAT Reporting Date Mgt";
            IsHandled: Boolean;
        begin
            IsHandled := false;
            OnBeforeOnOpenPage(IsHandled);
            if IsHandled then
                exit;

            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            if VATDateReq = 0D then
                VATDateReq := GLSetup.GetVATDate(PostingDateReq, DocDateReq);
            SalesSetup.Get();
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
            VATDateEnabled := VATReportingDateMgt.IsVATDateEnabled();
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        OnBeforePostReport();
    end;

    trigger OnPreReport()
    begin
        OnBeforePreReport();
    end;

    var
        Cust: Record Customer;
        GLSetup: Record "General Ledger Setup";
        PmtTerms: Record "Payment Terms";
        SalesSetup: Record "Sales & Receivables Setup";
        G_Language: Codeunit Language;
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        HasAmount: Boolean;
        HideDialog: Boolean;
        Window: Dialog;
        NoOfSalesInv: Integer;
        NoOfSalesInvErrors: Integer;
        NoOfskippedShiment: Integer;
        ReportLanguage: Integer;
        NotAllInvoicesCreatedMsg: Label 'Not all the invoices were created. A total of %1 invoices were not created.';
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Enter the document date.';
        Text002: Label 'Combining shipments...\\';
        Text003: Label 'Customer No.    #1##########\';
        Text004: Label 'Order No.       #2##########\';
        Text005: Label 'Shipment No.    #3##########';
        Text007: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text008: Label 'There is nothing to combine.';
        Text010: Label 'The shipments are now combined and the number of invoices created is %1.';
        Text011: Label 'The shipments are now combined, and the number of invoices created is %1.\%2 Shipments with nonstandard payment terms have not been combined.', Comment = '%1-Number of invoices,%2-Number Of shipments';
        VATDateEmptyErr: Label 'Enter the VAT date.';
        ReportFormatRegion: Text[80];

    protected var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        CalcInvDisc: Boolean;
        CopyTextLines: Boolean;
        OnlyStdPmtTerms: Boolean;
        PostInv: Boolean;
        VATDateEnabled: Boolean;
        DocDateReq: Date;
        PostingDateReq: Date;
        VATDateReq: Date;

    local procedure FinalizeSalesInvHeader()
    var
        HasError: Boolean;
        ShouldPostInv: Boolean;
    begin
        HasError := false;
        OnBeforeFinalizeSalesInvHeader(SalesHeader, HasAmount, HasError);
        if HasError then
            NoOfSalesInvErrors += 1;

        if (not HasAmount) or HasError then begin
            OnFinalizeSalesInvHeaderOnBeforeDelete(SalesHeader);
            SalesHeader.Delete(true);
            OnFinalizeSalesInvHeaderOnAfterDelete(SalesHeader);
            exit;
        end;
        OnFinalizeSalesInvHeader(SalesHeader);
        if CalcInvDisc then
            SalesCalcDisc.Run(SalesLine);
        SalesHeader.Find();
        Commit();
        Clear(SalesCalcDisc);
        Clear(SalesPost);
        NoOfSalesInv := NoOfSalesInv + 1;
        ShouldPostInv := PostInv;
        OnFinalizeSalesInvHeaderOnAfterCalcShouldPostInv(SalesHeader, NoOfSalesInv, ShouldPostInv);
        if ShouldPostInv then begin
            Clear(SalesPost);
            if not SalesPost.Run(SalesHeader) then
                NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
        end;
    end;

    local procedure InsertSalesInvHeader()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertSalesInvHeader(SalesHeader, SalesOrderHeader, "Sales Shipment Header", "Sales Shipment Line", NoOfSalesInv, HasAmount, IsHandled);
        if not IsHandled then begin
            GLSetup.Get();
            Clear(SalesHeader);
            SalesHeader.Init();
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."No." := '';
            OnBeforeSalesInvHeaderInsert(SalesHeader, SalesOrderHeader);
            SalesHeader.Insert(true);
            ValidateCustomerNo(SalesHeader, SalesOrderHeader);
            SalesHeader.Validate(SalesHeader."Posting Date", SalesOrderHeader."Order Date");
            SalesHeader.Validate(SalesHeader."Document Date", SalesOrderHeader."Order Date");
            SalesHeader.Validate(SalesHeader."VAT Reporting Date", SalesOrderHeader."Order Date");
            SalesHeader.Validate(SalesHeader."Currency Code", SalesOrderHeader."Currency Code");
            SalesHeader.Validate(SalesHeader."Payment Method Code", SalesOrderHeader."Payment Method Code");
            //Added by Shubham
            SalesHeader.Validate(SalesHeader."VAT Bus. Posting Group", SalesOrderHeader."VAT Bus. Posting Group");
            // Added by Stuart
            SalesHeader.Validate("Order Date", SalesOrderHeader."Order Date");//Khan
            SalesHeader.Validate(SalesHeader."EU 3-Party Trade", SalesOrderHeader."EU 3-Party Trade");
            if GLSetup."Journal Templ. Name Mandatory" then
                SalesHeader.Validate(SalesHeader."Journal Templ. Name", SalesOrderHeader."Journal Templ. Name");
            SalesHeader."Salesperson Code" := SalesOrderHeader."Salesperson Code";
            SalesHeader."Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
            SalesHeader."Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
            SalesHeader."Dimension Set ID" := SalesOrderHeader."Dimension Set ID";
            OnBeforeSalesInvHeaderModify(SalesHeader, SalesOrderHeader);
            SalesHeader.Validate("Customer Posting Group", SalesOrderHeader."Customer Posting Group");//Khan
            SalesHeader.Modify();
            Commit();
            HasAmount := false;
        end;
        OnAfterInsertSalesInvHeader(SalesHeader, "Sales Shipment Header");
    end;

    procedure InitializeRequest(NewPostingDate: Date; NewDocDate: Date; NewCalcInvDisc: Boolean; NewPostInv: Boolean; NewOnlyStdPmtTerms: Boolean; NewCopyTextLines: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocDate;
        VATDateReq := GLSetup.GetVATDate(PostingDateReq, DocDateReq);
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostInv;
        OnlyStdPmtTerms := NewOnlyStdPmtTerms;
        CopyTextLines := NewCopyTextLines;
    end;

    procedure InitializeRequest(NewPostingDate: Date; NewDocDate: Date; NewVATDate: Date; NewCalcInvDisc: Boolean; NewPostInv: Boolean; NewOnlyStdPmtTerms: Boolean; NewCopyTextLines: Boolean)
    begin
        InitializeRequest(NewPostingDate, NewDocDate, NewCalcInvDisc, NewPostInv, NewOnlyStdPmtTerms, NewCopyTextLines);
        VATDateReq := NewVATDate;
    end;

    local procedure ValidateCustomerNo(var ToSalesHeader: Record "Sales Header"; FromSalesOrderHeader: Record "Sales Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateCustomerNo(ToSalesHeader, FromSalesOrderHeader, "Sales Shipment Header", "Sales Shipment Line", IsHandled);
        if IsHandled then
            exit;

        ToSalesHeader.Validate("Sell-to Customer No.", FromSalesOrderHeader."Sell-to Customer No.");
        ToSalesHeader.Validate("Bill-to Customer No.", FromSalesOrderHeader."Bill-to Customer No.");
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure ShowResult()
    begin
        OnBeforeShowResult(SalesHeader, NoOfSalesInvErrors, PostInv);

        if SalesHeader."No." <> '' then begin // Not the first time
            FinalizeSalesInvHeader();
            OnSalesShipmentHeaderOnAfterFinalizeSalesInvHeader(SalesHeader, NoOfSalesInvErrors, PostInv, HideDialog);
            if (NoOfSalesInvErrors = 0) and not HideDialog then begin
                if NoOfskippedShiment > 0 then
                    Message(Text011, NoOfSalesInv, NoOfskippedShiment)
                else
                    Message(Text010, NoOfSalesInv);
            end else
                if not HideDialog then
                    if PostInv then
                        Message(Text007, NoOfSalesInvErrors)
                    else
                        Message(NotAllInvoicesCreatedMsg, NoOfSalesInvErrors)
        end else
            if not HideDialog then
                Message(Text008);
    end;

    local procedure ShouldFinalizeSalesInvHeader(SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; SalesShipmentLine: Record "Sales Shipment Line") Finalize: Boolean
    begin
        Finalize :=
          (SalesOrderHeader."Sell-to Customer No." <> SalesHeader."Sell-to Customer No.") or
          (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
          (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
          (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") or
          (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID") or
          (SalesOrderHeader."Journal Templ. Name" <> SalesHeader."Journal Templ. Name") or
          (SalesOrderHeader."VAT Bus. Posting Group" <> SalesHeader."VAT Bus. Posting Group") or
          (SalesOrderHeader."Order Date" <> SalesHeader."Order Date") or //Khan
          (SalesOrderHeader."Payment Method Code" <> SalesHeader."Payment Method Code");  //Added by Shubham

        OnAfterShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, Finalize, SalesShipmentLine, "Sales Shipment Header");
        exit(Finalize);
    end;

    local procedure UpdateVATDate()
    begin
        VATDateReq := GLSetup.GetVATDate(PostingDateReq, DocDateReq);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecordSalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header"; var HasAmount: Boolean; var HasError: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesInvHeader(var SalesInvoiceHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; var NoOfSalesInv: Integer; var HasAmount: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePreReport()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowResult(var SalesInvoiceHeader: Record "Sales Header"; var NoOfSalesInvErrors: Integer; PostInvoice: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderModify(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesShipmentLineOnAfterGetRecord(var SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateCustomerNo(var ToSalesHeader: Record "Sales Header"; var FromSalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnAfterDelete(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnAfterCalcShouldPostInv(var SalesHeader: Record "Sales Header"; var NoOfSalesInv: Integer; var ShouldPostInv: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnBeforeDelete(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesOrderHeaderOnPreDataItem(var SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldFinalizeSalesInvHeader(var SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; var Finalize: Boolean; SalesShipmentLine: Record "Sales Shipment Line"; SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesShipmentLineOnAfterGetRecordOnBeforeInsertInvLineFromShptLine(var SalesLine: Record "Sales Line"; var SalesShipmentLine: Record "Sales Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesShipmentHeaderOnAfterFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header"; var NoOfSalesInvErrors: Integer; PostInvoice: Boolean; var HideDialog: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeOnOpenPage(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustIsBlockedOnAfterGetRecord(OrderSalesHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; SalesShipmentLine: Record "Sales Shipment Line"; Customer: Record Customer; var CustIsBlocked: Boolean)
    begin
    end;
}
