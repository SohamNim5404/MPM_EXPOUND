@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interffaace for collection Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_COLL_REP
  as select from    I_JournalEntryItem  as a
//   LEFT OUTER JOIN I_AccountingDocumentJournal AS ACC ON  ACC.AccountingDocument = a.AccountingDocument
//                                                  and ACC.CompanyCode    = a.CompanyCode
//                                                  and ACC.FiscalYear     = a.FiscalYear
//                                                  and ACC.    = $session.system_language

    left outer join I_CustomerSalesArea as b      on  a.Customer              = b.Customer
                                                  and a.CompanyCode           = b.SalesOrganization
                                                  and (
                                                     b.DistributionChannel    = '10'
                                                     or b.DistributionChannel = '30'
                                                   )
                                                  and b.Division              = '11'
    left outer join I_Customer          as c      on c.Customer = a.Customer
    left outer join I_SalesOfficeText   as d      on  d.SalesOffice = b.SalesOffice
                                                  and d.Language    = $session.system_language
    left outer join ZI_CHQ_POST         as chq    on  chq.PostedDocument = a.AccountingDocument
                                                  and chq.CompanyCode    = a.CompanyCode
                                                  and chq.PostedYear     = a.FiscalYear
    left outer join I_CalendarDate      as cal    on cal.CalendarDate = a.PostingDate
    left outer join I_CalendarMonthText as calmon on  calmon.CalendarMonth = cal.CalendarMonth
                                                  and calmon.Language      = 'E'

    left outer join ZI_CustSalesAggr    as tds    on  a.CompanyCode        = tds.CompanyCode
                                                  and a.AccountingDocument = tds.AccountingDocument
                                                  and a.FiscalYear         = tds.FiscalYear

{

      @UI.facet                    : [{ id : 'AccountingDocument',
                          purpose            : #STANDARD,
                          type               : #IDENTIFICATION_REFERENCE,
                          label              : 'CompanyCode',
                          position           : 10 }]

      @UI.selectionField           : [{position: 10 }]
      @UI.lineItem                 : [{ position: 10 , label: 'Company Code'}]
      @UI.identification           : [{  position: 10, label: 'Company Code' }]
  key a.CompanyCode,


      @UI.lineItem                 : [{ position: 20 , label: 'Journal Entry  '}]
      @UI.identification           : [{  position: 20, label: 'Journal Entry  ' }]
  key a.AccountingDocument,


      @UI.lineItem                 : [{ position: 30 , label: 'Journal Entry Line item  '}]
      @UI.identification           : [{  position: 30, label: 'Journal Entry Line item  ' }]
  key a.LedgerGLLineItem,

      @UI.lineItem                 : [{ position: 40 , label: 'Journal Entry Type '}]
      @UI.identification           : [{  position: 40, label: 'Journal Entry Type ' }]
      a.AccountingDocumentType,

      @UI.selectionField           : [{position: 20 }]
      @UI.lineItem                 : [{ position: 50 , label: 'Customer  '}]
      @UI.identification           : [{  position: 50, label: 'Customer  ' }]
      a.Customer,

      @UI.lineItem                 : [{ position: 60 , label: 'Fiscal Year '}]
      @UI.identification           : [{  position: 60, label: 'Fiscal Year ' }]
      a.FiscalYear,

      a.FiscalPeriod,
      cal.CalendarYear,
      cal.CalendarMonth,
      calmon.CalendarMonthName,

      @UI.lineItem                 : [{ position: 70 , label: 'GL Account '}]
      @UI.identification           : [{  position: 70, label: 'GL Account ' }]
      a.GLAccount,

      @UI.selectionField           : [{position: 30 }]
      @UI.lineItem                 : [{ position: 80 , label: 'Posting Date '}]
      @UI.identification           : [{  position: 80, label: 'Posting Date ' }]
      a.PostingDate,

      @UI.lineItem                 : [{ position: 90 , label: 'Profit Center '}]
      @UI.identification           : [{  position: 90, label: 'Profit Center ' }]
      a.ProfitCenter,

      @UI.lineItem                 : [{ position: 100 , label: 'Reference Document'}]
      @UI.identification           : [{  position: 100, label: 'Reference Document' }]
      a.ReferenceDocument,

      @UI.lineItem                 : [{ position: 110 , label: 'Debit Amount in Company Code Currency '}]
      @UI.identification           : [{  position: 110, label: 'Debit Amount in Company Code Currency ' }]
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      a.DebitAmountInCoCodeCrcy,

      @UI.lineItem                 : [{ position: 120 , label: 'Credit Amount in Company Code Currency '}]
      @UI.identification           : [{  position: 120, label: 'Credit Amount in Company Code Currency ' }]
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      a.CreditAmountInCoCodeCrcy,

      @UI.lineItem                 : [{ position: 130 , label: 'Purchasing Document Number'}]
      @UI.identification           : [{  position: 130, label: 'Purchasing Document Number' }]
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      a.AmountInCompanyCodeCurrency,

      @UI.hidden: true
      a.CompanyCodeCurrency,


      @UI.lineItem                 : [{ position: 150 , label: 'Payment Terms '}]
      @UI.identification           : [{  position: 150, label: 'Payment Terms ' }]
      b.PaymentTerms,

      @UI.selectionField           : [{position: 40 }]
      @UI.lineItem                 : [{ position: 160 , label: 'Sales Office  '}]
      @UI.identification           : [{  position: 160, label: 'Sales Office  ' }]
      b.SalesOffice,

      @UI.selectionField           : [{position: 45 }]
      @UI.lineItem                 : [{ position: 165 , label: 'Sales Office Name  '}]
      @UI.identification           : [{  position: 165, label: 'Sales Office Name ' }]
      d.SalesOfficeName,

      @UI.lineItem                 : [{ position: 170 , label: 'Sales Group '}]
      @UI.identification           : [{  position: 170, label: 'Sales Group ' }]
      b.SalesGroup,

      @UI.selectionField           : [{position: 50 }]
      @UI.lineItem                 : [{ position: 180 , label: 'Customer Name '}]
      @UI.identification           : [{  position: 180, label: 'Customer Name ' }]
      c.CustomerName,

      /* MEASURES */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @Aggregation.default: #SUM
      @EndUserText.label: 'Total Credit Amount'
      //      Journal.CreditAmountInCoCodeCrcy,
      a.CreditAmountInCoCodeCrcy * -1                                          as TotalCreditAmountInv,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @Aggregation.default: #SUM
      @EndUserText.label: 'Total Debit Amount'
      //      Journal.DebitAmountInCoCodeCrcy,
      a.DebitAmountInCoCodeCrcy * -1                                           as TotalDeditAmountInv,

      /* 3. Total of the two Inverted fields */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @Aggregation.default: #SUM
      @EndUserText.label: 'Total Received Amount'
      ( a.CreditAmountInCoCodeCrcy * -1 ) + ( a.DebitAmountInCoCodeCrcy * -1 ) as TotalReceiptAmount,

      /* 3. Total of the two Inverted fields */
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @Aggregation.default: #SUM
      @EndUserText.label: 'Total TDS Amount'
      tds.TDSAMT                                                               as TDSAMT,

      /* ATTRIBUTES */

      a.DocumentDate,
      a.ClearingAccountingDocument,

      /* ASSOCIATIONS */
      a._Customer,
      a._CompanyCode
}
where
       a.FinancialAccountType   =  'D'
  and(
       a.AccountingDocumentType =  'DZ'
    or a.AccountingDocumentType =  'AB'
  )
  and  a.Ledger                 =  '0L'
  and  c.CustomerAccountGroup   <> 'ZSTO'
