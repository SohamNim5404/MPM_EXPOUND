CLASS zcl_sales_register_new_pb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_SALES_REGISTER_NEW_PB IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA : lv_refdoc TYPE i_accountingdocumentjournal-referencedocument.

    DATA: lt_response TYPE TABLE OF zce_sales_register_new_pb,
          ls_response TYPE zce_sales_register_new_pb.

    " Pagination parameters from request
    DATA(lv_top)    = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)   = io_request->get_paging( )->get_offset( ).

    " Handle invalid pagination inputs
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    " Filter and sort details
    DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields) = io_request->get_requested_elements( ).
    DATA(lt_sort)   = io_request->get_sort_elements( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range ##NO_HANDLER.
    ENDTRY.


    " Extract filter ranges
    DATA(lr_fkdat) = VALUE #( lt_filter_cond[ name = 'FKDAT' ]-range OPTIONAL ).
    DATA(lr_bukrs) = VALUE #( lt_filter_cond[ name = 'BUKRS' ]-range OPTIONAL ).
    DATA(lr_werks) = VALUE #( lt_filter_cond[ name = 'WERKS' ]-range OPTIONAL ).
    DATA(lr_fkart) = VALUE #( lt_filter_cond[ name = 'FKART' ]-range OPTIONAL ).
    DATA(lr_kunnr) = VALUE #( lt_filter_cond[ name = 'SOLD_TO' ]-range OPTIONAL ).
    DATA(lr_vbeln) = VALUE #( lt_filter_cond[ name = 'VBELN' ]-range OPTIONAL ).



    " ===============================
    "   MAIN DATA SELECTION SECTION
    " ===============================

    SELECT FROM i_billingdocument AS a
             JOIN i_billingdocumentitembasic AS b
               ON ( a~billingdocument = b~billingdocument )
             JOIN i_billingdocumentbasic AS f
               ON ( a~billingdocument = f~billingdocument )
      LEFT OUTER JOIN i_customer AS a1
               ON ( a~soldtoparty = a1~customer )
      LEFT OUTER JOIN i_customer AS a11
               ON ( a~payerparty = a11~customer )
      LEFT OUTER JOIN i_salesdocumentpartner AS c
               ON b~salesdocument = c~salesdocument
              AND c~partnerfunction = 'WE'
      LEFT OUTER JOIN i_customer AS c1
               ON ( c~customer = c1~customer )
      LEFT OUTER JOIN i_billingdocumentpartner AS d
               ON a~billingdocument = d~billingdocument
              AND d~partnerfunction = 'RE'
      LEFT OUTER JOIN i_billingdocumentpartner AS bp
               ON a~billingdocument = bp~billingdocument
              AND bp~partnerfunction = 'ZP'
      LEFT OUTER JOIN i_customer AS d1
               ON ( d~customer = d1~customer )
      LEFT OUTER JOIN i_plant AS e
               ON e~plant = b~plant
      LEFT OUTER JOIN i_in_plantbusinessplacedetail AS f1
               ON f1~plant = e~plant
      LEFT OUTER JOIN i_in_businessplacetaxdetail AS g1
               ON g1~businessplace = f1~businessplace
      LEFT OUTER JOIN i_productplantbasic AS e1
               ON ( b~product = e1~product AND b~plant = e1~plant )
      LEFT OUTER JOIN i_billingdocumentitem AS t1
               ON t1~billingdocument = b~billingdocument
              AND t1~billingdocumentitem = b~billingdocumentitem
      LEFT OUTER JOIN zr_ewb_trans_dtls AS t2
               ON t2~billingdocument = b~billingdocument
      LEFT OUTER JOIN i_billingdocumentitem AS t4
               ON t4~billingdocument = b~billingdocument
              AND t4~billingdocumentitem = b~billingdocumentitem
      LEFT OUTER JOIN i_deliverydocumentitem AS dc1
               ON dc1~deliverydocument = b~referencesddocument
      LEFT OUTER JOIN i_salesdocument AS sd1
               ON sd1~salesdocument = dc1~referencesddocument
               AND dc1~deliverydocumentitem = b~referencesddocumentitem
      inner join I_SalesDocumentItem as sditm
               on sditm~salesdocument = sd1~salesdocument
               AND sditm~salesdocumentitem = dc1~referencesddocumentitem
      LEFT OUTER JOIN i_businesspartner AS h
               ON bp~supplier = h~businesspartner
      LEFT OUTER JOIN i_product AS h1
               ON h1~product = b~product
      LEFT OUTER JOIN i_distributionchanneltext AS dct
               ON dct~distributionchannel = a~distributionchannel
               AND dct~language = @sy-langu
      LEFT OUTER JOIN i_billingdocumenttypetext AS bdtt
               ON bdtt~billingdocumenttype = a~billingdocumenttype
               AND bdtt~language = @sy-langu
      LEFT OUTER JOIN i_producttypetext AS ptt
               ON ptt~producttype = h1~producttype
               AND ptt~language = @sy-langu
      LEFT OUTER JOIN i_divisiontext AS dt
               ON dt~division = a~division
               AND dt~language = @sy-langu
      LEFT OUTER JOIN i_accountingdocumentjournal AS acc
               ON acc~referencedocument = a~billingdocument
               AND acc~ledger = '0L'
               AND acc~accountingdocumenttype = 'RV'
      LEFT OUTER JOIN zc_ewaybill AS ew
               ON ew~docno = a~billingdocument
      LEFT OUTER JOIN i_customeraccountgrouptext AS cg
               ON cg~customeraccountgroup = a1~customeraccountgroup
      LEFT OUTER JOIN zc_billinginv AS iv
               ON iv~billingdocument = a~billingdocument
      LEFT OUTER JOIN i_businesspartnerindustry AS in
               ON in~businesspartner = a1~customer
 left outer join I_SalesOfficeText as ot
  on ot~SalesOffice = t1~SalesOffice
  left outer join I_ProductText as pt
  on pt~Product = h1~product
  left outer join I_ExtProdGrpText as extp
  on extp~ExternalProductGroup = h1~ExternalProductGroup
  left outer join i_Salesorder as so
  on so~SalesOffice = ot~SalesOffice
  left outer join I_SalesOrderItem as soitm
  on soitm~SalesOrder = so~SalesOrder
      FIELDS a~billingdocument,
      ot~SalesOfficeName    ,
      pt~ProductName,
*      extp~ExternalProductGroup,
      extp~ExternalProductGroupName,
      h1~ExternalProductGroup,
      so~PurchaseOrderByCustomer,
  soitm~NetPriceAmount,
a~FiscalYear,
a~FiscalPeriod,
*sditm~NetPriceAmount,
             b~billingdocumentitem,
             a~billingdocumentdate,
             a~companycode,
             a~transactioncurrency,
             a~accountingexchangerate,
             a~soldtoparty,
             a1~customername AS sold_to_nm,
             a~billingdocumenttype,
             a~payerparty,
             a~salesorganization,
             a~distributionchannel,
             a~division,
             a~country,
             a~incotermsclassification,
             a~customerpaymentterms,
             a~region,
             a11~customername AS payernm,
             c~customer AS shipto,
             c1~customername AS shiptonm,
             d~customer AS billto,
             d1~customername AS billtonm,
             d1~taxnumber3 AS gstin,
             b~referencesddocument,
             b~referencesddocumentitem,
             b~salesdocument,
             b~salesdocumentitem,
             b~plant,

             b~product,
             b~productgroup,
             b~billingdocumentitemtext,
             b~billingquantity,
             b~billingquantityunit,
             b~netamount,
             b~taxamount,
             b~profitcenter,
             t1~billtopartyregion,
             t1~plantregion,
             b~pricedetnexchangerate,
             g1~in_gstidentificationnumber AS gstin1,
             e1~consumptiontaxctrlcode,
             t2~vehno,
             t2~transnm,
             t2~transid,
*             sd1~purchaseorderbycustomer,
             sd1~customerpurchaseorderdate,
             h1~producttype AS materialtype,
             ptt~materialtypename,
             dct~distributionchannelname AS distributionchannelname,
             dt~divisionname,
             bdtt~billingdocumenttypename AS invoicetype,
             acc~accountingdocument AS journalentry_no,
             acc~postingdate AS journalentry_dt,
             ew~ebillno AS ewaybill,
             b~batch AS batch,
             a1~customeraccountgroup AS accountgroup,
             cg~accountgroupname AS accountgroupname,
             iv~irn AS irnno,
             in~industrysector AS industry,
             in~industrykeydescription AS industrydescription,
             t1~salesoffice,
             t1~salesgroup

       WHERE a~billingdocumentdate IN @lr_fkdat
         AND a~companycode IN @lr_bukrs
         AND a~billingdocumenttype IN @lr_fkart
         AND a~soldtoparty IN @lr_kunnr
         AND a~billingdocument IN @lr_vbeln
         AND b~plant IN @lr_werks
*         AND a~billingdocumenttype NE 'F8'                 "BY AM removel 21042026
       ORDER BY a~billingdocument, b~billingdocumentitem
       INTO TABLE @DATA(lt_inv).

    DELETE ADJACENT DUPLICATES FROM lt_inv COMPARING billingdocument billingdocumentitem.


*    DATA: lt_werks_auth TYPE SORTED TABLE OF werks_d WITH UNIQUE KEY table_line,
*          lt_werks_ok   TYPE SORTED TABLE OF werks_d WITH UNIQUE KEY table_line,
*          lt_inv_final  LIKE lt_inv,
*          lv_werks      TYPE werks_d.
*
*    LOOP AT lt_inv INTO DATA(ls_inv_werks).
*      IF ls_inv_werks-plant IS NOT INITIAL.
*        INSERT ls_inv_werks-plant INTO TABLE lt_werks_auth.
*      ENDIF.
*    ENDLOOP.
*
*    LOOP AT lt_werks_auth INTO lv_werks.
*
*      AUTHORITY-CHECK OBJECT 'ZPLANT'    ##AUTH_FLD_MISSING
*        ID 'ZWERKS' FIELD lv_werks.
*
*      IF sy-subrc = 0.
*        INSERT lv_werks INTO TABLE lt_werks_ok.
*      ENDIF.
*
*    ENDLOOP.
*
*    LOOP AT lt_inv INTO DATA(ls_inv_plant).
*
*      READ TABLE lt_werks_ok
*        WITH KEY table_line = ls_inv_plant-plant
*        TRANSPORTING NO FIELDS.
*
*      IF sy-subrc = 0.
*        APPEND ls_inv_plant TO lt_inv_final.
*      ENDIF.
*
*    ENDLOOP.
*
*    " Replace original data
*    lt_inv = lt_inv_final.

    TYPES: BEGIN OF ty_inv_key,
             billingdocument     TYPE zcogm-billingdocument,
             billingdocumentitem TYPE zcogm-billingdocumentitem,
           END OF ty_inv_key.

    DATA: lt_inv_key TYPE STANDARD TABLE OF ty_inv_key.

    lt_inv_key = VALUE #(
      FOR wa IN lt_inv
      ( billingdocument     = wa-billingdocument
        billingdocumentitem = wa-billingdocumentitem ) ).

    " --- After the lt_inv selection and sorting ---
    IF lt_inv_key[] IS NOT INITIAL.

      SELECT FROM zcogm
      FIELDS billingdocument,
             billingdocumentitem,
             cogm,
             rmcost,
             overhead,
             scrap
      FOR ALL ENTRIES IN @lt_inv_key
      WHERE billingdocument     = @lt_inv_key-billingdocument
        AND billingdocumentitem = @lt_inv_key-billingdocumentitem
      INTO TABLE @DATA(lt_cogm_data).

      SORT lt_cogm_data BY billingdocument billingdocumentitem.

    ENDIF.

    IF lt_inv[] IS NOT INITIAL.
      SORT lt_inv BY billingdocument billingdocumentitem .
      DELETE ADJACENT DUPLICATES FROM lt_inv COMPARING billingdocument billingdocumentitem .
      SELECT FROM i_billingdocumentitemprcgelmnt
       FIELDS billingdocument, billingdocumentitem, conditiontype,
              conditionratevalue, conditioncurrency, conditionamount, conditionisforstatistics
          FOR ALL ENTRIES IN @lt_inv
          WHERE billingdocument = @lt_inv-billingdocument
          AND   billingdocumentitem = @lt_inv-billingdocumentitem
          INTO TABLE @DATA(lt_prcd).
      SORT lt_prcd BY billingdocument billingdocumentitem conditiontype.

    ENDIF.

    SELECT *                  "#EC CI_ALL_FIELDS_NEEDED "#EC CI_NOWHERE
    FROM zei_state
    INTO TABLE @DATA(it_state).

    LOOP AT lt_inv INTO DATA(ls_inv).

      ls_response-fkdat = ls_inv-billingdocumentdate.
      ls_response-bukrs = ls_inv-companycode.
      ls_response-sold_to = ls_inv-soldtoparty.
      ls_response-sold_to_nm = ls_inv-sold_to_nm.
      ls_response-werks = ls_inv-plant.

      SELECT SINGLE
        customer, addressid, customername, taxnumber3, country,
        streetname, cityname, postalcode, region, telephonenumber1
        FROM i_customer
        WHERE customer = @ls_response-sold_to
        INTO @DATA(wa_kna1).

      SELECT SINGLE * FROM i_organizationaddress "#EC CI_ALL_FIELDS_NEEDED
      WITH PRIVILEGED ACCESS
      WHERE addressid = @wa_kna1-addressid
      INTO @DATA(gs_orgaddress).

