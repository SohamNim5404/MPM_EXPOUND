@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGM Data Definition PB'
@Metadata.allowExtensions: true
define root view entity ZCOGM_PB
  as select from ztb_cogm_pb
{
  key billingdocument     as Billingdocument,
  key billingdocumentitem as Billingdocumentitem,
  key plant               as Plant,
  key product             as Product,
  key batch               as Batch,
      orderid             as Orderid,
      deliverynote        as Deliverynote,
      freight             as Freight,
      cogm                as Cogm,
      scrap               as Scrap,
      rmcost              as Rmcost,
      overhead            as Overhead,
      fixedoverhead       as Fixedoverhead,
      labour              as Labour,
      aux_power           as AuxPower,
      power               as Power,
      variableoverhead    as Variableoverhead
}
