CLASS lhc_xlhead DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR xlhead RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR xlhead RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE xlhead.

    METHODS uploadexceldata FOR MODIFY
      IMPORTING keys FOR ACTION xlhead~uploadexceldata RESULT result.

    METHODS fillfilestatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR xlhead~fillfilestatus.

    METHODS fillselectedstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR xlhead~fillselectedstatus.

ENDCLASS.

CLASS lhc_xlhead IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

    METHOD earlynumbering_create.
    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).

      APPEND CORRESPONDING #( <lfs_entities> ) TO mapped-xlhead
        ASSIGNING FIELD-SYMBOL(<lfs_xlhead>).

      <lfs_xlhead>-enduser = lv_user.

      IF <lfs_xlhead>-fileid IS INITIAL.
        TRY.
            <lfs_xlhead>-fileid = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
            " Do nothing – proceed to next entry
        ENDTRY.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD uploadexceldata.

     DATA:
      lo_table_descr  TYPE REF TO cl_abap_tabledescr,
      lo_struct_descr TYPE REF TO cl_abap_structdescr,
      lt_excel        TYPE STANDARD TABLE OF zdb_budget_item,
      wa_excel        TYPE zdb_budget_item,
      lt_excel1       TYPE STANDARD TABLE OF zbp_i_budget_hdr=>gty_gr_data,
      lt_data         TYPE TABLE FOR CREATE zi_budget_hdr\_xldata,
      lv_index        TYPE sy-index.

          FIELD-SYMBOLS:
      <lfs_col_header> TYPE string.

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    " 1. Read Parent Entity
    READ ENTITIES OF zi_budget_hdr IN LOCAL MODE
      ENTITY xlhead
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_file_entity).

    DATA(lv_attachment) = lt_file_entity[ 1 ]-attachment.
    CHECK lv_attachment IS NOT INITIAL.

    " 2. Move Excel Data to Internal Table using XCO
    DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content(
                      iv_file_content = lv_attachment
                    )->read_access( ).

    DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

    DATA(lo_selection_pattern) =
      xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    DATA(lo_execute) = lo_worksheet->select(
                         lo_selection_pattern
                       )->row_stream( )->operation->write_to(
                          REF #( lt_excel1 )
                       ).

    lo_execute->set_value_transformation(
      xco_cp_xlsx_read_access=>value_transformation->string_value
    )->if_xco_xlsx_ra_operation~execute( ).

    " 3. Delete Header Row
    DELETE lt_excel1 INDEX 1.

*    LOOP AT lt_excel1 ASSIGNING FIELD-SYMBOL(<fs_excel_n1>).
*        wa_excel-line_no = sy-tabix.
*        wa_excel-unique_id = <fs_excel_n1>-uniqueid.
*        wa_excel-cust_cat = <fs_excel_n1>-custcat.
*        wa_excel-sales_office_code = <fs_excel_n1>-salesofficecode.
*        wa_excel-sales_office_loc = <fs_excel_n1>-salesofficeloc.
*        wa_excel-cust_code = <fs_excel_n1>-custcode.
*        wa_excel-cust_name = <fs_excel_n1>-custname.
*        wa_excel-prod_code = <fs_excel_n1>-prodcode.
*        wa_excel-prod_name = <fs_excel_n1>-prodname.
*        wa_excel-month_in_text = <fs_excel_n1>-monthintext.
*        wa_excel-month_in_no = <fs_excel_n1>-monthinno.
*        wa_excel-projected_unit_price = <fs_excel_n1>-projectedunitprice.
*        wa_excel-projection_in_qty = <fs_excel_n1>-projectioninqty.
*        wa_excel-projection_in_value = <fs_excel_n1>-projectioninvalue.
*        wa_excel-potential = <fs_excel_n1>-potential.
*        wa_excel-sales_person = <fs_excel_n1>-salesperson.
*        wa_excel-segment = <fs_excel_n1>-segment.
*        wa_excel-product_family = <fs_excel_n1>-productfamily.
*
*
*
*      APPEND wa_excel TO lt_excel.
*      CLEAR wa_excel.
*    ENDLOOP.