*      ls_response-custr =  gs_orgaddress-region.

      " --- New COGM Mapping ---
      READ TABLE lt_cogm_data INTO DATA(ls_cogm)
        WITH KEY billingdocument     = ls_inv-billingdocument
                 billingdocumentitem = ls_inv-billingdocumentitem
        BINARY SEARCH.

        DATA: lt_extwg_text TYPE sorted TABLE OF zextwg_text
              with unique key language extwg.


SELECT *                               "#EC CI_NOWHERE
  FROM zextwg_text
  INTO TABLE @lt_extwg_text.

  DATA(lv_month) = ls_inv-billingdocumentdate+4(2).

CASE lv_month.
  WHEN '01'. ls_response-monthss = 'January'.
  WHEN '02'. ls_response-monthss = 'February'.
  WHEN '03'. ls_response-monthss = 'March'.
  WHEN '04'. ls_response-monthss = 'April'.
  WHEN '05'. ls_response-monthss = 'May'.
  WHEN '06'. ls_response-monthss = 'June'.
  WHEN '07'. ls_response-monthss = 'July'.
  WHEN '08'. ls_response-monthss = 'August'.
  WHEN '09'. ls_response-monthss = 'September'.
  WHEN '10'. ls_response-monthss = 'October'.
  WHEN '11'. ls_response-monthss = 'November'.
  WHEN '12'. ls_response-monthss = 'December'.
