@AbapCatalog.sqlViewName: 'ZCMATAGE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_MAT_AGE as select from ZI_MAT_AGEING
{
    key Product,
    key Plant,
    key StorageLocation,
    key Batch,
    key MovingAveragePrice,
    CompanyCode,
    ProductType,
    ValuationAreaType,
    Vendor,
    SupplierFullName,
    ProductGroup,
    ProductDescription,
    FiscaLyear,
    FiscalPeriod,
    CALENDARDATE,
    MaterialBaseUnit,
    UOM,
    InventoryQuantity,
    Currency,
    InventoryAmount,
    MovingPrice,
    StandardPrice,
    PriceControl,
    PostingDate,
    Age,
    Days_0_30,
    Days_31_60,
    Days_61_90,
    Days_91_120,
    Days_121_180,
    Days_181_360,
    Days_361_730,
    Days_Over_730,
    Division,
    ExternalProductGroup,
    ExternalProductGroupName,
    PlantName,
    InventorySpecialStockType,
    MaterialTypeName
}
