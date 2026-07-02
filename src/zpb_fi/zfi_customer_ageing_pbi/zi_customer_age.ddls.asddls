@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YFI01 Customer Aging : PBI'
@AbapCatalog.viewEnhancementCategory: [#NONE]

//define root view entity ZI_CUSTOMER_AGE

define view entity ZI_CUSTOMER_AGE
  as select from ZI_CUSTOMER_AGE02
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key Customer,

      CustomerName,
      CustomerCountry,
      CustomerRegion,
      City,
      CustomerGroup,
      Vendor,
      DebitCreditCode,
      AccountingDocumentType,
      PostingDate,
      DocumentDate,
      ClearingDate,
      NetDueDate,
      BaselineDate,
      GLAccount,
      SpecialGLCode,
      SpecialGLCodeName,
      CompanyCodeCurrency,
      TransactionCurrency,
      Assignment,
      ReferenceDocument,
      ProfitCenter,
      Segment,
      BusinessArea,
      BusinessAreaName,
      PaymentTerms,
      DocumentItemText,
      SalesGroup,
      SalesGroupName,
      SalesOffice,
      SalesOfficeName,
      Product,
      ProductGroup,
      ProductGroupName,
      BillingDocument,
      BillingDocumentType,
      SalesDocument,
      DistributionChannel,
      PurchaseOrderByCustomer,
      BillingQuantityUnit,

      cast( $session.system_date as abap.int4 )
    - cast( DocumentDate as abap.int4 ) as DaysOutstanding,

      DaysOutstandingPT,

      AgingDays,
      AgingDaysPostingDate,
      AgingDaysDocDate,
      OverdueMonthDays,
      OwnExplanation,

      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency as GrossOutstanding,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency as AmountInFC,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( NotDueAmount as abap.curr(23,2) ) as NotDueAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( NetOverdueAmount as abap.curr(23,2) ) as NetOverdueAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( UnadjustedAmount as abap.curr(23,2) ) as UnadjustedAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( AdvanceAmount as abap.curr(23,2) ) as AdvanceAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( PDCReceivedAmount as abap.curr(23,2) ) as PDCReceivedAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( InterestAmount as abap.curr(23,2) ) as InterestAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( MonthInterestAmount as abap.curr(23,2) ) as MonthInterestAmount,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( Interval1 as abap.curr(23,2) ) as Interval1,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( Interval2 as abap.curr(23,2) ) as Interval2,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( Interval3 as abap.curr(23,2) ) as Interval3,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( Interval4 as abap.curr(23,2) ) as Interval4,

      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( Interval5 as abap.curr(23,2) ) as Interval5

//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      @DefaultAggregation: #SUM
//      cast( PTInterval1 as abap.curr(23,2) ) as PTInterval1,
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      @DefaultAggregation: #SUM
//      cast( PTInterval2 as abap.curr(23,2) ) as PTInterval2,
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      @DefaultAggregation: #SUM
//      cast( PTInterval3 as abap.curr(23,2) ) as PTInterval3,
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      @DefaultAggregation: #SUM
//      cast( PTInterval4 as abap.curr(23,2) ) as PTInterval4,
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      @DefaultAggregation: #SUM
//      cast( PTInterval5 as abap.curr(23,2) ) as PTInterval5
}