ENDCASE.

*  Data : lt_new type table of I_SalesOrderItem,
*         ls_new type I_SalesOrderItem.
*
*  select * from   I_SalesOrderItem as Item
*    inner join      I_SalesOrder     as Head on Head~SalesOrder = Item~SalesOrder
*    into table @lt_new.

*      IF sy-subrc = 0.
*        ls_response-cogm = ls_cogm-cogm.
*        ls_response-rmcost = ls_cogm-rmcost.
*        ls_response-overhead = ls_cogm-overhead.
*        ls_response-scrap = ls_cogm-scrap.
*      ELSE.
*        ls_response-cogm  = 0.
*        ls_response-rmcost = 0.
*        ls_response-overhead = 0.
*        ls_response-scrap = 0.
*      ENDIF.

*      CONCATENATE gs_orgaddress-streetprefixname1 gs_orgaddress-streetprefixname2 INTO ls_response-billpadd SEPARATED BY space.

      ls_response-vbeln = ls_inv-billingdocument.
      ls_response-fkart = ls_inv-billingdocumenttype.
      ls_response-InvoiceType = ls_inv-invoicetype.
      ls_response-posnr = ls_inv-BillingDocumentItem.
      ls_response-desc_sales_off = ls_inv-SalesOfficeName  .
      ls_response-maktx = ls_inv-ProductName.
      ls_response-billed_quantity = ls_inv-BillingQuantity.
      ls_response-customer_po_no = ls_inv-PurchaseOrderByCustomer.
      ls_response-ass_value = ls_inv-NetAmount.
      ls_response-gross_value = ls_inv-NetAmount + ls_inv-TaxAmount.
