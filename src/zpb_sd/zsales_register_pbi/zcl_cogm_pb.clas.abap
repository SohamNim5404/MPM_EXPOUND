CLASS zcl_cogm_pb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES tt_cogm TYPE STANDARD TABLE OF ztb_cogm_pb WITH EMPTY KEY.

    METHODS get_data
      IMPORTING
        iv_billingdocument TYPE i_billingdocument-billingdocument
      RETURNING
        VALUE(rt_cogm)     TYPE zcl_cogm_pb=>tt_cogm.

    METHODS get_prd_cost
      IMPORTING
        billingdocument     TYPE i_billingdocument-billingdocument
        billingdocumentitem TYPE i_billingdocumentitem-billingdocumentitem
        product             TYPE i_billingdocumentitem-product
        batch               TYPE i_billingdocumentitem-batch
        plant               TYPE i_billingdocumentitem-plant
      EXPORTING
        freight             TYPE ztb_cogm_pb-freight
        cogm                TYPE ztb_cogm_pb-cogm
        rmcost              TYPE ztb_cogm_pb-rmcost
        scrap               TYPE ztb_cogm_pb-scrap
        overhead            TYPE ztb_cogm_pb-overhead
        fixedoverhead       TYPE ztb_cogm_pb-fixedoverhead
        labour              TYPE ztb_cogm_pb-labour
        aux_power           TYPE ztb_cogm_pb-aux_power
        power               TYPE ztb_cogm_pb-power
        variableoverhead    TYPE ztb_cogm_pb-variableoverhead
        orderid             TYPE ztb_cogm_pb-orderid.

ENDCLASS.



