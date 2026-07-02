@EndUserText.label: 'Sales Register Interface'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
  typeName: 'Sales Register',
  typeNamePlural: 'Sales Register'
}
define root view entity ZI_SALES_REG_PB
  as select from I_BillingDocument as a

    inner join I_BillingDocumentItemBasic as b
      on a.BillingDocument = b.BillingDocument

    left outer join I_Customer as a1
      on a.SoldToParty = a1.Customer

    left outer join I_SalesDocumentPartner as c
      on b.SalesDocument = c.SalesDocument
     and c.PartnerFunction = 'WE'

    left outer join I_Plant as e
      on e.Plant = b.Plant

    left outer join I_BillingDocumentItem as t1
      on t1.BillingDocument     = b.BillingDocument
     and t1.BillingDocumentItem = b.BillingDocumentItem

    left outer join I_DeliveryDocumentItem as dc1
      on dc1.DeliveryDocument     = b.ReferenceSDDocument
     and dc1.DeliveryDocumentItem = b.ReferenceSDDocumentItem

    left outer join I_SalesDocument as sd1
      on sd1.SalesDocument = dc1.ReferenceSDDocument

    left outer join I_Product as h1
      on h1.Product = b.Product

    left outer join I_ProductText as pt
      on pt.Product  = h1.Product
     and pt.Language = $session.system_language

    left outer join I_ExtProdGrpText as extp
      on extp.ExternalProductGroup = h1.ExternalProductGroup
     and extp.Language             = $session.system_language

    left outer join I_BillingDocumentTypeText as bdtt
      on bdtt.BillingDocumentType = a.BillingDocumentType
     and bdtt.Language            = $session.system_language

    left outer join I_SalesOfficeText as ot
      on ot.SalesOffice = t1.SalesOffice
     and ot.Language    = $session.system_language

 left outer join I_CompanyCode as cc
  on a.CompanyCode = cc.CompanyCode