LOOP AT lt_excel1 ASSIGNING FIELD-SYMBOL(<fs_excel_n1>).
      wa_excel-line_no           = sy-tabix.
      wa_excel-unique_id         = <fs_excel_n1>-uniqueid.
      wa_excel-cust_cat          = <fs_excel_n1>-custcat.
      wa_excel-sales_office_code = <fs_excel_n1>-salesofficecode.
      wa_excel-sales_office_loc  = <fs_excel_n1>-salesofficeloc.
      wa_excel-cust_code         = <fs_excel_n1>-custcode.
      wa_excel-cust_name         = <fs_excel_n1>-custname.
      wa_excel-prod_code         = <fs_excel_n1>-prodcode.
      wa_excel-prod_name         = <fs_excel_n1>-prodname.
      wa_excel-month_in_text     = <fs_excel_n1>-monthintext.
      wa_excel-month_in_no       = <fs_excel_n1>-monthinno.
      wa_excel-sales_person      = <fs_excel_n1>-salesperson.
      wa_excel-segment           = <fs_excel_n1>-segment.
      wa_excel-product_family    = <fs_excel_n1>-productfamily.

      " Safely handle Scientific Notation and text for Decimal fields
      TRY.
          wa_excel-projected_unit_price = CONV decfloat34( <fs_excel_n1>-projectedunitprice ).
        CATCH cx_root.
          CLEAR wa_excel-projected_unit_price.
      ENDTRY.

      TRY.
          wa_excel-projection_in_qty = CONV decfloat34( <fs_excel_n1>-projectioninqty ).
        CATCH cx_root.
          CLEAR wa_excel-projection_in_qty.
      ENDTRY.

      TRY.
          wa_excel-projection_in_value = CONV decfloat34( <fs_excel_n1>-projectioninvalue ).
        CATCH cx_root.
          CLEAR wa_excel-projection_in_value.
      ENDTRY.

      TRY.
          wa_excel-potential = CONV decfloat34( <fs_excel_n1>-potential ).
        CATCH cx_root.
          CLEAR wa_excel-potential.
      ENDTRY.

      APPEND wa_excel TO lt_excel.
      CLEAR wa_excel.
    ENDLOOP.

    " 5. Fill Line ID
    TRY.
        DATA(lv_line_id) = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
    ENDTRY.

    LOOP AT lt_excel ASSIGNING FIELD-SYMBOL(<lfs_excel>).
      <lfs_excel>-line_id = lv_line_id.
    ENDLOOP.

    " 6. Prepare Data for Child Entity (_XLData)
    lt_data = VALUE #(
      (
        %cid_ref  = keys[ 1 ]-%cid_ref
        %tky      = keys[ 1 ]-%tky
        %target   = VALUE #(
          FOR lwa_excel IN lt_excel
          (
            %cid      = keys[ 1 ]-%cid_ref
            %is_draft = keys[ 1 ]-%is_draft
            %data     = VALUE #(
              EndUser            = keys[ 1 ]-EndUser
              FileId             = keys[ 1 ]-FileId
              LineId             = lwa_excel-line_id
              Line_No            = lwa_excel-line_no
              UniqueId           = lwa_excel-unique_id
              CustCat            = lwa_excel-cust_cat
              SalesOfficeCode    = lwa_excel-sales_office_code
              SalesOfficeLoc     = lwa_excel-sales_office_loc
              CustCode           = lwa_excel-cust_code
              CustName           = lwa_excel-cust_name
              ProdCode           = lwa_excel-prod_code
              ProdName           = lwa_excel-prod_name
              MonthInText        = lwa_excel-month_in_text
              MonthInNo          = lwa_excel-month_in_no
              ProjectedUnitPrice = lwa_excel-projected_unit_price
              ProjectionInQty    = lwa_excel-projection_in_qty
              ProjectionInValue  = lwa_excel-projection_in_value
              Potential           = lwa_excel-potential
              SalesPerson        = lwa_excel-sales_person
              Segment            = lwa_excel-segment
              ProductFamily      = lwa_excel-product_family
            )
            %control = VALUE #(
              EndUser            = if_abap_behv=>mk-on
              FileId             = if_abap_behv=>mk-on
              LineId             = if_abap_behv=>mk-on
              Line_No            = if_abap_behv=>mk-on
              UniqueId           = if_abap_behv=>mk-on
              CustCat            = if_abap_behv=>mk-on
              SalesOfficeCode    = if_abap_behv=>mk-on
              SalesOfficeLoc     = if_abap_behv=>mk-on
              CustCode           = if_abap_behv=>mk-on
              CustName           = if_abap_behv=>mk-on
              ProdCode           = if_abap_behv=>mk-on
              ProdName           = if_abap_behv=>mk-on
              MonthInText        = if_abap_behv=>mk-on
              MonthInNo          = if_abap_behv=>mk-on
              ProjectedUnitPrice = if_abap_behv=>mk-on
              ProjectionInQty    = if_abap_behv=>mk-on
              ProjectionInValue  = if_abap_behv=>mk-on
              Potential           = if_abap_behv=>mk-on
              SalesPerson        = if_abap_behv=>mk-on
              Segment            = if_abap_behv=>mk-on
              ProductFamily      = if_abap_behv=>mk-on
            )
          )
        )
      )
    ).

    " 7. Delete Existing entries for user if any
    READ ENTITIES OF zi_budget_hdr IN LOCAL MODE
      ENTITY xlhead BY \_xldata
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_existing_xldata).

    IF lt_existing_xldata IS NOT INITIAL.
      MODIFY ENTITIES OF zi_budget_hdr IN LOCAL MODE
        ENTITY xldata
        DELETE FROM VALUE #(
          FOR lwa_data IN lt_existing_xldata
          (
            %key      = lwa_data-%key
            %is_draft = lwa_data-%is_draft
          )
        )
        MAPPED   DATA(lt_del_mapped)
        REPORTED DATA(lt_del_reported)
        FAILED   DATA(lt_del_failed).
    ENDIF.

    " 8. Add New Entry for XLData (association)
    MODIFY ENTITIES OF zi_budget_hdr IN LOCAL MODE
      ENTITY xlhead CREATE BY \_xldata
      AUTO FILL CID WITH lt_data.

    " 9. Modify Status
    MODIFY ENTITIES OF zi_budget_hdr IN LOCAL MODE
      ENTITY xlhead
      UPDATE FROM VALUE #(
        (
          %tky                 = lt_file_entity[ 1 ]-%tky
          FileStatus           = 'File Uploaded'
          %control-FileStatus  = if_abap_behv=>mk-on
        )
      )
      MAPPED DATA(lt_upd_mapped)
      FAILED DATA(lt_upd_failed)
      REPORTED DATA(lt_upd_reported).

    " 10. Read Updated Entry and Return
    READ ENTITIES OF zi_budget_hdr IN LOCAL MODE
      ENTITY xlhead
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_xlhead).

    result = VALUE #(
      FOR lwa_upd_head IN lt_updated_xlhead
      (
        %tky      = lwa_upd_head-%tky
        %is_draft = lwa_upd_head-%is_draft
        %param    = lwa_upd_head
      )
    ).
  ENDMETHOD.

  METHOD fillfilestatus.
  ENDMETHOD.

  METHOD fillselectedstatus.
  ENDMETHOD.

ENDCLASS.
