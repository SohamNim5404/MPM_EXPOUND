@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregated COGM Rates for Production'
@AbapCatalog.viewEnhancementCategory: [#NONE]
define view entity ZI_COGM_AGGR
  as select from ZCOGM
{
  key Plant,
  key Product,
  key Batch,
  key Orderid,

//     //      @DefaultAggregation: #MAX
      max(Cogm)             as Cogm,

     //      @DefaultAggregation: #MAX
      max(Scrap)            as Scrap,

     //      @DefaultAggregation: #MAX
      max(Rmcost)           as Rmcost,

     //      @DefaultAggregation: #MAX
      max(Overhead)         as Overhead,

     //      @DefaultAggregation: #MAX
      max(Fixedoverhead)    as Fixedoverhead,

     //      @DefaultAggregation: #MAX
      max(Labour)           as Labour,

     //      @DefaultAggregation: #MAX
      max(AuxPower)         as AuxPower,

     //      @DefaultAggregation: #MAX
      max(Power)            as Power,

     //      @DefaultAggregation: #MAX
      max(Variableoverhead) as Variableoverhead
}
group by
  Plant,
  Product,
  Batch,
  Orderid
