@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Description'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_PRODUCTION_N
  as select from I_MaterialDocumentItem_2 as MD

    left outer join I_MaterialDocumentItem_2 as REV
      on REV.ReversedMaterialDocument = MD.MaterialDocument

{
  key MD.MaterialDocument,
  key MD.MaterialDocumentItem,
      MD.ReversedMaterialDocument
}
where
      MD.ReversedMaterialDocument = ''
  and REV.MaterialDocument is null;
