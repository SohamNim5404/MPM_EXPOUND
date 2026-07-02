@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'YFI01 Customer Aging : Interval Logic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTOMER_AGE02
//  with parameters
//    P_KeyDate         : abap.dats,
//   P_Interval1InDays : abap.int4,
//P_Interval2InDays : abap.int4,
//P_Interval3InDays : abap.int4,
//P_Interval4InDays : abap.int4,
//P_Interval5InDays : abap.int4
  as select from ZI_CUSTOMER_AGE01
//  ( P_KeyDate : $session.system_date )
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
      DaysOutstanding,
      DaysOutstandingP,
      DaysOutstandingPT,
      
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,

      // FIXED: Now shifting ALL calculations to use AgingDaysDocDate (Document Date)
//      case when AgingDaysDocDate < 0
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as NotDueAmount,
//
//      case when AgingDaysDocDate >= 0
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as NetOverdueAmount,
//      
//      case when AccountingDocumentType = 'DZ' or AccountingDocumentType = 'DA' or AccountingDocumentType = 'AB'
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0 
//      end as UnadjustedAmount,
//
//      case when SpecialGLCode = 'A'
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0 
//      end as AdvanceAmount,
//      
//      case when SpecialGLCode = 'W'
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0 
//      end as PDCReceivedAmount,
//
//      cast( 0 as abap.dec( 23, 2 ) ) as InterestAmount,
//      cast( 0 as abap.dec( 23, 2 ) ) as MonthInterestAmount,
//      
//      // FIXED: Overdue Months now based on Document Date
//      case when AgingDaysDocDate > 0 
//           then cast( AgingDaysDocDate / 30 as abap.int4 )
//           else cast( 0 as abap.int4 ) 
//      end as OverdueMonthDays,
//      
//      cast( ' ' as abap.char( 50 ) ) as OwnExplanation,
//
//      // FIXED: All 5 Intervals now use AgingDaysDocDate
//      case when AgingDaysDocDate >= 0 and AgingDaysDocDate <= cast( $parameters.P_Interval1InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as Interval1,
//      
//      case when AgingDaysDocDate > cast( $parameters.P_Interval1InDays as abap.int4 )
//            and AgingDaysDocDate <= cast( $parameters.P_Interval2InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as Interval2,
//      
//      case when AgingDaysDocDate > cast( $parameters.P_Interval2InDays as abap.int4 )
//            and AgingDaysDocDate <= cast( $parameters.P_Interval3InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as Interval3,
//      
//      case when AgingDaysDocDate > cast( $parameters.P_Interval3InDays as abap.int4 )
//            and AgingDaysDocDate <= cast( $parameters.P_Interval4InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as Interval4,
//
//      case when AgingDaysDocDate > cast( $parameters.P_Interval4InDays as abap.int4 )
//            and AgingDaysDocDate <= cast( $parameters.P_Interval5InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else 0
//      end as Interval5,
//      
//            /* PT INTERVAL 1 */
//      case when DaysOutstandingPT >= 0
//             and DaysOutstandingPT <= cast( $parameters.P_Interval1InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else cast( 0 as abap.dec( 23, 2 ) )
//      end as PTInterval1,
//
//
//      /* PT INTERVAL 2 */
//      case when DaysOutstandingPT > cast( $parameters.P_Interval1InDays as abap.int4 )
//             and DaysOutstandingPT <= cast( $parameters.P_Interval2InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else cast( 0 as abap.dec( 23, 2 ) )
//      end as PTInterval2,
//
//
//      /* PT INTERVAL 3 */
//      case when DaysOutstandingPT > cast( $parameters.P_Interval2InDays as abap.int4 )
//             and DaysOutstandingPT <= cast( $parameters.P_Interval3InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else cast( 0 as abap.dec( 23, 2 ) )
//      end as PTInterval3,
//
//
//      /* PT INTERVAL 4 */
//      case when DaysOutstandingPT > cast( $parameters.P_Interval3InDays as abap.int4 )
//             and DaysOutstandingPT <= cast( $parameters.P_Interval4InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else cast( 0 as abap.dec( 23, 2 ) )
//      end as PTInterval4,
//
//
//      /* PT INTERVAL 5 */
//      case when DaysOutstandingPT > cast( $parameters.P_Interval4InDays as abap.int4 )
//             and DaysOutstandingPT <= cast( $parameters.P_Interval5InDays as abap.int4 )
//           then cast( AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )
//           else cast( 0 as abap.dec( 23, 2 ) )
//      end as PTInterval5,
//      




case when AgingDaysDocDate < 0
     then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
     else cast( 0 as abap.dec(23,2) )
end as NotDueAmount,

case when AgingDaysDocDate >= 0
     then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
     else cast( 0 as abap.dec(23,2) )
end as NetOverdueAmount,

case when AccountingDocumentType = 'DZ'
       or AccountingDocumentType = 'DA'
       or AccountingDocumentType = 'AB'
     then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
     else cast( 0 as abap.dec(23,2) )
end as UnadjustedAmount,

case when SpecialGLCode = 'A'
     then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
     else cast( 0 as abap.dec(23,2) )
end as AdvanceAmount,

case when SpecialGLCode = 'W'
     then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
     else cast( 0 as abap.dec(23,2) )
end as PDCReceivedAmount,

cast( 0 as abap.dec(23,2) ) as InterestAmount,

cast( 0 as abap.dec(23,2) ) as MonthInterestAmount,

case when AgingDaysDocDate > 0
     then cast( AgingDaysDocDate / 30 as abap.int4 )
     else cast( 0 as abap.int4 )
end as OverdueMonthDays,

cast( ' ' as abap.char(50) ) as OwnExplanation,

      /* Interval 1 : 0 - 30 Days */
      case when AgingDaysDocDate >= 0
             and AgingDaysDocDate <= 30
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as Interval1,

      /* Interval 2 : 31 - 60 Days */
      case when AgingDaysDocDate > 30
             and AgingDaysDocDate <= 60
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as Interval2,

      /* Interval 3 : 61 - 90 Days */
      case when AgingDaysDocDate > 60
             and AgingDaysDocDate <= 90
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as Interval3,

      /* Interval 4 : 91 - 180 Days */
      case when AgingDaysDocDate > 90
             and AgingDaysDocDate <= 180
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as Interval4,

      /* Interval 5 : Above 180 Days */
      case when AgingDaysDocDate > 180
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as Interval5,

      /* PT INTERVAL 1 : 0 - 30 */
      case when DaysOutstandingPT >= 0
             and DaysOutstandingPT <= 30
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as PTInterval1,

      /* PT INTERVAL 2 : 31 - 60 */
      case when DaysOutstandingPT > 30
             and DaysOutstandingPT <= 60
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as PTInterval2,

      /* PT INTERVAL 3 : 61 - 90 */
      case when DaysOutstandingPT > 60
             and DaysOutstandingPT <= 90
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as PTInterval3,

      /* PT INTERVAL 4 : 91 - 180 */
      case when DaysOutstandingPT > 90
             and DaysOutstandingPT <= 180
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as PTInterval4,

      /* PT INTERVAL 5 : Above 180 */
      case when DaysOutstandingPT > 180
           then cast( AmountInCompanyCodeCurrency as abap.dec(23,2) )
           else cast( 0 as abap.dec(23,2) )
      end as PTInterval5,

      AgingDays,
      AgingDaysPostingDate,
      AgingDaysDocDate
}