CLASS ZCL_COGM_PB IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lt_cogm TYPE zcl_cogm_pb=>tt_cogm.

    " 🔹 Pass your test Billing Document here
    DATA(lv_billingdoc) = 'MDI1260045'.   " <-- change as needed

    " 🔹 Call your main method
    lt_cogm = NEW zcl_cogm_pb( )->get_data(
                 iv_billingdocument = lv_billingdoc ).

    " 🔹 Output results
    IF lt_cogm IS INITIAL.
      out->write( 'No data found' ).
      RETURN.
    ENDIF.

    LOOP AT lt_cogm INTO DATA(ls_out).

      out->write( |----------------------------------------| ).
      out->write( |BillingDoc : { ls_out-billingdocument }| ).
      out->write( |Item       : { ls_out-billingdocumentitem }| ).
      out->write( |Product    : { ls_out-product }| ).
      out->write( |Batch      : { ls_out-batch }| ).
      out->write( |Plant      : { ls_out-plant }| ).
      out->write( |Delivery   : { ls_out-deliverynote }| ).
      out->write( |OrderID    : { ls_out-orderid }| ).

      out->write( |--- COSTING ---| ).
      out->write( |COGM          : { ls_out-cogm }| ).
      out->write( |RM Cost       : { ls_out-rmcost }| ).
      out->write( |Scrap         : { ls_out-scrap }| ).
      out->write( |Fixed OH      : { ls_out-fixedoverhead }| ).
      out->write( |Labour        : { ls_out-labour }| ).
      out->write( |Aux Power     : { ls_out-aux_power }| ).
      out->write( |Power         : { ls_out-power }| ).
      out->write( |Overhead      : { ls_out-overhead }| ).
      out->write( |Var OH        : { ls_out-variableoverhead }| ).
      out->write( |Freight       : { ls_out-freight }| ).

    ENDLOOP.

  ENDMETHOD.


  METHOD get_data.

    DATA: lt_items TYPE TABLE OF i_billingdocumentitem.

    SELECT a~billingdocument, a~billingdocumentitem, a~product, a~batch, a~plant, a~referencesddocument, a~billingquantity, b~division
      FROM i_billingdocumentitem AS a
      INNER JOIN i_product AS b
      ON a~product = b~product
      WHERE billingdocument = @iv_billingdocument
      INTO CORRESPONDING FIELDS OF TABLE @lt_items.

    LOOP AT lt_items INTO DATA(ls_item).

      DATA: ls_out TYPE ztb_cogm_pb.

      " 🔹 CASE 1: Manufacturing (Division = 11)
      IF ls_item-division = 11.

        me->get_prd_cost(
          EXPORTING
            billingdocument = ls_item-billingdocument
            billingdocumentitem = ls_item-billingdocumentitem
            product         = ls_item-product
            batch           = ls_item-batch
            plant           = ls_item-plant
          IMPORTING
            cogm             = ls_out-cogm
            rmcost           = ls_out-rmcost
            scrap            = ls_out-scrap
            overhead         = ls_out-overhead
            fixedoverhead    = ls_out-fixedoverhead
            labour           = ls_out-labour
            aux_power        = ls_out-aux_power
            power            = ls_out-power
            variableoverhead = ls_out-variableoverhead
            freight          = ls_out-freight
            orderid          = ls_out-orderid
        ).

      ELSE.

        " 🔹 CASE 2: Trading Material

        " --- Get PCIP (COGM) ---
        SELECT *
          FROM i_billingdocumentitemprcgelmnt
          WHERE billingdocument     = @ls_item-billingdocument
            AND billingdocumentitem = @ls_item-billingdocumentitem
          INTO TABLE @DATA(lt_prc_trd).

        LOOP AT lt_prc_trd INTO DATA(ls_prc_trd).

          CASE ls_prc_trd-conditiontype.

            WHEN 'PCIP'.
              ls_out-cogm += ls_prc_trd-conditionamount.

            WHEN 'ZFMS' OR 'ZFRB' OR 'ZKF0'.
              ls_out-freight += ls_prc_trd-conditionamount.

          ENDCASE.

        ENDLOOP.

        IF ls_item-billingquantity IS NOT INITIAL.
          ls_out-cogm = ls_out-cogm / ls_item-billingquantity.
          ls_out-freight = ls_out-freight / ls_item-billingquantity.
        ENDIF.

        " --- No other cost calculation ---
        CLEAR: ls_out-rmcost,
               ls_out-scrap,
               ls_out-fixedoverhead,
               ls_out-labour,
               ls_out-aux_power,
               ls_out-power,
               ls_out-overhead,
               ls_out-variableoverhead.

      ENDIF.

      ls_out-client              = sy-mandt.
      ls_out-billingdocument     = ls_item-billingdocument.
      ls_out-billingdocumentitem = ls_item-billingdocumentitem.
      ls_out-product             = ls_item-product.
      ls_out-batch               = ls_item-batch.
      ls_out-plant               = ls_item-plant.
      ls_out-deliverynote        = ls_item-referencesddocument.

      APPEND ls_out TO rt_cogm.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_prd_cost.

    CLEAR: cogm, rmcost, scrap, overhead, fixedoverhead, labour, aux_power, power, variableoverhead, freight, orderid.

    DATA lv_billqty TYPE i_billingdocumentitem-billingquantity.

    SELECT SINGLE billingquantity
      FROM i_billingdocumentitem
      WHERE billingdocument     = @billingdocument
        AND billingdocumentitem = @billingdocumentitem
      INTO @lv_billqty.

    SELECT SINGLE *
      FROM i_materialdocumentitem_2
      WHERE material = @product
        AND plant   = @plant
        AND batch   = @batch
        AND goodsmovementtype = '101'
        AND orderid <> ''
      INTO @DATA(ls_mat).

    IF sy-subrc EQ 0.

      SELECT *
      FROM i_accountingdocumentjournal
      WHERE orderid = @ls_mat-orderid
      AND ledger = '0L'
      AND accountingdocumenttype <> 'SA'
      INTO TABLE @DATA(ls_acc).

      orderid = ls_mat-orderid.

      SELECT *
      FROM i_billingdocumentitemprcgelmnt
      WHERE billingdocument     = @billingdocument
        AND billingdocumentitem = @billingdocumentitem
      INTO TABLE @DATA(lt_pricing).

      LOOP AT lt_pricing INTO DATA(ls_price).

        CASE ls_price-conditiontype.

          WHEN 'ZFMS' OR 'ZFRB' OR 'ZKF0'.
            freight += ls_price-conditionamount.

        ENDCASE.

      ENDLOOP.

      IF lv_billqty IS NOT INITIAL.
        freight = freight / lv_billqty.
      ENDIF.

      LOOP AT ls_acc INTO DATA(wa_acc) .

        cogm += wa_acc-debitamountincocodecrcy.

        IF wa_acc-offsettingaccounttype = 'M'.
          rmcost += wa_acc-debitamountincocodecrcy.
        ENDIF.

        IF wa_acc-offsettingaccounttype = 'S'.

          CASE wa_acc-partnercostctractivitytype.

            WHEN 'ZFOH' OR 'ZFOMDR'.
              fixedoverhead += wa_acc-debitamountincocodecrcy.

            WHEN 'ZLAB'.
              labour += wa_acc-debitamountincocodecrcy.

            WHEN 'ZAUX'.
              aux_power += wa_acc-debitamountincocodecrcy.

            WHEN 'ZPOW'.
              power += wa_acc-debitamountincocodecrcy.

          ENDCASE.
        ENDIF.

        IF wa_acc-creditamountincocodecrcy IS NOT INITIAL
        AND wa_acc-material <> product.

          cogm += wa_acc-creditamountincocodecrcy.
          scrap += wa_acc-creditamountincocodecrcy.

        ENDIF.

        CLEAR wa_acc.
      ENDLOOP.


      IF ls_mat-quantityinbaseunit IS NOT INITIAL.
        cogm = cogm / ls_mat-quantityinbaseunit.
        scrap = scrap / ls_mat-quantityinbaseunit.
        rmcost = rmcost / ls_mat-quantityinbaseunit.
        fixedoverhead = fixedoverhead / ls_mat-quantityinbaseunit.
        labour = labour / ls_mat-quantityinbaseunit.
        aux_power = aux_power / ls_mat-quantityinbaseunit.
        power = power / ls_mat-quantityinbaseunit.
        overhead = fixedoverhead + labour + aux_power + power.
        variableoverhead = overhead - fixedoverhead.
      ENDIF.

    ELSE.

      SELECT SINGLE *
      FROM i_materialdocumentitem_2
      WHERE material = @product
      AND batch = @batch
      AND plant = @plant
      AND goodsmovementtype = '101'
      AND purchaseorder NE ' '
      INTO @DATA(ls_sto).

      SELECT *
      FROM i_billingdocumentitemprcgelmnt
      WHERE billingdocument     = @billingdocument
        AND billingdocumentitem = @billingdocumentitem
      INTO TABLE @DATA(lt_prcg).

      LOOP AT lt_prcg INTO DATA(ls_prc).

        CASE ls_prc-conditiontype.

          WHEN 'ZFMS' OR 'ZFRB' OR 'ZKF0'.
            freight += ls_prc-conditionamount.

        ENDCASE.

      ENDLOOP.

      IF lv_billqty IS NOT INITIAL.
        freight = freight / lv_billqty.
      ENDIF.

      SELECT SINGLE *
      FROM ztb_cogm_pb
      WHERE deliverynote = @ls_sto-deliverydocument
      AND product = @product
      AND batch = @batch
      INTO @DATA(wa_tb_cogm).

      cogm          = wa_tb_cogm-cogm + wa_tb_cogm-freight.
      scrap         = wa_tb_cogm-scrap.
      rmcost        = wa_tb_cogm-rmcost.
      fixedoverhead = wa_tb_cogm-fixedoverhead.
      labour        = wa_tb_cogm-labour.
      aux_power     = wa_tb_cogm-aux_power.
      power         = wa_tb_cogm-power.

      overhead         = fixedoverhead + labour + aux_power + power.
      variableoverhead = overhead - fixedoverhead.
      orderid          = wa_tb_cogm-orderid.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
