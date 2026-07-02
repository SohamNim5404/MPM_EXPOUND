@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YFI01 Customer Aging : Base View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTOMER_AGE01
//  with parameters
//    P_KeyDate : abap.dats
  as select from    I_JournalEntryItem                                                             as a
    inner join      I_OperationalAcctgDocItem                                                      as b on  a.CompanyCode            = b.CompanyCode
                                                                                                        and a.FiscalYear             = b.FiscalYear
                                                                                                        and a.AccountingDocument     = b.AccountingDocument
                                                                                                        and a.AccountingDocumentItem = b.AccountingDocumentItem

    // --- THE FIX: Explicitly join the FI Header instead of using path expressions ---
    left outer join I_JournalEntry                                                                 as je on  a.CompanyCode        = je.CompanyCode
                                                                                                        and a.FiscalYear         = je.FiscalYear
                                                                                                        and a.AccountingDocument = je.AccountingDocument

    // Now we can safely join the SD Billing Header using the explicit FI Header
    left outer join I_BillingDocument                                                              as sdh on je.OriginalReferenceDocument = sdh.BillingDocument
//left outer join I_BillingDocument                                                                  as sdh on je.AccountingDocument = sdh.AccountingDocument

//left outer join I_BillingDocument as sdh
//  on  je.CompanyCode        = sdh.CompanyCode
//  and je.AccountingDocument = sdh.AccountingDocument
//  and je.FiscalYear         = sdh.FiscalYear

//left outer join I_BillingDocument                                                                as sdh on je.CompanyCode        = sdh.CompanyCode
//                                                                                                       and je.AccountingDocument = sdh.AccountingDocument
//                    and je.FiscalYear         = sdh.FiscalYear
    
    left outer join I_BillingDocumentItem                                                          as sdi on  sdh.BillingDocument       = sdi.BillingDocument
                                                                                                        and sdi.BillingDocumentItem = '000010'

    left outer join I_SalesGroupText                                                               as d on  sdi.SalesGroup = d.SalesGroup
                                                                                                        and d.Language   = $session.system_language
                                                                                                        
    left outer join I_SalesOfficeText                                                              as e on  sdi.SalesOffice = e.SalesOffice
                                                                                                        and e.Language    = $session.system_language
                                                                                                        
    left outer join I_BusinessAreaText                                                             as f on  a.BusinessArea = f.BusinessArea
                                                                                                        and f.Language     = $session.system_language
                                                                                                        
    left outer join I_ProductGroupText_2                                                           as g on  sdi.ProductGroup = g.ProductGroup
                                                                                                        and g.Language     = $session.system_language
                                                                                                        
    left outer join I_PaymentTermsConditions as pt
                                                                                                   on b.PaymentTerms = pt.PaymentTerms                                                                                                    
{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.Customer,
      a._Customer.CustomerName,
      a._Customer.Country                                   as CustomerCountry,
      a._Customer.Region                                    as CustomerRegion,
      a._Customer.CityName                                  as City,
      a._Customer.CustomerAccountGroup                      as CustomerGroup,
      a.Supplier                                            as Vendor,
      a.DebitCreditCode,
      
      a.AccountingDocumentType,
      a.PostingDate,
      a.DocumentDate,
      a.ClearingDate,
      a.NetDueDate,
      b.DueCalculationBaseDate                              as BaselineDate,
      a.GLAccount,
      a.SpecialGLCode,
      a._SpecialGLCode._Text[ Language = $session.system_language ].SpecialGLCodeName,
      a.CompanyCodeCurrency,
      a.TransactionCurrency,
      a.AssignmentReference                                 as Assignment,
      
      // Path changed here too, pointing to our new explicit 'je' join
      je.DocumentReferenceID                                as ReferenceDocument,
      
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      a.AmountInTransactionCurrency,
//      
////      dats_days_between(a.NetDueDate, $parameters.P_KeyDate)   as AgingDays,
////      dats_days_between(a.PostingDate, $parameters.P_KeyDate)  as AgingDaysPostingDate,
////      dats_days_between(a.DocumentDate, $parameters.P_KeyDate) as AgingDaysDocDate,
//      
////      cast( $parameters.P_KeyDate as abap.int4 ) 
// - cast( a.DocumentDate as abap.int4 ) as DaysOutstanding,
//      
////      cast( $parameters.P_KeyDate as abap.int4 ) 
// - cast( a.DocumentDate as abap.int4 ) as DaysOutstandingP,
// 
//case
//  when dats_days_between(
//           a.DocumentDate,
//           $parameters.P_KeyDate
//       ) <= cast( coalesce( pt.CashDiscount1Days, 0 ) as abap.int4 )
//  then 0
//
//  else
//       dats_days_between(
//           a.DocumentDate,
//           $parameters.P_KeyDate
//       )
//       -
//       cast( coalesce( pt.CashDiscount1Days, 0 ) as abap.int4 )
//
//end as DaysOutstandingPT,



@Semantics.amount.currencyCode: 'TransactionCurrency'
a.AmountInTransactionCurrency,

dats_days_between(
  a.NetDueDate,
  $session.system_date
) as AgingDays,

dats_days_between(
  a.PostingDate,
  $session.system_date
) as AgingDaysPostingDate,

dats_days_between(
  a.DocumentDate,
  $session.system_date
) as AgingDaysDocDate,

cast( $session.system_date as abap.int4 )
 - cast( a.DocumentDate as abap.int4 ) as DaysOutstanding,

cast( $session.system_date as abap.int4 )
 - cast( a.DocumentDate as abap.int4 ) as DaysOutstandingP,

case
  when dats_days_between(
           a.DocumentDate,
           $session.system_date
       ) <= cast( coalesce( pt.CashDiscount1Days, 0 ) as abap.int4 )
  then 0

  else
       dats_days_between(
           a.DocumentDate,
           $session.system_date
       )
       -
       cast( coalesce( pt.CashDiscount1Days, 0 ) as abap.int4 )

end as DaysOutstandingPT,




      a.ProfitCenter,
      a.Segment,
      a.BusinessArea,
      f.BusinessAreaName,
      b.PaymentTerms,
      b.DocumentItemText,
      
      sdh.BillingDocument,
      sdh.BillingDocumentType,
      sdh.PurchaseOrderByCustomer,
      
      sdi.SalesGroup,
      d.SalesGroupName,
      sdi.SalesOffice,
      e.SalesOfficeName,
      sdi.DistributionChannel,
      sdi.Product,
      sdi.ProductGroup,
      g.ProductGroupName,
      sdi.SalesDocument,
      sdi.BillingQuantityUnit,
      
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      sdi.BillingQuantity
}
//where
//       a.Ledger               =  '0L'
//  and  a.SourceLedger         =  '0L'
//  and  a.FinancialAccountType =  'D'
//  and  a.NetDueDate           is not null
//  and(
//       a.ClearingDate         > $parameters.P_KeyDate
//    or a.ClearingDate         =  '00000000'
//  )
//  and  a.PostingDate          <= $parameters.P_KeyDate
//  and  a.SpecialGLCode        <> 'F'


where
       a.Ledger               = '0L'
  and  a.SourceLedger         = '0L'
  and  a.FinancialAccountType = 'D'
  and  a.NetDueDate           is not null
  and (
         a.ClearingDate > $session.system_date
      or a.ClearingDate = '00000000'
      )
  and  a.PostingDate <= $session.system_date
  and  a.SpecialGLCode <> 'F'