ls_response-unit_price = ls_inv-NetPriceAmount.
ls_response-fiscal_year = ls_inv-FiscalYear.
ls_response-posting_period = ls_inv-FiscalPeriod.


READ TABLE lt_extwg_text INTO DATA(ls_extwg_text)
  with key  language = sy-langu
   extwg = ls_inv-ExternalProductGroup.



  ls_response-materialgroup = ls_extwg_text-extwg.
  ls_response-sub_mat_group_text = ls_extwg_text-ewbez.

*      ls_response-billingdocumenttypename = ls_inv-invoicetype.
*      ls_response-posnr = ls_inv-billingdocumentitem.
*      ls_response-vbeln_d  = ls_inv-referencesddocument.
*      ls_response-posnr_d  = ls_inv-referencesddocumentitem.
*      ls_response-vbeln_s  = ls_inv-salesdocument.
*      ls_response-posnr_s  = ls_inv-salesdocumentitem.
      ls_response-shipto   = ls_inv-shipto.
*      ls_response-shiptonm = ls_inv-shiptonm.
*      ls_response-billto   = ls_inv-billto.
*      ls_response-billtonm = ls_inv-billtonm.
*      ls_response-payer    = ls_inv-payerparty.
*      ls_response-payernm  = ls_inv-payernm.
*      ls_response-gstin    = ls_inv-gstin.
*      ls_response-gstin1    = ls_inv-gstin1.
      ls_response-matnr    = ls_inv-product.
