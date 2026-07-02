@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Aging Base'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MAT_AGEING
  as select from    I_Product               as a

    inner join      I_ProductDescription    as b     on  b.Product  = a.Product
                                                     and b.Language = 'E'

    inner join      I_StockQuantityCurrentValue_2(
                    P_DisplayCurrency: 'INR'
                    )                       as stock on stock.Product = a.Product
  //     and stock.ValuationAreaType = '1'
left outer join zmm_LATEST_POSTDATE     as md    on  md.Material        = stock.Product
                                                     and md.Plant           = stock.Plant
                                                     and md.StorageLocation = stock.StorageLocation
                                                     and md.Batch           = stock.Batch

    left outer join I_ExtProdGrpText        as ext   on ext.ExternalProductGroup = a.ExternalProductGroup

    left outer join I_Plant                 as p     on p.Plant = stock.Plant

    left outer join I_ProductTypeText       as t     on t.ProductType = a.ProductType

    left outer join I_ProductValuationBasic as pd    on  pd.Product       = a.Product
                                                     and pd.ValuationArea = p.Plant
                                                     and pd.ValuationType = ' '
    left outer join ZI_MAT_VH               as ven   on ven.Material = a.Product

    left outer join I_Supplier              as sup   on sup.Supplier = ven.Supplier
 
    left outer join I_ValuationArea         as m     on p.ValuationArea = m.ValuationArea

    left outer join I_CompanyCode           as c     on m.CompanyCode = c.CompanyCode
    left outer join Z_AGEING_CAL         as AGE   on  AGE.Material = a.Product
                                                     and    AGE.Batch     = stock.Batch
       left outer join I_FiscalCalendarDate     as PP     on  PP.CalendarDate      = AGE.PostingDate
                                                       and PP.FiscalYearVariant = AGE.FiscalYearVariant
//                                                     and AGE.PostingDate  = md.LastPostingDate
//                                                     and AGE.Plant        = stock.Plant
//                                                     and AGE.StorLocation = stock.StorageLocation
//                                                     and AGE.Batch        = stock.Batch

{
  key a.Product                                 as Product,
  key stock.Plant                               as Plant,
  key stock.StorageLocation                     as StorageLocation,
  key stock.Batch                               as Batch,

      @Semantics.amount.currencyCode: 'Currency'
  key pd.MovingAveragePrice,
      c.CompanyCode,
      a.ProductType,
      stock.ValuationAreaType,
      ven.Supplier                              as Vendor,
      sup.SupplierFullName,

      a.ProductGroup,
      b.ProductDescription,
      PP.FiscalYear                              as FiscaLyear,
      PP.FiscalPeriod,
      PP.CalendarDate                            as CALENDARDATE,

      stock.MaterialBaseUnit,
      cast( a.BaseUnit as meins )               as UOM,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      stock.MatlWrhsStkQtyInMatlBaseUnit  as InventoryQuantity,

      stock.Currency,

      @Semantics.amount.currencyCode: 'Currency'
      stock.StockValueInDisplayCurrency  as InventoryAmount,

      @Semantics.amount.currencyCode: 'Currency'
      pd.MovingAveragePrice                     as MovingPrice,

      @Semantics.amount.currencyCode: 'Currency'
      pd.StandardPrice                          as StandardPrice,

      pd.InventoryValuationProcedure            as PriceControl,

      AGE.PostingDate,
     AGE.Age,
     
     /* ===================================================== */
  /* INTERVAL 1                                            */
  /* ===================================================== */
  @Semantics.quantity.unitOfMeasure: 'UOM'
@DefaultAggregation: #SUM
  cast(
    case
      when dats_days_between(
              AGE.PostingDate,
             $session.system_date
           ) between 0 and 30
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_0_30,


  /* ===================================================== */
  /* INTERVAL 2                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 100 }]
  @EndUserText.label: 'Interval 2'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
           AGE.PostingDate,
             $session.system_date
           ) between 31 and 60
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_31_60,


  /* ===================================================== */
  /* INTERVAL 3                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 110 }]
  @EndUserText.label: 'Interval 3'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
            AGE.PostingDate,
             $session.system_date
           ) between 61 and 90
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_61_90,


  /* ===================================================== */
  /* INTERVAL 4                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 120 }]
  @EndUserText.label: 'Interval 4'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
              AGE.PostingDate,
             $session.system_date
           ) between 91 and 120
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_91_120,


  /* ===================================================== */
  /* INTERVAL 5                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 130 }]
  @EndUserText.label: 'Interval 5'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
             AGE.PostingDate,
             $session.system_date
           ) between 121 and 180
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_121_180,


  /* ===================================================== */
  /* INTERVAL 6                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 140 }]
  @EndUserText.label: 'Interval 6'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
             AGE.PostingDate,
             $session.system_date
           ) between 181 and 360
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_181_360,


  /* ===================================================== */
  /* INTERVAL 7                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 150 }]
  @EndUserText.label: 'Interval 7'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
             AGE.PostingDate,
             $session.system_date
           ) between 361 and 730
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_361_730,


  /* ===================================================== */
  /* INTERVAL 8                                            */
  /* ===================================================== */

  @UI.lineItem: [{ position: 160 }]
  @EndUserText.label: 'Interval 8'
  @Semantics.quantity.unitOfMeasure: 'UOM'

  cast(
    case
      when dats_days_between(
             AGE.PostingDate,
             $session.system_date
           ) > 730
      then stock.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
    end
  as abap.quan(16,3) ) as Days_Over_730,

      a.Division,
      a.ExternalProductGroup,
      ext.ExternalProductGroupName,

      p.PlantName,

      stock.InventorySpecialStockType,

      t.MaterialTypeName
}

where
      stock.StorageLocation   <> ''
  and stock.ValuationAreaType <> '6'
  and stock.ValuationAreaType <> '3'
and  stock.StockValueInDisplayCurrency <> 0
and pd.MovingAveragePrice <> 0
group by
  a.Product,
  stock.Plant,
  stock.StorageLocation,
  stock.Batch,
  c.CompanyCode,
  pd.MovingAveragePrice,
  pd.StandardPrice,
  pd.InventoryValuationProcedure,
 stock.StockValueInDisplayCurrency,
 stock.MatlWrhsStkQtyInMatlBaseUnit,
  a.ProductType,
  ven.Supplier,
  sup.SupplierFullName,

  a.ProductGroup,
  b.ProductDescription,

  stock.MaterialBaseUnit,
  stock.ValuationAreaType,
  a.BaseUnit,

  stock.Currency,

  md.LastPostingDate,
  AGE.Age,
  a.Division,
  a.ExternalProductGroup,
  ext.ExternalProductGroupName,

  p.PlantName,
AGE.PostingDate,
  stock.InventorySpecialStockType,

  t.MaterialTypeName,
  PP.FiscalYear,
  PP.FiscalPeriod,
  PP.CalendarDate
