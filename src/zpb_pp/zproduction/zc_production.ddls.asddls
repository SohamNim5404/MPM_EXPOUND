@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_CUST_DASHBOARD'
@Metadata.allowExtensions: true
define root view entity ZC_PRODUCTION 
//  provider contract transactional_query
  as projection on ZI_PRODUCTION
{

  key MATERIALDOCUMENT,
  key MaterialDocumentItem,
  key MaterialDocumentYear,
  key orderid,
  key Batch,
  key    WorkCenterText,
      CompanyCode,
      CompanyCodeName,
      MaterialBaseUnit,
      Product,
      ProductType,
      MaterialTypeName,
      ProductDescription,
      Plant,
      PlantName,
      ProductionOrderType,
      ProductionOrderTypeName,
      ProductGroup,
      ProductGroupName,
      ExternalProductGroup,
      ExternalProductGroupName,
      Cogm,
      Scrap,
      Rmcost,
      Overhead,
      Fixedoverhead,
      Labour,
      AuxPower,
      Power,
      Variableoverhead,
      confirmedworkquantity,
      Workquantityunit,
//      WorkCenterText,
      GoodsMovementType,
      EntryUnitQTY,
      Quantity,
      Value,
      CompanyCodeCurrency,
      POSTINGDATE
      }