*      ls_response-materialtype = ls_inv-materialtype.
*      ls_response-materialtypename = ls_inv-materialtypename.
*      ls_response-maktx    = ls_inv-billingdocumentitemtext.
      ls_response-uom      = ls_inv-billingquantityunit.
*      ls_response-fkimg    = ls_inv-billingquantity.
      ls_response-currency = ls_inv-transactioncurrency.
*      ls_response-kurrf    = ls_inv-accountingexchangerate.

*      ls_response-netvalue = ls_inv-netamount.
*      ls_response-tax      = ls_inv-taxamount.
*      ls_response-totalvalue = ls_inv-netamount + ls_inv-taxamount.
*      ls_response-profitcenter = ls_inv-profitcenter .
      ls_response-salesorganization = ls_inv-salesorganization .
*      ls_response-distributionchannel = ls_inv-distributionchannel .
*      ls_response-distributionchannelname = ls_inv-distributionchannelname.
*      ls_response-division = ls_inv-division .
*      ls_response-divisionname = ls_inv-divisionname.
*      ls_response-country = ls_inv-country .
*      ls_response-incotermsclassification = ls_inv-incotermsclassification.
*      ls_response-customerpaymentterms = ls_inv-customerpaymentterms .
*      ls_response-journalentry_no = ls_inv-journalentry_no.
*      ls_response-journalentry_dt = ls_inv-journalentry_dt.
*      ls_response-ewaybill = ls_inv-ewaybill.
      ls_response-batch = ls_inv-batch.
*      ls_response-accountgroup = ls_inv-accountgroup.
*      ls_response-accountgroupname    = ls_inv-accountgroupname.
*      ls_response-irnno = ls_inv-irnno.
*      ls_response-industry = ls_inv-industry.
*      ls_response-industrydescription = ls_inv-industrydescription.
*
*      ls_response-pregion = gs_orgaddress-region.
*      ls_response-materialgroup = ls_inv-productgroup.
      ls_response-shipto = ls_inv-shipto.
*      ls_response-shiptonm = ls_inv-shiptonm.
*      ls_response-billto = ls_inv-billto.
*      ls_response-billtonm = ls_inv-billtonm.
*
*      ls_response-vno = ls_inv-vehno.
*      ls_response-tname = ls_inv-transnm.
*      ls_response-consumptiontaxctrlcode = ls_inv-consumptiontaxctrlcode.
*      ls_response-custref = ls_inv-purchaseorderbycustomer.
*      ls_response-custrdt = ls_inv-customerpurchaseorderdate.
      ls_response-salesoffice = ls_inv-salesoffice.
*      ls_response-salesgroup = ls_inv-salesgroup.

      LOOP AT lt_prcd INTO DATA(ls_prcd)
        WHERE billingdocument = ls_inv-billingdocument
        AND   billingdocumentitem = ls_inv-billingdocumentitem.

