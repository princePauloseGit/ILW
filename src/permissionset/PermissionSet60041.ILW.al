permissionset 60041 "ILW"
{
    Assignable = true;
    Permissions = report "Calculate Item Replanishment" = X,
        report ImportAssemblyOrders = X,
        report PrintAssemblyOrderLbl = X,
        codeunit "Event Handlers" = X,
        codeunit "Item Attachments" = X,
        codeunit "Robosol Replenishment" = X,
        page "Purchase Line" = X,
        page "Registered WH Pick lines" = X,
        query AssemblyOrders = X,
        query Bins = X,
        query HandledWebOrders = X,
        query NonHandledWebOrders = X,
        query ReplenishmentData = X;
}