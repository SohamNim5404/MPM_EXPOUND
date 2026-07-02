@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption'
@Metadata.ignorePropagatedAnnotations: true
define  view entity ZC_BUDGET_PBI as select from ZI_BUDGET_PBI
{
    key actual_cust_code,
    key prod_code,
    key month_in_no,
    key sales_office_code,
    key sales_group,
    end_user,
    file_id,
    line_id,
    line_no,
    unique_id,
    temp_cust_code,
    temp_cust_name,
    month_in_text,
    fiscal_year,
    fiscal_month,
    potential,
    segment,
    customer_category,
    sales_org,
    sales_office_loc,
    sales_group_text,
    sales_person,
    prod_name,
    BillingQuantityUnit,
    TransactionCurrency,
    projected_unit_price,
    projection_in_qty,
    projection_in_value,
    actual_qty,
    actual_value,
    schedule_qty,
    variance_qty,
    variance_value
}
