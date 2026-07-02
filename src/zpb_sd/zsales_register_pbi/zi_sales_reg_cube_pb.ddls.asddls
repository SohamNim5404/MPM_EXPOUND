@AbapCatalog.sqlViewName: 'ZISALESREGCUBEPB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Base Cube'
@Metadata.ignorePropagatedAnnotations: true

// Your working analytical structure
@Analytics.dataCategory: #CUBE
@VDM.viewType: #COMPOSITE

// Mandatory fix for I_BillingDocument
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE

define view ZI_SALES_REG_CUBE_PB
  as select from I_BillingDocument as a

  join I_BillingDocumentItemBasic as b
    on a.BillingDocument = b.BillingDocument

  join I_BillingDocumentBasic as f
    on a.BillingDocument = f.BillingDocument

  left outer join I_Customer as a1
    on a.SoldToParty = a1.Customer

  left outer join I_Customer as a11
    on a.PayerParty = a11.Customer

  left outer join I_SalesDocumentPartner as c
    on  b.SalesDocument   = c.SalesDocument
    and c.PartnerFunction = 'WE'

  left outer join I_Customer as c1
    on c.Customer = c1.Customer

  left outer join I_BillingDocumentPartner as d
    on  a.BillingDocument = d.BillingDocument
    and d.PartnerFunction = 'RE'

  left outer join I_BillingDocumentPartner as bp
    on  a.BillingDocument  = bp.BillingDocument
    and bp.PartnerFunction = 'RG'

  left outer join I_Customer as d1
    on d.Customer = d1.Customer

  left outer join I_Plant as e
    on e.Plant = b.Plant

  left outer join I_IN_PlantBusinessPlaceDetail as f1
    on f1.Plant = e.Plant

  left outer join I_IN_BusinessPlaceTaxDetail as g1
    on g1.BusinessPlace = f1.BusinessPlace

  left outer join I_ProductPlantBasic as e1
    on  b.Product = e1.Product
    and b.Plant   = e1.Plant

  left outer join I_BillingDocumentItem as t1
    on  t1.BillingDocument     = b.BillingDocument
    and t1.BillingDocumentItem = b.BillingDocumentItem

  left outer join ZR_EWB_TRANS_DTLS as t2
    on t2.BillingDocument = b.BillingDocument

  left outer join I_DeliveryDocumentItem as dc1
    on dc1.DeliveryDocument = b.ReferenceSDDocument

  left outer join I_SalesDocument as sd1
    on sd1.SalesDocument = dc1.ReferenceSDDocument

  left outer join I_BusinessPartner as h
    on bp.Supplier = h.BusinessPartner

  left outer join I_Product as h1
    on h1.Product = b.Product

  left outer join I_DistributionChannelText as dct
    on  dct.DistributionChannel = a.DistributionChannel
    and dct.Language            = $session.system_language

  left outer join I_BillingDocumentTypeText as bdtt
    on  bdtt.BillingDocumentType = a.BillingDocumentType
    and bdtt.Language            = $session.system_language

  left outer join I_ProductTypeText as ptt
    on  ptt.ProductType = h1.ProductType
    and ptt.Language    = $session.system_language

  left outer join I_DivisionText as dt
    on  dt.Division = a.Division
    and dt.Language = $session.system_language

  left outer join I_CustomerAccountGroupText as cg
    on cg.CustomerAccountGroup = a1.CustomerAccountGroup

  left outer join I_BusinessPartnerIndustry as ind
    on ind.BusinessPartner = a1.Customer

  left outer join ZI_ewaybill as ew
    on ew.Docno = a.BillingDocument

{
  // ==================== KEYS ====================

  key a.BillingDocument                         as BillingDocument,
  key b.BillingDocumentItem                     as BillingDocumentItem,

  // ==================== HEADER FIELDS ====================

  a.BillingDocumentDate                         as BillingDocumentDate,
  a.CompanyCode                                 as CompanyCode,
  a.BillingDocumentType                         as BillingDocumentType,
  bdtt.BillingDocumentTypeName                  as BillingDocumentTypeName,
  a.SalesOrganization                           as SalesOrganization,
  a.DistributionChannel                         as DistributionChannel,
  dct.DistributionChannelName                   as DistributionChannelName,
  a.Division                                    as Division,
  dt.DivisionName                               as DivisionName,
  a.Country                                     as Country,
  a.IncotermsClassification                     as IncotermsClassification,
  a.CustomerPaymentTerms                        as CustomerPaymentTerms,
  a.Region                                      as Region,
  a.TransactionCurrency                         as TransactionCurrency,
  a.AccountingExchangeRate                      as AccountingExchangeRate,

  // ==================== PARTNERS ====================

  a.SoldToParty                                 as SoldToParty,
  a1.CustomerName                               as SoldToName,
  a1.CustomerAccountGroup                       as AccountGroup,
  cg.AccountGroupName                           as AccountGroupName,
  a.PayerParty                                  as PayerParty,
  a11.CustomerName                              as PayerName,
  c.Customer                                    as ShipTo,
  c1.CustomerName                               as ShipToName,
  d.Customer                                    as BillTo,
  d1.CustomerName                               as BillToName,
  d1.TaxNumber3                                 as GSTIN,

  // ==================== ITEM FIELDS ====================

  b.ReferenceSDDocument                         as DeliveryDocument,
  b.ReferenceSDDocumentItem                     as DeliveryDocumentItem,
  b.SalesDocument                               as SalesDocument,
  b.SalesDocumentItem                           as SalesDocumentItem,
  b.Plant                                       as Plant,
  e.PlantName                                   as PlantName,
  b.Product                                     as Material,
  b.ProductGroup                                as MaterialGroup,
  b.BillingDocumentItemText                     as MaterialDescription,
  b.Batch                                       as Batch,

  // As a Cube, these quantities act as measures
  @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
  b.BillingQuantity                             as BillingQuantity,

  @Semantics.unitOfMeasure: true
  b.BillingQuantityUnit                         as BillingQuantityUnit,

  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  b.NetAmount                                   as NetAmount,

  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  b.TaxAmount                                   as TaxAmount,

  b.ProfitCenter                                as ProfitCenter,
  b.PriceDetnExchangeRate                       as PriceDetnExchangeRate,

  // ==================== MATERIAL DETAILS ====================

  h1.ProductType                                as MaterialType,
  ptt.MaterialTypeName                          as MaterialTypeName,
  e1.ConsumptionTaxCtrlCode                     as ConsumptionTaxCtrlCode,

  // ==================== PLANT / TAX DETAILS ====================

  t1.BillToPartyRegion                          as BillToPartyRegion,
  t1.PlantRegion                                as PlantRegion,
  t1.SalesOffice                                as SalesOffice,
  t1.SalesGroup                                 as SalesGroup,
  g1.IN_GSTIdentificationNumber                 as GSTIN1,

  // ==================== TRANSPORT ====================

  t2.VehNo                                      as VehicleNo,
  t2.TransNm                                    as TransporterName,
  t2.TransId                                    as TransporterID,

  // ==================== CUSTOMER ORDER ====================

  sd1.PurchaseOrderByCustomer                   as CustomerPONumber,
  sd1.CustomerPurchaseOrderDate                 as CustomerPODate,

  // ==================== EWAYBILL ====================

  ew.Ebillno                                    as EWayBillNo,

  // ==================== INDUSTRY ====================

  ind.IndustrySector                            as Industry,
  ind.IndustryKeyDescription                       as IndustryDescription
}
