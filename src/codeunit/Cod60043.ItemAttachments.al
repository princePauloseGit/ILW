codeunit 60043 "Item Attachments"
{

    trigger OnRun()
    var
        Item: Record Item;
    begin
        // Item := Rec;
        Item.Reset();
        if Item.FindSet() then begin
            repeat
                UpdatePictureBoolean(Item);
                UpdateLinkBoolean(Item);
                UpdateAttachmentBoolean(Item);
            until Item.Next() = 0;
        end;
    end;

    local procedure UpdatePictureBoolean(var P_Rec: Record Item)
    begin
        if P_Rec.Picture.Count > 0 then begin
            P_Rec."Has Pictures" := true;
            P_Rec.Modify();
        end
        else begin
            P_Rec."Has Pictures" := false;
            P_Rec.Modify();
        end;
    end;

    local procedure UpdateLinkBoolean(var P_Rec: Record Item)
    var
        RecordLinks: Record "Record Link";
        ItemRecRef: RecordRef;
        ItemFieldRef: FieldRef;
    begin
        ItemRecRef.Open(Database::Item);
        ItemFieldRef := ItemRecRef.Field(1);
        ItemFieldRef.SetRange(P_Rec."No.");
        if ItemRecRef.FindFirst() then begin
            if ItemRecRef.HasLinks then begin
                P_Rec."Has Links" := true;
                P_Rec.Modify();
            end
            else begin
                P_Rec."Has Links" := false;
                P_Rec.Modify();
            end;
        end;
    end;

    local procedure UpdateAttachmentBoolean(var P_Rec: Record Item)
    var
        DocumentAttachment: Record "Document Attachment";
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("Table ID", Database::Item);
        DocumentAttachment.SetRange("No.", P_Rec."No.");
        if DocumentAttachment.FindSet() then begin
            P_Rec."Has Attachments" := true;
            P_Rec.Modify();
        end
        else begin
            P_Rec."Has Attachments" := false;
            P_Rec.Modify();
        end;
    end;
}