left outer join I_FiscalCalendarDate     as PP     on  PP.FiscalYearVariant = cc.FiscalYearVariant
                                                    and PP.CalendarDate  = a.BillingDocumentDate

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
  key a.BillingDocument,
  
   @UI.selectionField: [{ position: 15 }]
  @UI.lineItem: [{ label: 'Item', position: 15, importance: #HIGH }]
  @UI.identification: [{ position: 15 }]
  key b.BillingDocumentItem ,

  @UI.selectionField: [{ position: 20 }]
  @UI.lineItem: [{ label: 'Billing Date', position: 20, importance: #HIGH }]
  @UI.identification: [{ position: 20 }]
      a.BillingDocumentDate ,

  @UI.selectionField: [{ position: 30 }]
  @UI.lineItem: [{ label: 'Company Code', position: 30, importance: #HIGH }]
  @UI.identification: [{ position: 30 }]
      a.CompanyCode ,

 

  @UI.selectionField: [{ position: 50 }]
  @UI.lineItem: [{ label: 'Billing Type', position: 50, importance: #HIGH }]
  @UI.identification: [{ position: 50 }]
      a.BillingDocumentType ,

  @UI.selectionField: [{ position: 60 }]
  @UI.lineItem: [{ label: 'Sold-to Party', position: 60, importance: #HIGH }]
  @UI.identification: [{ position: 60 }]
      a.SoldToParty ,

  @UI.lineItem: [{ label: 'Sold-to Name', position: 70, importance: #HIGH }]
  @UI.identification: [{ position: 70 }]
      a1.CustomerName ,

  @UI.selectionField: [{ position: 80 }]
  @UI.lineItem: [{ label: 'Plant', position: 80, importance: #HIGH }]
  @UI.identification: [{ position: 80 }]
      b.Plant ,

  @UI.lineItem: [{ label: 'Invoice Type', position: 90, importance: #HIGH }]
  @UI.identification: [{ position: 90 }]
      bdtt.BillingDocumentTypeName ,

  @UI.selectionField: [{ position: 100 }]
  @UI.lineItem: [{ label: 'Sales Organization', position: 100, importance: #HIGH }]
  @UI.identification: [{ position: 100 }]
      a.SalesOrganization ,

  @UI.selectionField: [{ position: 110 }]
  @UI.lineItem: [{ label: 'Ship-to Party', position: 110, importance: #HIGH }]
  @UI.identification: [{ position: 110 }]
      c.Customer ,

  @UI.lineItem: [{ label: 'Sales Office', position: 120, importance: #HIGH }]
  @UI.identification: [{ position: 120 }]
      t1.SalesOffice ,

  @UI.lineItem: [{ label: 'Desc Sales Off', position: 130, importance: #HIGH }]
  @UI.identification: [{ position: 130 }]
      ot.SalesOfficeName ,

  @UI.selectionField: [{ position: 140 }]
  @UI.lineItem: [{ label: 'Material', position: 140, importance: #HIGH }]
  @UI.identification: [{ position: 140 }]
      b.Product ,

  @UI.lineItem: [{ label: 'Description', position: 150, importance: #HIGH }]
  @UI.identification: [{ position: 150 }]
      pt.ProductName ,

  @UI.lineItem: [{ label: 'Batch', position: 160, importance: #HIGH }]
  @UI.identification: [{ position: 160 }]
      b.Batch ,

  @UI.lineItem: [{ label: 'Ext. Material Group', position: 170, importance: #HIGH }]
  @UI.identification: [{ position: 170 }]
      h1.ExternalProductGroup ,

  @UI.lineItem: [{ label: 'Sub-Mat. Group Text', position: 180, importance: #HIGH }]
  @UI.identification: [{ position: 180 }]
      extp.ExternalProductGroupName,

  @UI.lineItem: [{ label: 'Billed Quantity', position: 190, importance: #HIGH }]
  @UI.identification: [{ position: 190 }]
  @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      b.BillingQuantity ,

  @UI.lineItem: [{ label: 'Purchase Order Number', position: 200, importance: #HIGH }]
  @UI.identification: [{ position: 200 }]
      sd1.PurchaseOrderByCustomer ,

  @UI.lineItem: [{ label: 'Document Currency', position: 210, importance: #HIGH }]
  @UI.identification: [{ position: 210 }]
      a.TransactionCurrency ,

  @UI.lineItem: [{ label: 'Sales Unit', position: 220, importance: #HIGH }]
  @UI.identification: [{ position: 220 }]
      b.BillingQuantityUnit ,

  @UI.lineItem: [{ label: 'Ass. Value', position: 230, importance: #HIGH }]
  @UI.identification: [{ position: 230 }]
  @Semantics.amount.currencyCode: 'TransactionCurrency'
      b.NetAmount ,

  @UI.lineItem: [{ label: 'Gross Value', position: 240, importance: #HIGH }]
  @UI.identification: [{ position: 240 }]
  @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( b.NetAmount + b.TaxAmount as abap.curr(16,2) ) as Gross_Value,

@UI.lineItem: [{ label: 'Unit Price', position: 250, importance: #HIGH }]
@UI.identification: [{ position: 250 }]
cast(
  case
    when b.BillingQuantity = 0
      then cast( 0 as abap.dec(16,2) )
    else division(
           cast( b.NetAmount       as abap.dec(16,2) ),
           cast( b.BillingQuantity as abap.dec(16,2) ),
           2
         )
  end
as abap.dec(16,2) ) as Unit_Price,

  @UI.lineItem: [{ label: 'Fiscal Year', position: 260, importance: #HIGH }]
  @UI.identification: [{ position: 260 }]
      PP.FiscalYear ,

  @UI.lineItem: [{ label: 'Posting Period', position: 270, importance: #HIGH }]
  @UI.identification: [{ position: 270 }]
      PP.FiscalPeriod ,

  @UI.lineItem: [{ label: 'Month', position: 280, importance: #HIGH }]
  @UI.identification: [{ position: 280 }]
      case substring( cast( a.BillingDocumentDate as abap.char(8) ), 5, 2 )
        when '01' then 'January'
        when '02' then 'February'
        when '03' then 'March'
        when '04' then 'April'
        when '05' then 'May'
        when '06' then 'June'
        when '07' then 'July'
        when '08' then 'August'
        when '09' then 'September'
        when '10' then 'October'
        when '11' then 'November'
        when '12' then 'December'
        else ''
      end as Monthss
}
