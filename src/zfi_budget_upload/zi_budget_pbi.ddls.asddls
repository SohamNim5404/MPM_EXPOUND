@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Budget vs Actual vs Schedule'
@Metadata.allowExtensions: true
define view entity ZI_BUDGET_PBI
  as select from ZI_BvA_Keys
  
    left outer join ZI_Budget_Mapped as Budget 
      on  ZI_BvA_Keys.sales_office_code = Budget.sales_office_code
      and ZI_BvA_Keys.sales_group_code  = Budget.sales_group
      and ZI_BvA_Keys.cust_code         = Budget.actual_cust_code
      and ZI_BvA_Keys.prod_code         = Budget.prod_code
      and ZI_BvA_Keys.month_in_no       = Budget.month_in_no

    left outer join ZI_ActualSales_Agg as Actual 
      on  ZI_BvA_Keys.sales_office_code = Actual.sales_office_code
      and ZI_BvA_Keys.sales_group_code  = Actual.sales_group_code
      and ZI_BvA_Keys.cust_code         = Actual.cust_code
      and ZI_BvA_Keys.prod_code         = Actual.prod_code
      and ZI_BvA_Keys.month_in_no       = Actual.month_in_no
      
    left outer join ZI_Schedule_Agg as Sched   
      on  ZI_BvA_Keys.cust_code         = Sched.cust_code
      and ZI_BvA_Keys.prod_code         = Sched.prod_code
      and ZI_BvA_Keys.month_in_no       = Sched.month_in_no
      
    left outer join zextwg_text as ExtProdTxt
      on  ZI_BvA_Keys.prod_code   = ExtProdTxt.extwg
      and ExtProdTxt.language = $session.system_language
{
  key ZI_BvA_Keys.cust_code as actual_cust_code,
  key ZI_BvA_Keys.prod_code,
  key ZI_BvA_Keys.month_in_no,
  key ZI_BvA_Keys.sales_office_code,
  key ZI_BvA_Keys.sales_group_code as sales_group,
  
  Budget.end_user,
  Budget.file_id,
  Budget.line_id,
  Budget.line_no,
  
  Budget.unique_id,
  Budget.temp_cust_code,
  
  coalesce( Budget.temp_cust_name, cast( Actual.customer_name as abap.char(80) ) ) as temp_cust_name,
  
  Budget.month_in_text,
  
  // ==========================================
  // NEW: Exposing Fiscal Year & Month
  // ==========================================
  Actual.fiscal_year,
  coalesce( Budget.fiscal_month, Actual.fiscal_month ) as fiscal_month,
  
  Budget.potential,
  Budget.segment,

  case 
    when Budget.actual_cust_code is null and Actual.cust_code is not null then cast('Actual' as abap.char(30))
    else Budget.customer_category
  end as customer_category,
  
  Actual.sales_org as sales_org,
  
  coalesce( Budget.sales_office_loc, Actual.sales_office_text ) as sales_office_loc,
  coalesce( Budget.sales_group_text, Actual.sales_group_text )  as sales_group_text,
  coalesce( Budget.sales_person, Actual.employee_name )         as sales_person,
  
  cast( ExtProdTxt.ewbez as abap.char(50) ) as prod_name,
  
  Actual.BillingQuantityUnit,   
  Actual.TransactionCurrency,
  
  cast( coalesce( Budget.projected_unit_price, cast( 0 as abap.dec(15,2) ) ) as abap.dec(15,2) ) as projected_unit_price,
  cast( coalesce( Budget.projection_in_qty, cast( 0 as abap.dec(13,3) ) )    as abap.dec(13,3) ) as projection_in_qty,
  cast( coalesce( Budget.projection_in_value, cast( 0 as abap.dec(15,2) ) )  as abap.dec(15,2) ) as projection_in_value,
  
  cast( coalesce( Actual.actual_qty, cast( 0 as abap.dec(13,3) ) )           as abap.dec(13,3) ) as actual_qty,
  cast( coalesce( Actual.actual_value, cast( 0 as abap.dec(15,2) ) )         as abap.dec(15,2) ) as actual_value,
  cast( coalesce( Sched.schedule_qty, cast( 0 as abap.dec(13,3) ) )          as abap.dec(13,3) ) as schedule_qty,
  
  cast( coalesce( Budget.projection_in_qty, 0 ) as abap.dec(15,3) ) - cast( coalesce( Actual.actual_qty, 0 ) as abap.dec(15,3) ) as variance_qty,
  cast( coalesce( Budget.projection_in_value, 0 ) as abap.dec(15,2) ) - cast( coalesce( Actual.actual_value, 0 ) as abap.dec(15,2) ) as variance_value
}
