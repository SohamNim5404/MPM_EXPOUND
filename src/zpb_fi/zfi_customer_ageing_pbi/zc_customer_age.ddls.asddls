@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YFI01 Customer Aging : PBI'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
//@ObjectModel.supportedCapabilities: [ #ANALYTICAL_QUERY ]
//@Analytics.query: true

define root view entity ZC_CUSTOMER_AGE
//  with parameters
//    @EndUserText.label: 'Aging Key Date'
//    P_KeyDate         : abap.dats,
//    
//    @EndUserText.label: 'Interval 1 (Days)'
//    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '30' }
//    P_Interval1InDays : abap.int4,
//    
//    @EndUserText.label: 'Interval 2 (Days)'
//    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '60' }
//    P_Interval2InDays : abap.int4,
//    
//    @EndUserText.label: 'Interval 3 (Days)'
//    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '90' }
//    P_Interval3InDays : abap.int4,
//    
//    @EndUserText.label: 'Interval 4 (Days)'
//    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '180' }
//    P_Interval4InDays : abap.int4,
//    
//    @EndUserText.label: 'Interval 5 (Days)'
//    @AnalyticsDetails.variable: { usageType: #PARAMETER, defaultValue: '9999' }
//    P_Interval5InDays : abap.int4


  as select from ZI_CUSTOMER_AGE
