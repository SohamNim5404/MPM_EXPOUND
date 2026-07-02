@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Customer Profitability Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_GPR_N as select from ZGPR
{
  key InvoiceNumber,
  key InvoiceItem,
  key SplitItemKey,

  InvoiceDate,
  SalesOrganization,
  
  DistributionChannel,
  DistributionChannelName,
  Division,
  DivisionName,
  SalesOffice,
  SalesOfficeName,
  SalesGroup,
  SalesGroupName,
  ProductGroup,
  ProductGroupName,
  ExternalProductGroup,
  ExternalProductGroupName,
  
  CustomerNumber,       
  CustomerName,
  City,
  Plant,
  Product,
  Description,
  BatchNumber,
  
 // 🟢 EXISTING LOGIC UPDATED: Convert the UI output automatically!
  case when UnitOfMeasure = 'KG' then cast('MT' as abap.unit(3))
       when UnitOfMeasure = 'L'  then cast('KG' as abap.unit(3))
       else UnitOfMeasure end as UnitOfMeasure,
       
  // 🟢 THE FIX: Pure integer math (8/10) completely avoids the FLTP crash
  @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
  case when UnitOfMeasure = 'KG' then cast( FinalQuantity / 1000 as abap.dec(15,3) )
       when UnitOfMeasure = 'L'  then cast( (FinalQuantity * 8) / 10 as abap.dec(15,3) )
       else cast( FinalQuantity as abap.dec(15,3) ) end as Quantity,

  DocumentCurrency,
  CompanyCodeCurrency,
  MaterialBaseUnit,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  FinalNetAmount as ExactNetValue,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  FinalAssessableValue as AssessableValue,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast( FinalNetAmount / case when FinalQuantity <= 0 then 1 else FinalQuantity end as abap.dec(23,2) ) as UnitPrice,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitCOGM as UnitCogmValue,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitRMCost as UnitRMCost,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitScrap as UnitScrapValue,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitOverhead as UnitOverheadValue,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitFixedOverhead,    
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitLabour,           
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitAuxPower,         
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitPower,            
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitVarOverhead,  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  UnitFreight as Freight,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast( UnitCOGM * FinalQuantity as abap.dec(23,2) ) as TotalCOGM,

  case when UnitCOGM > 0 
       then cast( (UnitScrap / UnitCOGM) * 100 as abap.dec(15,2) )
       else cast(0 as abap.dec(15,2)) end as ScrapPercentage,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast( (FinalNetAmount / case when FinalQuantity <= 0 then 1 else FinalQuantity end) - UnitCOGM - UnitFreight as abap.dec(23,2) ) as UnitProfitValue,

  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast( FinalNetAmount - (UnitCOGM * FinalQuantity) - (UnitFreight * FinalQuantity) as abap.dec(23,2) ) as TotalProfitValue,
  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  cast( FinalNetAmount - (UnitCOGM * FinalQuantity) - (UnitFreight * FinalQuantity) as abap.dec(23,2) ) as ProfitValue,

  cast( case when FinalNetAmount <= 0 then 0
             else ( (FinalNetAmount - (UnitCOGM * FinalQuantity) - (UnitFreight * FinalQuantity)) / FinalNetAmount ) * 100
        end as abap.dec(15,2) ) as ProfitPercentAss,

  cast( case when FinalNetAmount <= 0 then 1
             when ( (FinalNetAmount - (UnitCOGM * FinalQuantity) - (UnitFreight * FinalQuantity)) / FinalNetAmount ) * 100 >= 20.00 then 3 
             else 1 
        end as abap.int1 ) as StatusCriticality,

  case when FinalNetAmount <= 0 then cast('Loss' as abap.char(6))
       when ( (FinalNetAmount - (UnitCOGM * FinalQuantity) - (UnitFreight * FinalQuantity)) / FinalNetAmount ) * 100 >= 20.00 then cast('Profit' as abap.char(6))
       else cast('Loss' as abap.char(6)) end as OverallStatus
}
