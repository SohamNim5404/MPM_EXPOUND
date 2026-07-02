@EndUserText.label: 'Projection view for budget item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_BUDGET_ITEM 
  as projection on ZI_BUDGET_ITEM
{
    key EndUser,
    key FileId,
    key LineId,
    key Line_No,
    
    UniqueId,
    CustCat,
    SalesOfficeCode,
    SalesOfficeLoc,
    
    // ==========================================
    // THE FIX: You MUST project the new fields!
    // ==========================================
    SalesGroup,
    SalesGroupText,
    
    CustCode,
    CustName,
    ProdCode,
    ProdName,
    MonthInText,
    MonthInNo,
    ProjectedUnitPrice,
    ProjectionInQty,
    ProjectionInValue,
    Potential,
    SalesPerson,
    Segment,
    ProductFamily,
    
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    /* Associations */
    _XLUser : redirected to parent ZC_BUDGET_HDR
}
