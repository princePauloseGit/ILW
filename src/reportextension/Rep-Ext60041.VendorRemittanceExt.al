reportextension 60041 "Vendor Remittance Ext" extends 400
{
    RDLCLayout = 'Remittance Advice - EntriesExt.rdl';

    dataset
    {
        // Add changes to dataitems and columns here
        add("Vendor Ledger Entry")
        {
            column(Posting_Date; Format("Posting Date"))
            {

            }
            column(SentDate; format(WorkDate()))
            {

            }
            column(Picture; G_CompanyInfo.Picture)
            {

            }
            column(CompanyRegNumber; G_CompanyInfo."Registration No.")
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
}