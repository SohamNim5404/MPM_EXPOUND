@AbapCatalog.sqlViewName: 'ZCSALESREGREPPB'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Analytical Query'
@Metadata.ignorePropagatedAnnotations: true

// Turns it into an executable report/query
@VDM.viewType: #CONSUMPTION
@Analytics.query: true

// Mandatory fix for client handling
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE

define view ZC_SALES_REG_REPORT_PB
  as select from ZI_SALES_REG_CUBE
{
  // ==================== KEYS / PRIMARY DIMENSIONS ====================
  
  @AnalyticsDetails.query.display: #KEY_TEXT
  key BillingDocument,
  key BillingDocumentItem,

  // ==================== HEADER FIELDS ====================
  
  BillingDocumentDate,
  CompanyCode,
  BillingDocumentType,
  BillingDocumentTypeName,
  SalesOrganization,
  DistributionChannel,
  DistributionChannelName,
  Division,
  DivisionName,
  Country,
  IncotermsClassification,
  CustomerPaymentTerms,
  Region,
  AccountingExchangeRate,

  // ==================== PARTNERS ====================
  
  SoldToParty,
  SoldToName,
  AccountGroup,
  AccountGroupName,
  PayerParty,
  PayerName,
  ShipTo,
  ShipToName,
  BillTo,
  BillToName,
  GSTIN,

  // ==================== ITEM FIELDS ====================
  
  DeliveryDocument,
  DeliveryDocumentItem,
  SalesDocument,
  SalesDocumentItem,
  Plant,
  PlantName,
  Material,
  MaterialGroup,
  MaterialDescription,
  Batch,
  ProfitCenter,
  PriceDetnExchangeRate,

  // ==================== MATERIAL DETAILS ====================
  
  MaterialType,
  MaterialTypeName,
  ConsumptionTaxCtrlCode,

  // ==================== PLANT / TAX DETAILS ====================
  
  BillToPartyRegion,
  PlantRegion,
  SalesOffice,
  SalesGroup,
  GSTIN1,

  // ==================== TRANSPORT ====================
  
  VehicleNo,
  TransporterName,
  TransporterID,

  // ==================== CUSTOMER ORDER ====================
  
  CustomerPONumber,
  CustomerPODate,

  // ==================== EWAYBILL ====================
  
  EWayBillNo,

  // ==================== INDUSTRY ====================
  
  Industry,
  IndustryDescription,

  // ==================== MEASURES & UNITS ====================
  // These will automatically sum up based on the Cube's annotations
  
  BillingQuantity,
  BillingQuantityUnit,
  NetAmount,
  TaxAmount,
  TransactionCurrency
}
