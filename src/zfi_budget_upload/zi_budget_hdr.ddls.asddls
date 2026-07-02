@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for budget header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BUDGET_HDR as select from zdb_budget_hdr
composition [0..*] of ZI_BUDGET_ITEM as _XLData
{
        key end_user as EndUser,
    key file_id as FileId,
    file_status as FileStatus,
    attachment as Attachment,
    mimetype as Mimetype,
    filename as Filename,
//    stylename as Stylename,
         @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,

      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,

      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      // Local ETag field → OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
//    _association_name // Make association public
_XLData
}