*        CASE ls_prcd-conditiontype.
**          WHEN 'PR00'.ZPR0
*          WHEN 'ZB00' OR 'ZBAS' OR 'ZPRO' OR 'ZFOB'.
*            ls_response-rate = ls_prcd-conditionratevalue.
*          WHEN 'JOCG'.
*            ls_response-cgstvalue = ls_prcd-conditionamount.
*            ls_response-cgstperc  = ls_prcd-conditionratevalue.
*          WHEN 'JOSG'.
*            ls_response-sgstvalue = ls_prcd-conditionamount.
*            ls_response-sgstperc  = ls_prcd-conditionratevalue.
*          WHEN 'JOUG'.
*            ls_response-ugstvalue = ls_prcd-conditionamount.
*            ls_response-ugstperc = ls_prcd-conditionratevalue.
*          WHEN 'JOIG'.
*            ls_response-igstvalue = ls_prcd-conditionamount.
*            ls_response-igstperc = ls_prcd-conditionratevalue.
*          WHEN 'JTC1' OR 'JTC2'.
*            ls_response-tcsvalue = ls_prcd-conditionamount.
*          WHEN 'ZINS'.
*            ls_response-insurance = ls_prcd-conditionamount.
*          WHEN 'ZGTO'.
*            ls_response-roundoff = ls_prcd-conditionamount.
*          WHEN 'ZFMS'.
*            ls_response-trfreight = ls_prcd-conditionamount.
*          WHEN 'Z004' OR 'Z005'.
*            ls_response-discount = ls_prcd-conditionamount.
*          WHEN 'ZFOC'.
*            ls_response-freeofcharge = ls_prcd-conditionamount.
*          WHEN 'ZFRB' OR 'ZKF0'.
*            ls_response-freight = ls_prcd-conditionamount.
*          WHEN 'ZMAK'.
*            ls_response-markupvalue = ls_prcd-conditionamount.
*        ENDCASE.

      ENDLOOP.

*      ls_response-amt_inr = ls_response-kurrf * ls_response-netvalue.
*      ls_response-tax_inr = ls_response-tax * ls_response-kurrf.
*      ls_response-tot_inr = ls_response-totalvalue * ls_response-kurrf.

*      IF ls_inv-billingdocumenttype = 'CBRE' OR ls_inv-billingdocumenttype = 'S1' OR ls_inv-billingdocumenttype = 'CR'.
*        ls_response-fkimg = ls_response-fkimg * -1.
*        ls_response-netvalue = ls_response-netvalue * -1.
*        ls_response-tax = ls_response-tax * -1.
*        ls_response-totalvalue = ls_response-totalvalue * -1.
*        ls_response-cgstperc = ls_response-cgstperc * -1.
*        ls_response-cgstvalue = ls_response-cgstvalue * -1.
*        ls_response-sgstperc = ls_response-sgstperc * -1.
*        ls_response-sgstvalue = ls_response-sgstvalue * -1.
*        ls_response-ugstperc = ls_response-ugstperc * -1.
*        ls_response-ugstvalue = ls_response-ugstvalue * -1.
*        ls_response-igstperc = ls_response-igstperc * -1.
*        ls_response-igstvalue = ls_response-igstvalue * -1.
*        ls_response-tcsvalue = ls_response-tcsvalue * -1.
*        ls_response-amt_inr = ls_response-amt_inr * -1.
*        ls_response-tax_inr = ls_response-tax_inr * -1.
*        ls_response-tot_inr = ls_response-tot_inr * -1.
*        ls_response-rate = ls_response-rate * -1.


*      ENDIF.
      APPEND ls_response TO lt_response.
      CLEAR : ls_response,  lv_refdoc, ls_cogm . "wa_glcct.

    ENDLOOP.
    SORT lt_response BY fkdat ASCENDING.
    DATA lv_total_count TYPE int8.
    lv_total_count = lines( lt_response ).

    DATA lt_paged TYPE TABLE OF zce_sales_register_new_pb.
    DATA lv_index TYPE i VALUE 0.

    LOOP AT lt_response INTO DATA(ls_row).
      lv_index = lv_index + 1.
      IF lv_index > lv_skip AND lv_index <= lv_skip + lv_top.
        APPEND ls_row TO lt_paged.
      ENDIF.
    ENDLOOP.

    io_response->set_total_number_of_records( lv_total_count ).
    io_response->set_data( lt_paged ).

* ENDIF.


  ENDMETHOD.
ENDCLASS.
