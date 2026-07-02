@EndUserText.label: 'Sales Register Consumption View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@UI.headerInfo: {
  typeName: 'Sales Register',
  typeNamePlural: 'Sales Register',
  title: {
    value: 'BillingDocument'
  },
  description: {
    value: 'CustomerName'
  }
}
define root view entity ZC_SALES_REG_PB
  provider contract transactional_query
  as projection on ZI_SALES_REG_PB
{
  @UI.facet: [
    {
      id: 'SalesRegister',
      purpose: #STANDARD,
      type: #IDENTIFICATION_REFERENCE,
      label: 'Sales Register',
      position: 10
    }
  ]

  @UI.selectionField: [{ position: 10 }]
  @UI.lineItem: [{ label: 'Billing Document', position: 10, importance: #HIGH }]
  @UI.identification: [{ position: 10 }]
  key BillingDocument,
  
  
  @UI.selectionField: [{ position: 15 }]
  @UI.lineItem: [{ label: 'Item', position: 15, importance: #HIGH }]
  @UI.identification: [{ position: 15 }]
  key BillingDocumentItem,

  @UI.selectionField: [{ position: 20 }]
  @UI.lineItem: [{ label: 'Billing Date', position: 20, importance: #HIGH }]
  @UI.identification: [{ position: 20 }]
  BillingDocumentDate,

  @UI.selectionField: [{ position: 30 }]
  @UI.lineItem: [{ label: 'Company Code', position: 30, importance: #HIGH }]
  @UI.identification: [{ position: 30 }]
  CompanyCode,


  @UI.selectionField: [{ position: 50 }]
  @UI.lineItem: [{ label: 'Billing Type', position: 50, importance: #HIGH }]
  @UI.identification: [{ position: 50 }]
  BillingDocumentType,

  @UI.selectionField: [{ position: 60 }]
  @UI.lineItem: [{ label: 'Sold-to Party', position: 60, importance: #HIGH }]
  @UI.identification: [{ position: 60 }]
  SoldToParty,

  @UI.lineItem: [{ label: 'Sold-to Name', position: 70, importance: #HIGH }]
  @UI.identification: [{ position: 70 }]
  CustomerName,

  @UI.selectionField: [{ position: 80 }]
  @UI.lineItem: [{ label: 'Plant', position: 80, importance: #HIGH }]
  @UI.identification: [{ position: 80 }]
  Plant,

  @UI.lineItem: [{ label: 'Invoice Type', position: 90, importance: #HIGH }]
  @UI.identification: [{ position: 90 }]
  BillingDocumentTypeName,

  @UI.selectionField: [{ position: 100 }]
  @UI.lineItem: [{ label: 'Sales Organization', position: 100, importance: #HIGH }]
  @UI.identification: [{ position: 100 }]
  SalesOrganization,

  @UI.selectionField: [{ position: 110 }]
  @UI.lineItem: [{ label: 'Ship-to Party', position: 110, importance: #HIGH }]
  @UI.identification: [{ position: 110 }]
  Customer,

  @UI.lineItem: [{ label: 'Sales Office', position: 120, importance: #HIGH }]
  @UI.identification: [{ position: 120 }]
  SalesOffice,

  @UI.lineItem: [{ label: 'Desc Sales Off', position: 130, importance: #HIGH }]
  @UI.identification: [{ position: 130 }]
  SalesOfficeName,

  @UI.selectionField: [{ position: 140 }]
  @UI.lineItem: [{ label: 'Material', position: 140, importance: #HIGH }]
  @UI.identification: [{ position: 140 }]
  Product,

  @UI.lineItem: [{ label: 'Description', position: 150, importance: #HIGH }]
  @UI.identification: [{ position: 150 }]
  ProductName,

  @UI.lineItem: [{ label: 'Batch', position: 160, importance: #HIGH }]
  @UI.identification: [{ position: 160 }]
  Batch,

  @UI.lineItem: [{ label: 'Ext. Material Group', position: 170, importance: #HIGH }]
  @UI.identification: [{ position: 170 }]
  ExternalProductGroup,

  @UI.lineItem: [{ label: 'Sub-Mat. Group Text', position: 180, importance: #HIGH }]
  @UI.identification: [{ position: 180 }]
  ExternalProductGroupName,

  @UI.lineItem: [{ label: 'Billed Quantity', position: 190, importance: #HIGH }]
  @UI.identification: [{ position: 190 }]
  BillingQuantity,

  @UI.lineItem: [{ label: 'Purchase Order Number', position: 200, importance: #HIGH }]
  @UI.identification: [{ position: 200 }]
  PurchaseOrderByCustomer,

  @UI.lineItem: [{ label: 'Document Currency', position: 210, importance: #HIGH }]
  @UI.identification: [{ position: 210 }]
  TransactionCurrency,

  @UI.lineItem: [{ label: 'Sales Unit', position: 220, importance: #HIGH }]
  @UI.identification: [{ position: 220 }]
  BillingQuantityUnit,

  @UI.lineItem: [{ label: 'Ass. Value', position: 230, importance: #HIGH }]
  @UI.identification: [{ position: 230 }]
  NetAmount,

  @UI.lineItem: [{ label: 'Gross Value', position: 240, importance: #HIGH }]
  @UI.identification: [{ position: 240 }]
  Gross_Value,

  @UI.lineItem: [{ label: 'Unit Price', position: 250, importance: #HIGH }]
  @UI.identification: [{ position: 250 }]
  Unit_Price,

  @UI.lineItem: [{ label: 'Fiscal Year', position: 260, importance: #HIGH }]
  @UI.identification: [{ position: 260 }]
  FiscalYear,

  @UI.lineItem: [{ label: 'Posting Period', position: 270, importance: #HIGH }]
  @UI.identification: [{ position: 270 }]
  FiscalPeriod,

  @UI.lineItem: [{ label: 'Month', position: 280, importance: #HIGH }]
  @UI.identification: [{ position: 280 }]
  Monthss
}
