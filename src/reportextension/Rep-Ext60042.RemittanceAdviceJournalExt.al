reportextension 60042 "Remittance Advice-Journal Ext" extends "Remittance Advice - Journal"
{
    RDLCLayout = 'Remittance Advice - JournalExt.rdl';
    dataset
    {
        // Add changes to dataitems and columns here
        add(VendLoop)
        {
            column(Picture; G_CompanyInfo.Picture)
            {
            }
            column(CompanyRegNumber; G_CompanyInfo."Registration No.")
            {
            }
            column(SentDate; format(WorkDate()))
            {
            }
        }
        add("Gen. Journal Line")
        {
            column(Payment_Date; format("Gen. Journal Line"."Posting Date"))
            {
            }
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }
    trigger OnPreReport()
    begin
        G_CompanyInfo.Get();
        G_CompanyInfo.CalcFields(Picture);


    end;




    var
        G_CompanyInfo: Record "Company Information";
        G_PostingDate: Date;
}