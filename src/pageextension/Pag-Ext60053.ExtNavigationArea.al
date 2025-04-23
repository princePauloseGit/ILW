pageextension 60053 "ExtNavigationArea" extends "Business Manager Role Center"
{
    layout
    {
        addbefore(Control16)
        {

            part("Activities"; "Activities")
            {
                Caption = 'O-Channel Activities';
                ApplicationArea = All;
            }
            // var
            // Pagetest : Page "Business Manager Role Center"

        }
    }




}
