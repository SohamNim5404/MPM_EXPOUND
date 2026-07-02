CLASS zbp_i_budget_hdr DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_budget_hdr.

  " This structure MUST match your Excel columns left-to-right perfectly.
  TYPES: BEGIN OF gty_gr_data,
           uniqueid           TYPE string,  " Column A
           custcat            TYPE string,  " Column B
           salesofficecode    TYPE string,  " Column C
           salesofficeloc     TYPE string,  " Column D
           salesgroup         TYPE string,  " Column E
           salesgrouptext     TYPE string,  " Column F
           custcode           TYPE string,  " Column G
           custname           TYPE string,  " Column H
           prodcode           TYPE string,  " Column I
           prodname           TYPE string,  " Column J
           monthintext        TYPE string,  " Column K
           monthinno          TYPE string,  " Column L
           projectedunitprice TYPE string,  " Column M
           projectioninqty    TYPE string,  " Column N
           projectioninvalue  TYPE string,  " Column O
           potential          TYPE string,  " Column P
           salesperson        TYPE string,  " Column Q
           segment            TYPE string,  " Column R
           productfamily      TYPE string,  " Column S
         END OF gty_gr_data.

ENDCLASS.



CLASS ZBP_I_BUDGET_HDR IMPLEMENTATION.



ENDCLASS.
