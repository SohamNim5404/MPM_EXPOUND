@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base Aggregation for Profitability'
define view entity ZGPR as select from I_BillingDocumentItem as BillItem
join I_BillingDocument as BillHeader on BillItem.BillingDocument = BillHeader.BillingDocument
left outer join I_Customer as Customer on BillHeader.SoldToParty = Customer.Customer
left outer join I_CompanyCode as CompCode on BillHeader.CompanyCode = CompCode.CompanyCode

// 1. MAIN ITEM LINK
left outer join I_BillingDocumentItem as MainItem
  on  BillItem.BillingDocument = MainItem.BillingDocument
  and BillItem.HigherLevelItem = MainItem.BillingDocumentItem

// 2. PRICING 
left outer join ZI_GPR as Pricing 
  on BillItem.BillingDocument = Pricing.BillingDocument 
  and BillItem.BillingDocumentItem = Pricing.BillingDocumentItem

left outer join Z_PRCG as MainPricing 
  on MainItem.BillingDocument = MainPricing.BillingDocument 
  and MainItem.BillingDocumentItem = MainPricing.BillingDocumentItem

// 3. DELIVERY MAIN
left outer join I_DeliveryDocumentItem as DeliveryMain
  on  BillItem.ReferenceSDDocument = DeliveryMain.DeliveryDocument
  and BillItem.ReferenceSDDocumentItem = DeliveryMain.DeliveryDocumentItem

// 4. DELIVERY SPLIT
left outer join I_DeliveryDocumentItem as DeliverySplit
  on  BillItem.ReferenceSDDocument = DeliverySplit.DeliveryDocument
  and BillItem.ReferenceSDDocumentItem = DeliverySplit.HigherLvlItmOfBatSpltItm
  and DeliverySplit.Batch <> ''

// 4b. BILLING SUB-ITEM BRIDGE
left outer join I_BillingDocumentItem as SubBillItem
  on  SubBillItem.BillingDocument = BillItem.BillingDocument
  and SubBillItem.ReferenceSDDocument = DeliverySplit.DeliveryDocument
  and SubBillItem.ReferenceSDDocumentItem = DeliverySplit.DeliveryDocumentItem

// 5. COGM SPLIT
left outer join ztb_cogm as CostingSplit 
  on  CostingSplit.billingdocument = SubBillItem.BillingDocument
  and CostingSplit.billingdocumentitem = SubBillItem.BillingDocumentItem

// 6. COGM MAIN
left outer join ztb_cogm as CostingMain 
  on  BillItem.BillingDocument = CostingMain.billingdocument
  and BillItem.BillingDocumentItem = CostingMain.billingdocumentitem

// 7. MAIN COGM
left outer join ztb_cogm as MainCosting 
  on  MainItem.BillingDocument = MainCosting.billingdocument
  and MainItem.BillingDocumentItem = MainCosting.billingdocumentitem

// 8. SALES DOCUMENT LINK
left outer join I_SalesDocument as SalesDoc
  on BillItem.SalesDocument = SalesDoc.SalesDocument

// 9. TEXT JOINS
left outer join I_SalesOfficeText as SalesOfficeText 
  on  SalesDoc.SalesOffice = SalesOfficeText.SalesOffice 
  and SalesOfficeText.Language = $session.system_language

left outer join I_SalesGroupText as SalesGroupText 
  on  SalesDoc.SalesGroup = SalesGroupText.SalesGroup 
  and SalesGroupText.Language = $session.system_language

left outer join I_ProductGroupText_2 as ProductGroupText 
  on  BillItem.ProductGroup = ProductGroupText.ProductGroup 
  and ProductGroupText.Language = $session.system_language

left outer join I_Product as ProductData 
  on BillItem.Product = ProductData.Product

left outer join I_DistributionChannelText as DistChannelText
  on  BillHeader.DistributionChannel = DistChannelText.DistributionChannel
  and DistChannelText.Language = $session.system_language

left outer join I_DivisionText as DivisionText
  on  BillItem.Division = DivisionText.Division
  and DivisionText.Language = $session.system_language

