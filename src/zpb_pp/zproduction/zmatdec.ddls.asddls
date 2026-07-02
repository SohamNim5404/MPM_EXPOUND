@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Description'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zmatdec
  as select from I_ProductDescription
{
  key Product,
  ProductDescription
}