//  ( 
//                 P_KeyDate          : $parameters.P_KeyDate,
//                 P_Interval1InDays  : $parameters.P_Interval1InDays,
//                 P_Interval2InDays  : $parameters.P_Interval2InDays,
//                 P_Interval3InDays  : $parameters.P_Interval3InDays,
//                 P_Interval4InDays  : $parameters.P_Interval4InDays,
//                 P_Interval5InDays  : $parameters.P_Interval5InDays )
{
      @Consumption.filter :{ selectionType: #INTERVAL, multipleSelections: true, mandatory: false }
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  
      @Consumption.filter : {selectionType : #INTERVAL, multipleSelections: true, mandatory: false}
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_Customer' , element: 'Customer' }}]
  key Customer,
  
      @EndUserText.label: 'Name'
      CustomerName,
      CustomerCountry,
      @EndUserText.label: 'Region'
      CustomerRegion,
      @EndUserText.label: 'City'
      City,
      @EndUserText.label: 'Customer group'
      CustomerGroup,
//      @EndUserText.label: 'Vendor'
//          Vendor,
      @EndUserText.label: 'Debit/Credit Ind.'
      DebitCreditCode,
      
      @EndUserText.label: 'Document Type'
      AccountingDocumentType,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Document Date'
      DocumentDate,
      ClearingDate,
      @EndUserText.label: 'Net Due Date'
      NetDueDate,
      @EndUserText.label: 'Baseline Date'
      BaselineDate,
      GLAccount,
//      @EndUserText.label: 'Special G/L ind.'
//      SpecialGLCode,
//      SpecialGLCodeName,
      @EndUserText.label: 'General ledger currency'
      CompanyCodeCurrency,
      @EndUserText.label: 'Currency'
      TransactionCurrency,
      Assignment,
      DaysOutstanding,
      DaysOutstandingPT,
      
      @EndUserText.label: 'Customer Reference (FI)'
      ReferenceDocument,
      
      @EndUserText.label: 'Profit Center'
      @Consumption.filter :{ selectionType: #SINGLE, multipleSelections: true, mandatory: false }
      ProfitCenter,
      Segment,
//      @EndUserText.label: 'Business Area'
//      BusinessArea,
//      @EndUserText.label: 'Business area description'
//      BusinessAreaName,
      @EndUserText.label: 'Terms of Payment'
      PaymentTerms,
      @EndUserText.label: 'Text'
      DocumentItemText,
      
      @EndUserText.label: 'Sales Group'
      SalesGroup,
      SalesGroupName,
      
      @EndUserText.label: 'Sales Office'
      @Consumption.filter :{ selectionType: #SINGLE, multipleSelections: true, mandatory: false }
      SalesOffice,
      @EndUserText.label: 'Sales Office Name'
      SalesOfficeName,
      
      @EndUserText.label: 'Material'
      Product,
      @EndUserText.label: 'Material Group'
      ProductGroup,
      @EndUserText.label: 'Material Group Desc.'
      ProductGroupName,
      
      @EndUserText.label: 'Billing Document'
      BillingDocument,
      
      @EndUserText.label: 'Billing Type'
      BillingDocumentType,
      @EndUserText.label: 'Sales document'
      SalesDocument,
      DistributionChannel,
      
      @EndUserText.label: 'Customer Purchase Order'
      PurchaseOrderByCustomer,
      
//      @EndUserText.label: 'Own explanation'
//      OwnExplanation,
      
      BillingQuantityUnit,
      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      
      @EndUserText.label: 'Overdue Days.'
      AgingDays,
      @EndUserText.label: 'Overdue Month Days.'
      OverdueMonthDays,
      @EndUserText.label: 'Overdue Days (Posting Date)'
      AgingDaysPostingDate,
      @EndUserText.label: 'Overdue Days (Document Date)'
      AgingDaysDocDate,

      @EndUserText.label: 'Gross Outstanding'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      GrossOutstanding,

      @EndUserText.label: 'Amount in FC'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      @DefaultAggregation: #SUM
      AmountInFC,

      @EndUserText.label: 'Not Due Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      NotDueAmount,
      
      @EndUserText.label: 'Net Overdue Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      NetOverdueAmount,
      
      @EndUserText.label: 'Unadjusted Amount'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      UnadjustedAmount,
      
      @EndUserText.label: 'Advance'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      AdvanceAmount,
      

//      @Consumption.dynamicLabel:{ label: '0 -&1 Days-Outstanding', binding: [{ index: 1, parameter: 'P_Interval1InDays' }]}
      @EndUserText.label: '0-30 Days Outstanding'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval1,

//      @Consumption.dynamicLabel:{ label: '&1 -&2 Days Ostd.-Outstanding', binding: [
//          { index: 1, parameter: 'P_Interval1InDays'},
//          { index: 2, parameter: 'P_Interval2InDays' } ]}
@EndUserText.label: '31-60 Days Outstanding'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval2,

//      @Consumption.dynamicLabel:{ label: '&1 -&2 Days Ostd.-Outstanding', binding: [
//          { index: 1, parameter: 'P_Interval2InDays'},
//          { index: 2, parameter: 'P_Interval3InDays' } ]}
@EndUserText.label: '61-90 Days Outstanding'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval3,

//      @Consumption.dynamicLabel:{ label: '&1 -&2 Days Ostd.-Outstanding', binding: [
//          { index: 1, parameter: 'P_Interval3InDays'},
//          { index: 2, parameter: 'P_Interval4InDays' } ]}
@EndUserText.label: '91-180 Days Outstanding'

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval4,

//      @Consumption.dynamicLabel:{ label: '&1 -&2 Days Ostd.-Outstanding', binding: [
//          { index: 1, parameter: 'P_Interval4InDays'},
//          { index: 2, parameter: 'P_Interval5InDays' } ]}
@EndUserText.label: '180+ Days Outstanding'
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      Interval5
      
//      
////               @Consumption.dynamicLabel:{
////        label: 'PT 0 - &1 Days',
////        binding: [{ index: 1, parameter: 'P_Interval1InDays' }]
////      }
//@EndUserText.label: 'PT 0-30 Days'
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//            @DefaultAggregation: #SUM
//      PTInterval1,
//
//
////      @Consumption.dynamicLabel:{
////        label: 'PT &1 - &2 Days',
////        binding: [
////          { index: 1, parameter: 'P_Interval1InDays' },
////          { index: 2, parameter: 'P_Interval2InDays' }
////        ]
////      }
//@EndUserText.label: 'PT 31-60 Days'
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//            @DefaultAggregation: #SUM
//      PTInterval2,
//
//
////      @Consumption.dynamicLabel:{
////        label: 'PT &1 - &2 Days',
////        binding: [
////          { index: 1, parameter: 'P_Interval2InDays' },
////          { index: 2, parameter: 'P_Interval3InDays' }
////        ]
////      }
//@EndUserText.label: 'PT 61-90 Days'
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//            @DefaultAggregation: #SUM
//      PTInterval3,
//
//
////      @Consumption.dynamicLabel:{
////        label: 'PT &1 - &2 Days',
////        binding: [
////          { index: 1, parameter: 'P_Interval3InDays' },
////          { index: 2, parameter: 'P_Interval4InDays' }
////        ]
////      }
//@EndUserText.label: 'PT 91-180 Days'
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//            @DefaultAggregation: #SUM
//      PTInterval4,
//
//
////      @Consumption.dynamicLabel:{
////        label: 'PT &1 - &2 Days',
////        binding: [
////          { index: 1, parameter: 'P_Interval4InDays' },
////          { index: 2, parameter: 'P_Interval5InDays' }
////        ]
////      }
//@EndUserText.label: 'PT 180+ Days'
//
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//            @DefaultAggregation: #SUM
//      PTInterval5
}
