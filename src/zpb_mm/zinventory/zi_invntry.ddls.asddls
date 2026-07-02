@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Inventory'
@Metadata.allowExtensions: true
define root view entity ZI_INVNTRY
  with parameters
    P_DisplayCurrency : nsdm_display_currency
  as select from    I_StockQuantityCurrentValue_2 (
                    P_DisplayCurrency : $parameters.P_DisplayCurrency
                    )                        as a
    left outer join I_MaterialDocumentItem_2 as MATDOC on  MATDOC.Plant              = a.Plant
                                                       and MATDOC.Material           = a.Product
                                                       and MATDOC.Batch              = a.Batch
    //                                                       and MATDOC.StorageLocation = a.StorageLocation
    //                                                       and MATDOC.CompanyCode = c.CompanyCode
    //                                                       and MATDOC.MaterialBaseUnit = a.MaterialBaseUnit
                                                       and MATDOC.InventoryStockType = a.InventoryStockType
    left outer join I_Plant                  as b      on a.Plant = b.Plant
    left outer join I_ProductText            as d      on a.Product = d.Product
    left outer join I_ProductTypeText        as p      on  a.ProductType = p.ProductType
                                                       and p.Language    = $session.system_language
    left outer join I_ValuationArea          as m      on b.ValuationArea = m.ValuationArea

    left outer join I_CompanyCode            as c      on m.CompanyCode = c.CompanyCode
    left outer join I_ProductDescription     as e      on a.Product = e.Product
    left outer join ZI_MATERIALDOCUMENT      as f      on  a.Product                = f.Material
                                                       and a.Plant                  = f.Plant
                                                       and a.Batch                  = f.Batch
                                                       and a.StorageLocation        = f.StorageLocation
                                                       and MATDOC.GoodsMovementType = f.GoodsMovementType
    left outer join I_Product                as PRO    on  a.Product      = PRO.Product
                                                       and a.ProductGroup = PRO.ProductGroup
    left outer join ZI_StockMatrixCube       as SH     on  PRO.Product       = SH.Material
                                                       and a.ProductType     = p.ProductType
                                                       and a.Plant           = SH.Plant
                                                       and a.StorageLocation = SH.StorageLocation
                                                       and a.Batch           = SH.Batch
    left outer join I_ProductGroupText_2     as pg     on a.ProductGroup = pg.ProductGroup
    left outer join I_FiscalCalendarDate     as PP     on  PP.CalendarDate      = MATDOC.PostingDate
                                                       and PP.FiscalYearVariant = MATDOC.FiscalYearVariant

{
  key a.Plant,
      b.PlantName,
      a.Product                      as Material,
      a.Batch,
      d.ProductName                  as MaterialName,
      a.ProductType                  as MaterialType,
      p.MaterialTypeName,
      PRO.ExternalProductGroup,
      SH.ExternalGroupDescription,
      a.ProductGroup                 as MaterialGroup,
      pg.ProductGroupName,
      c.CompanyCode,
      c.CompanyCodeName,
      PP.FiscalYear                  as FiscaLyear,
      PP.FiscalPeriod,
      PP.CalendarDate                as CALENDARDATE,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      //      @DefaultAggregation : #SUM
      a.MatlWrhsStkQtyInMatlBaseUnit as Quantity,
      a.MaterialBaseUnit             as Unit,
      //      @Semantics.amount.currencyCode: 'Currency'
      //      @DefaultAggregation: #SUM
      a.StockValueInDisplayCurrency  as Value,
      a.DisplayCurrency              as Currency,
      a.StorageLocation,
      e.ProductDescription,
      f.DebitCreditCode,
      MATDOC.PostingDate,
      f.ConsumptionType,
      f.RejectedStockType,
      f.ReceiptStockType,
      a.InventoryStockType,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @DefaultAggregation : #SUM
      cast(
        case
          when a.InventoryStockType = '01'
          then a.MatlWrhsStkQtyInMatlBaseUnit
          else 0
        end
        as abap.quan(16,3)
      )                              as Unrestricted,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @DefaultAggregation : #SUM
      cast(
        case
          when a.InventoryStockType = '02'
          then  a.MatlWrhsStkQtyInMatlBaseUnit
          else 0
        end
      as abap.quan(16,3) )           as Quality,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @DefaultAggregation : #SUM
      cast(
      (
      case
      when a.InventoryStockType = '01'
      then a.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
      end
      +
      case
      when a.InventoryStockType = '02'
      then a.MatlWrhsStkQtyInMatlBaseUnit
      else cast( 0 as abap.quan(16,3) )
      end
      )
      as abap.quan(16,3) )           as TotalStockQuantity

}



where
      a.ValuationAreaType             =  '1'
  and a.StockValueInDisplayCurrency   <> 0
  and MATDOC.TotalGoodsMvtAmtInCCCrcy <> 0
  
group by
  a.Plant,
  b.PlantName,
  a.Product,
  a.Batch,
  d.ProductName,
  a.ProductType,
  p.MaterialTypeName,
  a.ProductGroup,
  c.CompanyCode,
  c.CompanyCodeName,
  a.MaterialBaseUnit,
  a.DisplayCurrency,
  a.StorageLocation,
  e.ProductDescription,
  a.StockValueInDisplayCurrency,
  f.DebitCreditCode,
  MATDOC.PostingDate,
  a.InventoryStockType,
  a.InventoryStockType,
  f.ConsumptionType,
  f.RejectedStockType,
  f.ReceiptStockType,
  a.MatlWrhsStkQtyInMatlBaseUnit,
  PRO.ExternalProductGroup,
  pg.ProductGroupName,
  SH.ExternalGroupDescription,
  PP.CalendarDate,
  PP.FiscalYear,
  PP.FiscalPeriod
