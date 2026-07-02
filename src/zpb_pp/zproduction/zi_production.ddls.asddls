@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_PRODUCTION'
@Metadata.allowExtensions: true
define root view entity ZI_PRODUCTION
  as select from    I_MfgOrderConfirmation    as a
    left outer join I_MaterialDocumentItem_2  as MatDoc          on  a.ManufacturingOrder = MatDoc.ManufacturingOrder
                                                                 and a.MaterialDocument   = MatDoc.MaterialDocument
    left outer join I_Plant                   as PlantData       on MatDoc.Plant = PlantData.Plant
    left outer join Zmatdec                   as ProdDes         on MatDoc.Material = ProdDes.Product
    left outer join I_Product                 as Prod            on MatDoc.Material = Prod.Product
    left outer join I_ManufacturingOrder      as ProdOrd         on  MatDoc.OrderID =  ProdOrd.ManufacturingOrder
                                                                 and MatDoc.OrderID <> ' '
    left outer join I_ProductTypeText         as ProdTypeText    on  Prod.ProductType      = ProdTypeText.ProductType
                                                                 and ProdTypeText.Language = $session.system_language
    left outer join I_ProductionOrderTypeText as ProdOrdTypeText on ProdOrd.ManufacturingOrderType = ProdOrdTypeText.ProductionOrderType
    inner join      I_CompanyCode             as c               on MatDoc.CompanyCode = c.CompanyCode
    left outer join I_ProductGroupText_2      as D               on  Prod.ProductGroup = D.ProductGroup
                                                                 and D.Language        = $session.system_language
    left outer join I_ExtProdGrpText          as E               on Prod.ExternalProductGroup = E.ExternalProductGroup
    left outer join ZI_COGM_AGGR              as COGM            on  Prod.Product   = COGM.Product
                                                                 and MatDoc.Plant   = COGM.Plant
                                                                 and MatDoc.Batch   = COGM.Batch
                                                                 and MatDoc.OrderID = COGM.Orderid
    left outer join ZI_MFG_AGGR               as mfg             on  mfg.ManufacturingOrder = MatDoc.OrderID
                                                                 and mfg.ManufacturingOrder is not initial

left outer join ZI_PRODUCTION_N as Rev
    on Rev.MaterialDocument = MatDoc.MaterialDocument
      and Rev.MaterialDocumentItem     = MatDoc.MaterialDocumentItem
{
  key  max(Rev.MaterialDocument)   as MATERIALDOCUMENT,
  key  MatDoc.MaterialDocumentItem,
  key  MatDoc.MaterialDocumentYear,
  key  MatDoc.OrderID,
  key  MatDoc.Batch,
  key       mfg.WorkCenterText,
       //  key MatDoc.Material,
       MatDoc.CompanyCode,
       c.CompanyCodeName,
       MatDoc.MaterialBaseUnit,
       Prod.Product                   as Product,
       Prod.ProductType,
       ProdTypeText.MaterialTypeName,
       ProdDes.ProductDescription,
       MatDoc.Plant,
       PlantData.PlantName,
       ProdOrd.ManufacturingOrderType as ProductionOrderType,
       ProdOrdTypeText.ProductionOrderTypeName,
       MatDoc.GoodsMovementType,
       MatDoc.DebitCreditCode,
       Prod.ProductGroup,
       D.ProductGroupName,
       Prod.ExternalProductGroup,
       E.ExternalProductGroupName,

       COGM.Cogm,
       COGM.Scrap,
       COGM.Rmcost,
       COGM.Overhead,
       COGM.Fixedoverhead,
       COGM.Labour,
       COGM.AuxPower,
       COGM.Power,
       COGM.Variableoverhead,

       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       //      @DefaultAggregation: #SUM
       cast(
       case MatDoc.DebitCreditCode
         when 'S' then MatDoc.QuantityInEntryUnit
         when 'H' then -MatDoc.QuantityInEntryUnit
         else MatDoc.QuantityInEntryUnit
         end as abap.quan(13,3)
         )                            as EntryUnitQTY,

       @Semantics.quantity.unitOfMeasure: 'Workquantityunit'
       mfg.OpConfirmedWorkQuantity5   as confirmedworkquantity,

       mfg.OpWorkQuantityUnit5        as Workquantityunit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       //      @DefaultAggregation: #SUM
       cast(
         case
           when (MatDoc.GoodsMovementType = '101'
              or MatDoc.GoodsMovementType = '102')
           then MatDoc.QuantityInBaseUnit
           else 0
         end
         as abap.quan(13,3)
       )                              as Quantity,

       //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       ////      @DefaultAggregation: #SUM
       //      cast(
       //        case
       //          when( MatDoc.GoodsMovementType = '101' or MatDoc.GoodsMovementType = '102' )
       //            then cast( MatDoc.TotalGoodsMvtAmtInCCCrcy as abap.dec(15,2) )
       //          else 0
       //        end as abap.dec( 15,2 )
       //      )            as Value,

       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       //@DefaultAggregation: #SUM
       case
         when MatDoc.GoodsMovementType = '101'
           or MatDoc.GoodsMovementType = '102'
         then cast( MatDoc.TotalGoodsMvtAmtInCCCrcy as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
       end                            as Value,

       MatDoc.CompanyCodeCurrency,
//       MatDoc.PostingDate
      max(MatDoc.PostingDate)        as POSTINGDATE
}
where
  (
       MatDoc.GoodsMovementType       = '101'
    or MatDoc.GoodsMovementType       = '102'
  )
  and  MatDoc.GoodsMovementRefDocType = 'F'
  and  MatDoc.OrderID                 is not initial
  and  mfg.WorkCenterText             is not initial
  and Rev.MaterialDocument is not initial
group by
  MatDoc.MaterialDocumentItem,
  MatDoc.MaterialDocumentYear,
  MatDoc.OrderID,
  MatDoc.Batch,
  MatDoc.Material,
  MatDoc.CompanyCode,
  c.CompanyCodeName,
  MatDoc.MaterialBaseUnit,
  Prod.Product,
  Prod.ProductType,
  ProdTypeText.MaterialTypeName,
  ProdDes.ProductDescription,
  MatDoc.Plant,
  PlantData.PlantName,
  ProdOrd.ManufacturingOrderType,
  ProdOrdTypeText.ProductionOrderTypeName,
  MatDoc.GoodsMovementType,
  MatDoc.DebitCreditCode,
  Prod.ProductGroup,
  D.ProductGroupName,
  Prod.ExternalProductGroup,
  E.ExternalProductGroupName,
  COGM.Cogm,
  COGM.Scrap,
  COGM.Rmcost,
  COGM.Overhead,
  COGM.Fixedoverhead,
  COGM.Labour,
  COGM.AuxPower,
  COGM.Power,
  COGM.Variableoverhead,
  mfg.OpConfirmedWorkQuantity5,
  mfg.OpWorkQuantityUnit5,
  mfg.WorkCenterText,
  MatDoc.QuantityInEntryUnit,
  MatDoc.QuantityInBaseUnit,
  MatDoc.TotalGoodsMvtAmtInCCCrcy,
     MatDoc.PostingDate,
  MatDoc.CompanyCodeCurrency
