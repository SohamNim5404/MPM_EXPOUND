@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pricing Conditions Aggregation'
define view entity ZI_GPR
  as select from I_BillingDocumentItemPrcgElmnt as Prcg
  join I_BillingDocument as Bill on Prcg.BillingDocument = Bill.BillingDocument
{
  key Prcg.BillingDocument,
  key Prcg.BillingDocumentItem,
  
  max( case when Prcg.ConditionType = 'ZB00' or Prcg.ConditionType = 'ZFOB' or Prcg.ConditionType = 'ZPRO' 
            then cast( currency_conversion( 
                         amount             => Prcg.ConditionAmount, 
                         source_currency    => Prcg.ConditionCurrency, 
                         target_currency    => cast('INR' as abap.cuky), 
                         exchange_rate_date => Bill.BillingDocumentDate, 
                         error_handling     => 'SET_TO_NULL' ) as abap.dec(15,2) ) 
            else cast( 0 as abap.dec(15,2) ) end ) as ConvertedTotalAmount

}
where Prcg.ConditionInactiveReason is initial
group by 
  Prcg.BillingDocument, 
  Prcg.BillingDocumentItem
