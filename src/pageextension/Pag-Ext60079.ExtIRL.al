pageextension 60079 ExtIRL extends "Item Reference List"
{
    layout
    {
        addafter("Reference Type")
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
