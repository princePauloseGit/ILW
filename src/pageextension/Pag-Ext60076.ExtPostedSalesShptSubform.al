pageextension 60076 ExtPostedSalesShptSubform extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Channel Order ID"; Rec."Channel Order ID")
            {
                ApplicationArea = all;
            }
        }
    }
}
