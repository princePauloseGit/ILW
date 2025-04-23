pageextension 60078 ExtItemReferenceEntries extends "Item Reference Entries"
{
    layout
    {
        addafter("Reference Type No.")
        {
            field(isLabelBarcode; Rec.isLabelBarcode)
            {
                ApplicationArea = all;
            }
            field(isQRLabel; Rec.isQRLabel)
            {
                ApplicationArea = all;
                Caption = 'IsQrLabel';
            }
        }
    }
}
