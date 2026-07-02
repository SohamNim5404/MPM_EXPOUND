@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YSD24 Projection'
@Metadata.allowExtensions: true 
define root view entity ZC_GPR provider contract transactional_query
  as projection on ZI_GPR_N
{
  key InvoiceNumber,
  key InvoiceItem,
  key SplitItemKey,         
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
      
      InvoiceDate,
      CustomerNumber,       
      CustomerName,
      City,
      Plant,
      Product,
      Description,
      BatchNumber,
      
    
      @DefaultAggregation: #SUM
      Quantity,
      UnitOfMeasure,
      DocumentCurrency,
      CompanyCodeCurrency,
      MaterialBaseUnit,
      
      // 🟢 ADD SUM TO YOUR OTHER TOTALS SO THEY DON'T MISMATCH
      @DefaultAggregation: #SUM
      ExactNetValue,
      
      UnitPrice,
           
      @DefaultAggregation: #SUM
      AssessableValue,
      
      @DefaultAggregation: #SUM
      Freight,
      
      UnitCogmValue,        
      UnitRMCost,
      UnitScrapValue,
      ScrapPercentage,      
      UnitOverheadValue,
      UnitFixedOverhead,    
      UnitLabour,           
      UnitAuxPower,         
      UnitPower,            
      UnitVarOverhead,  
      
      @DefaultAggregation: #SUM
      TotalCOGM,
      
      UnitProfitValue,      
      ProfitValue,
      
      @DefaultAggregation: #SUM
      TotalProfitValue,
      
      ProfitPercentAss,
      StatusCriticality,
      OverallStatus
}