left outer join I_ExtProdGrpText as epgt 
  on  epgt.ExternalProductGroup = ProductData.ExternalProductGroup 
  and epgt.Language = $session.system_language
{

  key BillItem.BillingDocument as InvoiceNumber,
  key BillItem.BillingDocumentItem as InvoiceItem,

  key case when DeliverySplit.DeliveryDocumentItem is not initial 
           then DeliverySplit.DeliveryDocumentItem 
           else cast( '000000' as abap.numc(6) ) end as SplitItemKey,

  BillHeader.BillingDocumentDate as InvoiceDate,
  BillHeader.SalesOrganization as SalesOrganization,
  BillHeader.SoldToParty as CustomerNumber,
  Customer.CustomerName as CustomerName,
  Customer.CityName as City,
  BillItem.Plant as Plant,
  BillItem.Product as Product,
  coalesce(BillItem.ProductGroup, MainItem.ProductGroup) as ProductGroup,
  coalesce(BillItem.BillingDocumentItemText, MainItem.BillingDocumentItemText) as Description,

  BillHeader.DistributionChannel,
  BillItem.Division,
  SalesDoc.SalesOffice,
  SalesDoc.SalesGroup,
  ProductData.ExternalProductGroup,

  // 🟢 ALL TEXT FIELDS 
  max(SalesOfficeText.SalesOfficeName) as SalesOfficeName,
  max(SalesGroupText.SalesGroupName) as SalesGroupName,
  max(ProductGroupText.ProductGroupName) as ProductGroupName,
  max(DistChannelText.DistributionChannelName) as DistributionChannelName,
  max(DivisionText.DivisionName) as DivisionName,
  max(epgt.ExternalProductGroupName) as ExternalProductGroupName,

  case when DeliverySplit.Batch <> '' then DeliverySplit.Batch
       when CostingSplit.batch <> '' then CostingSplit.batch
       when CostingMain.batch <> '' then CostingMain.batch
       when DeliveryMain.Batch <> '' then DeliveryMain.Batch
       else BillItem.Batch end as BatchNumber,

  coalesce(BillItem.BillingQuantityUnit, MainItem.BillingQuantityUnit) as UnitOfMeasure,
  BillHeader.TransactionCurrency as DocumentCurrency,
  CompCode.Currency as CompanyCodeCurrency,
  coalesce(BillItem.BaseUnit, MainItem.BaseUnit) as MaterialBaseUnit,

  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
  max( case when DeliverySplit.ActualDeliveryQuantity > 0 then DeliverySplit.ActualDeliveryQuantity
            when BillItem.BillingQuantity > 0 then BillItem.BillingQuantity
            else coalesce(DeliveryMain.ActualDeliveryQuantity, cast(0 as abap.quan(13,3))) end ) as FinalQuantity,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( case 
         when DeliverySplit.ActualDeliveryQuantity > 0 and BillItem.BillingQuantity > 0
           then cast( cast( currency_conversion( amount => BillItem.NetAmount, source_currency => BillHeader.TransactionCurrency, target_currency => cast('INR' as abap.cuky), exchange_rate_date => BillHeader.BillingDocumentDate, error_handling => 'SET_TO_NULL' ) as abap.dec(15,2) ) / cast(BillItem.BillingQuantity as abap.dec(15,3)) * cast(DeliverySplit.ActualDeliveryQuantity as abap.dec(15,3)) as abap.dec(23,2) )
         when BillItem.HigherLevelItem is not initial and MainItem.BillingQuantity > 0
           then cast( cast( currency_conversion( amount => MainItem.NetAmount, source_currency => BillHeader.TransactionCurrency, target_currency => cast('INR' as abap.cuky), exchange_rate_date => BillHeader.BillingDocumentDate, error_handling => 'SET_TO_NULL' ) as abap.dec(15,2) ) / cast(MainItem.BillingQuantity as abap.dec(15,3)) * coalesce(cast(DeliveryMain.ActualDeliveryQuantity as abap.dec(15,3)), 0) as abap.dec(23,2) )
         else cast( currency_conversion( amount => BillItem.NetAmount, source_currency => BillHeader.TransactionCurrency, target_currency => cast('INR' as abap.cuky), exchange_rate_date => BillHeader.BillingDocumentDate, error_handling => 'SET_TO_NULL' ) as abap.dec(23,2) )
       end ) as FinalNetAmount,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( case 
         when DeliverySplit.ActualDeliveryQuantity > 0 and BillItem.BillingQuantity > 0
           then cast( ( coalesce(Pricing.ConvertedTotalAmount, 0) / cast(BillItem.BillingQuantity as abap.dec(15,3)) ) * cast(DeliverySplit.ActualDeliveryQuantity as abap.dec(15,3)) as abap.dec(23,2) )
             
         when BillItem.HigherLevelItem is not initial and MainItem.BillingQuantity > 0
           then cast( ( coalesce(MainPricing.ConvertedTotalAmount, 0) / cast(MainItem.BillingQuantity as abap.dec(15,3)) ) * coalesce(cast(DeliveryMain.ActualDeliveryQuantity as abap.dec(15,3)), 0) as abap.dec(23,2) )
             
         else cast( coalesce(Pricing.ConvertedTotalAmount, 0) as abap.dec(23,2) )
       end ) as FinalAssessableValue,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.freight, coalesce(CostingMain.freight, coalesce(MainCosting.freight, 0))) ) as UnitFreight,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.cogm, coalesce(CostingMain.cogm, coalesce(MainCosting.cogm, 0))) ) as UnitCOGM,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.rmcost, coalesce(CostingMain.rmcost, coalesce(MainCosting.rmcost, 0))) ) as UnitRMCost,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.scrap, coalesce(CostingMain.scrap, coalesce(MainCosting.scrap, 0))) ) as UnitScrap,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.overhead, coalesce(CostingMain.overhead, coalesce(MainCosting.overhead, 0))) ) as UnitOverhead,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.fixedoverhead, coalesce(CostingMain.fixedoverhead, coalesce(MainCosting.fixedoverhead, 0))) ) as UnitFixedOverhead,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.labour, coalesce(CostingMain.labour, coalesce(MainCosting.labour, 0))) ) as UnitLabour,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.aux_power, coalesce(CostingMain.aux_power, coalesce(MainCosting.aux_power, 0))) ) as UnitAuxPower,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.power, coalesce(CostingMain.power, coalesce(MainCosting.power, 0))) ) as UnitPower,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  max( coalesce(CostingSplit.variableoverhead, coalesce(CostingMain.variableoverhead, coalesce(MainCosting.variableoverhead, 0))) ) as UnitVarOverhead

}
where BillHeader.BillingDocumentType <> 'S1'
  and BillHeader.BillingDocumentType <> 'S2'
  and BillHeader.BillingDocumentIsCancelled = ''
  and BillItem.NetAmount <> 0 
  and BillHeader.DistributionChannel <> '40'
  and ( DeliveryMain.HigherLvlItmOfBatSpltItm is initial )
  and ( BillItem.Batch <> '' 
        or DeliveryMain.Batch <> '' 
        or DeliverySplit.Batch <> '' 
        or CostingMain.batch <> '' 
        or CostingSplit.batch <> '' )

group by
  BillItem.BillingDocument,
  BillItem.BillingDocumentItem,
  DeliverySplit.DeliveryDocumentItem, 
  BillHeader.BillingDocumentDate,
  BillHeader.TransactionCurrency,
  BillHeader.SalesOrganization,
  BillHeader.SoldToParty,
  BillHeader.CompanyCode,
  Customer.CustomerName,
  Customer.CityName,
  BillItem.Plant,
  BillItem.Product,
  BillItem.ProductGroup,
  MainItem.ProductGroup,
  BillItem.BillingDocumentItemText,
  MainItem.BillingDocumentItemText,
  BillItem.Batch,
  DeliverySplit.Batch,
  CostingSplit.batch,
  CostingMain.batch,
  DeliveryMain.Batch,
  BillItem.HigherLevelItem,
  BillItem.BillingQuantityUnit,
  MainItem.BillingQuantityUnit,
  CompCode.Currency,
  BillItem.BaseUnit,
  MainItem.BaseUnit,
  BillHeader.DistributionChannel,
  BillItem.Division,
  SalesDoc.SalesOffice,
  SalesDoc.SalesGroup,
  ProductData.ExternalProductGroup
