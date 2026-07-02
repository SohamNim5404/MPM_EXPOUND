@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for budget item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BUDGET_ITEM 
  as select from zdb_budget_item
  association to parent ZI_BUDGET_HDR as _XLUser on  $projection.EndUser = _XLUser.EndUser
                                                 and $projection.FileId  = _XLUser.FileId
{
    key end_user               as EndUser,
    key file_id                as FileId,
    key line_id                as LineId,
    key line_no                as Line_No,
    
    unique_id                  as UniqueId,
    cust_cat                   as CustCat,
    sales_office_code          as SalesOfficeCode,
    sales_office_loc           as SalesOfficeLoc,
    
    // THE VIEW CAN NOW SEE THESE FIELDS!
    sales_group                as SalesGroup,
    sales_group_text           as SalesGroupText,
    
    cust_code                  as CustCode,
    cust_name                  as CustName,
    prod_code                  as ProdCode,
    prod_name                  as ProdName,
    month_in_text              as MonthInText,
    month_in_no                as MonthInNo,
    projected_unit_price       as ProjectedUnitPrice,
    projection_in_qty          as ProjectionInQty,
    projection_in_value        as ProjectionInValue,
    potential                  as Potential,
    sales_person               as SalesPerson,
    segment                    as Segment,
    product_family             as ProductFamily,
    
    created_by                 as CreatedBy,
    created_at                 as CreatedAt,
    
    @Semantics.user.lastChangedBy: true
    last_changed_by            as LastChangedBy,
    
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at            as LastChangedAt,
    
    _XLUser
}
