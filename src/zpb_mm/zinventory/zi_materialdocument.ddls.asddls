@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MATERIALDOCUMENT
  as select from I_MaterialDocumentItem_2
  //left outer join ZI_MAT_AGEING  as CAL on  A.GoodsMovementType  = CAL.GoodsMovementType
  //                                        and A.Material   = CAL.Material

{
  key Material,
  key Plant,
  key StorageLocation,
      Batch,
      GoodsMovementType,
      DebitCreditCode,
      max(PostingDate)   as PostingDate,
      cast(
      case GoodsMovementType

        when '201' then 'Cost Center Issue'
        when '221' then 'Project Issue'
        when '261' then 'Production Order Issue'
        when '281' then 'Network Issue'
        when '551' then 'Scrapping'
        when '601' then 'Sales Delivery Issue'
        when '202' then 'Cost Center Issue'
        when '222' then 'Project Issue'
        when '262' then 'Production Order Issue'
        when '282' then 'Network Issue'
        when '552' then 'Scrapping'
        when '602' then 'Sales Delivery Issue'
         when '543' then 'SUBCON'


        else ' '

      end
      as abap.char(30) ) as ConsumptionType,

      cast(
        case GoodsMovementType

          when '122' then 'Return to Vendor'
          when '124' then 'Return Delivery Reversal'
          when '350' then 'Transfer to Blocked Stock'
          when '344' then 'Unrestricted to Blocked Stock'
          when '551' then 'Scrapping'
          when '553' then 'Scrap from Quality Stock'
           when '123' then 'Return to Vendor'
          when '125' then 'Return Delivery Reversal'
          when '351' then 'Transfer to Blocked Stock'
          when '345' then 'Unrestricted to Blocked Stock'
          when '552' then 'Scrapping'
          when '554' then 'Scrap from Quality Stock'
           when '653' then 'Return delivery'
             when '161' then 'Return Purchase order'
               when '702' then 'INVENTORY'

          else ' '

        end
      as abap.char(40) ) as RejectedStockType,

      cast(
        case GoodsMovementType

          when '101' then 'GR against Purchase Order'
          when '103' then 'GR into GR Blocked Stock'
          when '105' then 'Release from GR Blocked Stock'
          when '107' then 'GR into Valuated GR Blocked Stock'
          when '109' then 'Release from Valuated GR Blocked Stock'
          when '501' then 'Initial Stock Upload'
          when '511' then 'Free of Charge Receipt'
          when '521' then 'Receipt from Production Without Order'
          when '531' then 'Receipt from By-Product'
          when '561' then 'Initial Stock Entry'
          when '641' then 'STO'
          when '102' then 'GR against Purchase Order'
          when '104' then 'GR into GR Blocked Stock'
          when '106' then 'Release from GR Blocked Stock'
          when '108' then 'GR into Valuated GR Blocked Stock'
          when '110' then 'Release from Valuated GR Blocked Stock'
          when '502' then 'Initial Stock Upload'
          when '512' then 'Free of Charge Receipt'
          when '522' then 'Receipt from Production Without Order'
          when '532' then 'Receipt from By-Product'
          when '562' then 'Initial Stock Entry'
          when '642' then 'STO REVERSE'
          when '301' then 'Plant to PLant STO'


          else ' '

        end
      as abap.char(50) ) as ReceiptStockType
}
where
  TotalGoodsMvtAmtInCCCrcy <> 0
//     GoodsMovementType = '101'
//  or GoodsMovementType = '102'
//  or GoodsMovementType = '122'
//  or GoodsMovementType = '123'
//  or GoodsMovementType = '124'
//  or GoodsMovementType = '125'
//  or GoodsMovementType = '201'
//  or GoodsMovementType = '202'
//  or GoodsMovementType = '221'
//  or GoodsMovementType = '222'
//  or GoodsMovementType = '261'
//  or GoodsMovementType = '262'
//  or GoodsMovementType = '281'
//  or GoodsMovementType = '282'
//  or GoodsMovementType = '531'
//  or GoodsMovementType = '532'
//  or GoodsMovementType = '343'
//  or GoodsMovementType = '344'
//  or GoodsMovementType = '350'
//  or GoodsMovementType = '551'
//  or GoodsMovementType = '552'
//  or GoodsMovementType = '553'
//  or GoodsMovementType = '554'
//  or GoodsMovementType = '561'
//  or GoodsMovementType = '562'
//  or GoodsMovementType = '601'
//  or GoodsMovementType = '602'
//  or GoodsMovementType = '621'
//  or GoodsMovementType = '622'
group by
  Material,
  Plant,
  StorageLocation,
  Batch,
  DebitCreditCode,
  GoodsMovementType
