@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Aging Base'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_AGEING_CAL as select from I_MaterialDocumentItem_2 
{
    key Material,
    key Batch,
    FiscalYearVariant,
     PostingDate,
    cast(
  dats_days_between(
    PostingDate,
    $session.system_date
  )
  as abap.int4
) as Age
}
