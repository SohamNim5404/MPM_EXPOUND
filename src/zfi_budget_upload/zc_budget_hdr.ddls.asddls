@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for budget header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_BUDGET_HDR as projection on ZI_BUDGET_HDR
{
    key EndUser,
    key FileId,
       FileStatus,
     @Semantics.largeObject: {
        mimeType: 'Mimetype', 
        fileName: 'Filename',

        acceptableMimeTypes: [
          'application/vnd.ms-excel',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        ],
        contentDispositionPreference: #INLINE
      }
    Attachment,
     @Semantics.mimeType: true
    Mimetype,
    Filename,
//    Stylename,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _XLData : redirected to composition child ZC_BUDGET_ITEM
}
