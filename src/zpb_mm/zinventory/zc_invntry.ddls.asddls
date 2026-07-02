@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for Inventory'
@Metadata.allowExtensions: true
define root view entity ZC_INVNTRY
as select from ZI_INVNTRY(
        P_DisplayCurrency : 'INR'     // Or any default currency
    )
{
    key Plant,
        PlantName,
        StorageLocation,
        Material,
        MaterialName,
        ProductDescription,
        Batch,
        MaterialType,
        MaterialTypeName,
        MaterialGroup,
        ProductGroupName,
        ExternalProductGroup,
        ExternalGroupDescription,
        CompanyCode,
        CompanyCodeName,
        FiscaLyear,
        FiscalPeriod,
        CALENDARDATE,
       DebitCreditCode,
        Quantity,
        Unit,
       Value,
        Currency,
        PostingDate,
        ConsumptionType,
        ReceiptStockType,
        RejectedStockType,
        InventoryStockType,
        Unrestricted,
        Quality,
        TotalStockQuantity
}
