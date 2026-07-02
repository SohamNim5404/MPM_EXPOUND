
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregated COGM Rates for Production'
@AbapCatalog.viewEnhancementCategory: [#NONE]
define view entity ZI_MFG_AGGR
  as select distinct from I_MfgOrderConfirmation as a
  left outer join I_WorkCenterText as b
  on a.WorkCenterInternalID = b.WorkCenterInternalID
{
key a.ManufacturingOrder,
a.OpConfirmedWorkQuantity5,
a.OpWorkQuantityUnit5,
b.WorkCenterInternalID,
b.WorkCenterText
}
where a.ManufacturingOrder is not initial 
and a.IsReversal is initial
and a.IsReversed is initial
group by
a.ManufacturingOrder,
a.OpConfirmedWorkQuantity5,
a.OpWorkQuantityUnit5,
b.WorkCenterInternalID,
b.WorkCenterText
