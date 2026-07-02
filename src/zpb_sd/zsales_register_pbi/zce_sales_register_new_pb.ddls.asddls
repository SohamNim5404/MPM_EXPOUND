//@ObjectModel: {
//query: {
//   implementedBy: 'ABAP:ZCL_SALES_REGISTER_NEW'
//}
//}
//@UI.headerInfo: { typeName: 'Sales Register' ,
//                  typeNamePlural: 'Sales Register' }
//
//@EndUserText.label: 'Projection for sales register'
//define custom entity ZCE_SALES_REGISTER_NEW_PB
//{
//
//      @UI.facet                    : [{ id : 'Vbeln',
//                purpose            : #STANDARD,
//                type               : #IDENTIFICATION_REFERENCE,
//                label              : 'Sales Register',
//                position           : 10 },
//
//                { id               : 'fkdat',
//                purpose            : #STANDARD,
//                type               : #IDENTIFICATION_REFERENCE,
//                label              : 'Billing Date',
//                position           : 20 },
//
//                 { id              : 'bukrs',
//                purpose            : #STANDARD,
//                type               : #IDENTIFICATION_REFERENCE,
//                label              : 'Company Code',
//                position           : 30 }
//                ]
//
//      @UI.selectionField           : [{position: 10 }]
//      @UI.lineItem                 : [{label: 'Billing Date', position: 10 ,importance: #HIGH }]
//      @UI.identification           : [{ position: 10 }]
//  key fkdat                        : datum;
//
//      @UI.selectionField           : [{position: 20 }]
//      @UI.lineItem                 : [{label: 'Company Code', position: 20 ,importance: #HIGH }]
//      @UI.identification           : [{ position: 20 }]
//  key bukrs                        : bukrs;
//
//      @UI.selectionField           : [{position: 30 }]
//      @UI.lineItem                 : [{label: 'Sold To Party', position: 30 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Sold To Party', position: 30 }]
//      @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_Customer' ,element: 'Customer' } }]
//  key sold_to                      : kunnr;
//
//      @UI.lineItem                 : [{label: 'Sold To Party Name', position: 40 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Sold To Party Name', position: 40 }]
//  key sold_to_nm                   : abap.char(40);
//
//      @UI.selectionField           : [{position: 50 }]
//      @UI.lineItem                 : [{label: 'Plant', position: 50 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Plant', position: 50 }]
//  key werks                        : werks_d;
//
//      @UI.selectionField           : [{ position: 60 }]
//      @UI.lineItem                 : [{label: 'Billing Doc', position: 60 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Billing Doc', position: 60 }]
//      @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_BillingDocument' ,element: 'BillingDocument' } }]
//      @EndUserText.label           : 'Billing Document'
//  key vbeln                        : vbeln;
//
//      @UI.selectionField           : [{position: 70 }]
//      @UI.lineItem                 : [{label: 'Billing Type', position: 70 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Billing Type', position: 70 }]
//  key fkart                        : fkart;
//
//      @UI.lineItem                 : [{label: 'Billing Item', position: 80 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Billing Item', position: 80 }]
//  key posnr                        : posnr;
//
//      @UI.lineItem                 : [{label: 'Delivery No', position: 90 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Delivery No', position: 90 }]
//      vbeln_d                      : vbeln;
//
//      @UI.lineItem                 : [{label: 'Delivery Item', position: 100 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Delivery Item', position: 100 }]
//      posnr_d                      : posnr;
//
//      @UI.lineItem                 : [{label: 'SO No', position: 110 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'SO No', position: 110 }]
//      vbeln_s                      : vbeln;
//
//      @UI.lineItem                 : [{label: 'SO Item', position: 120 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'SO Item', position: 120 }]
//      posnr_s                      : posnr;
//
//      @UI.lineItem                 : [{label: 'Ship To Party', position: 130 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Ship To Party', position: 130 }]
//      shipto                       : kunnr;
//
//      @UI.lineItem                 : [{label: 'Ship To Party Name', position: 140 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Ship To Party Name', position: 140 }]
//      shiptonm                     : abap.char(40);
//
//      @UI.lineItem                 : [{label: 'Bill To Party', position: 150 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Bill To Party', position: 150 }]
//      billto                       : kunnr;
//
//      @UI.lineItem                 : [{label: 'Bill To Party Name', position: 160 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Bill To Party Name', position: 160 }]
//      billtonm                     : abap.char(40);
//
//      @UI.lineItem                 : [{label: 'Payer', position: 170 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Payer', position: 170 }]
//      payer                        : kunnr;
//
//      @UI.lineItem                 : [{label: 'Payer Name', position: 180 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Payer Name', position: 180 }]
//      payernm                      : abap.char(40);
//
//      @UI.lineItem                 : [{label: 'GSTIN', position: 190 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'GSTIN', position: 190 }]
//      gstin                        : stcd3;
//
//      @UI.lineItem                 : [{label: 'Supplying Plant GSTIN', position: 195 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'GSTIN', position: 195 }]
//      gstin1                       : stcd3;
//
//      @UI.lineItem                 : [{label: 'Material Code', position: 200 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Material Code', position: 200 }]
//      matnr                        : matnr;
//
//      @UI.lineItem                 : [{label: 'Material Description', position: 210 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Material Description', position: 210 }]
//      maktx                        : maktx;
//
//      @UI.lineItem                 : [{label: 'Material Grp', position: 220 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Material Grp', position: 220 }]
//      MATERIALGROUP                : abap.char(20);
//
//      @UI.lineItem                 : [{label: 'UoM', position: 230 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'UoM', position: 230 }]
//      uom                          : meins;
//
//      @UI.lineItem                 : [{label: 'Billing Qty', position: 240 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Billing Qty', position: 240 }]
//      @Semantics.quantity.unitOfMeasure : 'uom'
//      fkimg                        : menge_d;
//
//      @UI.lineItem                 : [{label: 'Currency', position: 250 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Currency', position: 250 }]
//      // @UI.hidden: true
//      currency                     : waers;
//
//      @UI.lineItem                 : [{label: 'Exchange Rate', position: 260 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Exchange rate', position: 260 }]
//      KURRF                        : abap.char(20);
//
//      @UI.lineItem                 : [{label: 'Rate', position: 270 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Rate', position: 270 }]
//      @Semantics.amount.currencyCode : 'currency'
//      rate                         : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Net Value', position: 280 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Net Valye', position: 280 }]
//      @Semantics.amount.currencyCode : 'currency'
//      netvalue                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Tax', position: 290 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Tax', position: 290 }]
//      @Semantics.amount.currencyCode : 'currency'
//      tax                          : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Transporter Freight', position: 300 ,importance: #HIGH }]
//      @UI.identification           : [{label: 'Transporter Freight', position: 300 }]
//      @Semantics.amount.currencyCode : 'currency'
//      trfreight                    : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Markup Value', position: 310 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Markup Value', position: 310 }]
//      @Semantics.amount.currencyCode : 'currency'
//      markupvalue                  : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Total Value', position: 320 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Total Value', position: 320 }]
//      @Semantics.amount.currencyCode : 'currency'
//      totalvalue                   : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'CGST %', position: 330 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'CGST %', position: 330 }]
//      @Semantics.amount.currencyCode : 'currency'
//      cgstperc                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'CGST Value', position: 340 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'CGST Value', position: 340 }]
//      @Semantics.amount.currencyCode : 'currency'
//      cgstvalue                    : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'SGST %', position: 350 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'SGST %', position: 350 }]
//      @Semantics.amount.currencyCode : 'currency'
//      sgstperc                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'SGST Value', position: 360 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'SGST Value', position: 360 }]
//      @Semantics.amount.currencyCode : 'currency'
//      sgstvalue                    : abap.curr(10,2);
//
//
//      @UI.lineItem                 : [{label: 'UGST %', position: 370 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'UGST %', position: 370 }]
//      @Semantics.amount.currencyCode : 'currency'
//      ugstperc                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'UGST Value', position: 380 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'UGST Value', position: 380 }]
//      @Semantics.amount.currencyCode : 'currency'
//      ugstvalue                    : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'IGST %', position: 390 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'IGST %', position: 390 }]
//      @Semantics.amount.currencyCode : 'currency'
//      igstperc                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'IGST Value', position: 400 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'IGST Value', position: 400 }]
//      @Semantics.amount.currencyCode : 'currency'
//      igstvalue                    : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'TCS Value', position: 410 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'TCS Value', position: 410 }]
//      @Semantics.amount.currencyCode : 'currency'
//      tcsvalue                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'RoundOff', position: 420 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'RoundOff', position: 420 }]
//      @Semantics.amount.currencyCode : 'currency'
//      roundoff                     : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Profit center', position: 430 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Profit center', position: 430 }]
//      PROFITCENTER                 : abap.char(20);
//
//      @UI.lineItem                 : [{label: 'Cocd Currency', position: 430 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Cocd Currency', position: 430 }]
//      @UI.hidden                   : true
//      companycodecurrency          : waers;
//
//      @UI.lineItem                 : [{label: 'Net Amount in INR', position: 440 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Net Amount in INR', position: 440 }]
//      @Semantics.amount.currencyCode : 'companycodecurrency'
//      amt_inr                      : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Tax in INR', position: 450 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Tax in INR', position: 450 }]
//      @Semantics.amount.currencyCode : 'companycodecurrency'
//      tax_inr                      : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Total Value in INR', position: 460 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Total Value in INR', position: 460 }]
//      @Semantics.amount.currencyCode : 'companycodecurrency'
//      tot_inr                      : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Sales organization', position: 470 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Sales org', position: 470 }]
//      salesorganization            : abap.char(4);
//
//      @UI.lineItem                 : [{label: 'Distribution channel', position: 480 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Distribution channel', position: 480 }]
//      DISTRIBUTIONCHANNEL          : abap.char(4);
//
//      @UI.lineItem                 : [{label: 'Division', position: 490 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Division', position: 490 }]
//      DIVISION                     : abap.char(3);
//
//
//      @UI.lineItem                 : [{label: 'Insurance', position: 500 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Insurance', position: 500 }]
//      @Semantics.amount.currencyCode : 'currency'
//      insurance                    : abap.curr(10,2);
//
//      @UI.lineItem                 : [{label: 'Destination country', position: 510 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Sales org', position: 510 }]
//      country                      : abap.char(4);
//
//      @UI.lineItem                 : [{label: 'Incoterms', position: 520 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Incoterms', position: 520 }]
//      incotermsclassification      : abap.char(4);
//
//      @UI.lineItem                 : [{label: 'Payment terms', position: 530 ,importance: #HIGH }]
//      @UI.identification           : [{ label:'Payment terms', position: 530 }]
//      customerpaymentterms         : abap.char(10);
//
//      @UI.lineItem                 : [{label: 'Plant Region', position: 540 ,importance: #HIGH }]
//      @UI.identification           : [{ label:'Plant Region', position: 540 }]
//      pregion                      : abap.char(20);
//
//      @UI.lineItem                 : [{ label: 'Journal entry no', position: 860, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Journal entry no', position: 860 }]
//      journalentry_no              : abap.char(20);
//
//      @UI.lineItem                 : [{ label: 'Jounral entry date', position: 870, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Jounral entry date', position: 870 }]
//      journalentry_dt              : abap.dats;
//
//      @UI.lineItem                 : [{ label: 'Customer PO Supplement', position: 890, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Customer PO Supplement', position: 890 }]
//      CustomerPurchaseOrderSuplmnt : abap.char(35);
//
//      @UI.lineItem                 : [{ label: 'Customer PO Date', position: 900, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Customer PO Date', position: 900 }]
//      CustomerPurchaseOrderDate    : abap.dats;
//
//      @UI.lineItem                 : [{ label: 'Discount Amount', position: 930, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Discount Amount', position: 930 }]
//      @Semantics.amount.currencyCode : 'currency'
//      discount                     : abap.curr(16,2);
//
//      @UI.lineItem                 : [{ label: 'Free of Charge Amount', position: 950, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Free of Charge Amount', position: 950 }]
//      @Semantics.amount.currencyCode : 'currency'
//      freeofcharge                 : abap.curr(16,2);
//
//      @UI.lineItem                 : [{ label: 'Freight', position: 970, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Freight', position: 970 }]
//      @Semantics.amount.currencyCode : 'currency'
//      freight                      : abap.curr(16,2);
//
//      @UI.lineItem                 : [{ label: 'HSN Code', position: 1170, importance: #HIGH }]
//      @UI.identification           : [{ label: 'HSN Code', position: 1170 }]
//      consumptiontaxctrlcode       : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Shipping Bill No.', position: 1210, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Shipping Bill No.', position: 1210 }]
//      SHBILL                       : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Shipping Bill Date', position: 1220, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Shipping Bill Date.', position: 1220 }]
//      SHBILLDT                     : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Port Code', position: 1230, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Port Code', position: 1230 }]
//      PCODE                        : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Transporter Name', position: 1240, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Transporter Name', position: 1240 }]
//      TNAME                        : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Vehicle No.', position: 1250, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Vehicle No.', position: 1250 }]
//      VNO                          : abap.char(12);
//
//      @UI.lineItem                 : [{ label: 'Bill to Party Address.', position: 1260, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Bill to Party Address.', position: 1260 }]
//      BILLPADD                     : abap.char(70);
//
//      @UI.lineItem                 : [{ label: 'Cust. Region.', position: 1270, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Cust. Region.', position: 1270 }]
//      CUSTR                        : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Cust. Ref..', position: 1300, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Cust. Ref..', position: 1300 }]
//      CUSTref                      : abap.char(50);
//
//      @UI.lineItem                 : [{ label: 'Cust.Ref.Date.', position: 1310, importance: #HIGH }]
//      @UI.identification           : [{ label: 'Cust.Ref.Date.', position: 1310 }]
//      CUSTRdt                      : abap.char(10);
//
//      @UI.lineItem                 : [{label: 'Distribution Channel Name', position: 1410 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Distribution Channel Name', position: 1410 }]
//      DistributionChannelName      : abap.char(50);
//
//      @UI.lineItem                 : [{label: 'Billing Type Name', position: 1420 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Billing Type Name', position: 1420 }]
//      BillingDocumentTypeName      : abap.char(50);
//
//      @UI.lineItem                 : [{label: 'Material Type', position: 1430 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Material Type', position: 1430 }]
//      MaterialType                 : abap.char(50);
//
//      @UI.lineItem                 : [{label: 'Material Type Name', position: 1440 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Material Type Name', position: 1440 }]
//      MaterialTypeName             : abap.char(50);
//
//      @UI.lineItem                 : [{label: 'Division Name', position: 1450 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Division Name', position: 1450 }]
//      DivisionName                 : abap.char(50);
//
//      @UI.lineItem                 : [{label: 'E-Way Bill No', position: 1460 ,importance: #HIGH }]
//      @UI.identification           : [{label: 'E-Way Bill No', position: 1460 }]
//      EWayBill                     : zew_j_1ig_ebillno;
//
//      @UI.lineItem                 : [{label: 'Batch', position: 1470 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Batch', position: 1470 }]
//      batch                        : abap.char(10);
//
//      @UI.lineItem                 : [{label: 'Customer Account Group', position: 1480 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Customer Account Group', position: 1480 }]
//      accountgroup                 : abap.char(4);
//
//      @UI.lineItem                 : [{label: 'Account Group Name', position: 1490 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Account Group Name', position: 1490 }]
//      accountgroupname             : abap.char(50);
//
//      @UI.lineItem                 : [{label: 'IRN No', position: 1500 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'IRN No', position: 1500 }]
//      IrnNo                        : zei_j_1ig_irn;
//
//      @UI.lineItem                 : [{label: 'Industry', position: 1510 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Industry', position: 1510 }]
//      industry                     : abap.char(10);
//
//      @UI.lineItem                 : [{label: 'Industry Description', position: 1520 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Industry Description', position: 1520 }]
//      industrydescription          : abap.char(100);
//
//      @UI.lineItem                 : [{label: 'COGM', position: 1530 ,importance: #HIGH }]
//      @UI.identification           : [{label: 'COGM', position: 1530 }]
//      COGM                         : abap.dec(23,2);
//
//      @UI.lineItem                 : [{label: 'RM Cost', position: 1540 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'RM Cost', position: 1540 }]
//      RMCost                       : abap.dec(23,2);
//
//      @UI.lineItem                 : [{label: 'Overhead', position: 1550 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Overhead', position: 1550 }]
//      Overhead                     : abap.dec(23,2);
//
//      @UI.lineItem                 : [{label: 'Scrap', position: 1560 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Scrap', position: 1560 }]
//      Scrap                        : abap.dec(23,2);
//      
//      @UI.lineItem                 : [{label: 'Sales Office', position: 1570 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Sales Office', position: 1570 }]
//      SalesOffice                  : abap.char(50);
//      
//      @UI.lineItem                 : [{label: 'Sales Group', position: 1580 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Sales Group', position: 1580 }]
//      SalesGroup                  : abap.char(50);
//}
@ObjectModel: {
  query: {
    implementedBy: 'ABAP:ZCL_SALES_REGISTER_NEW_PB'
  }
}
@UI.headerInfo: {
  typeName: 'Sales Register',
  typeNamePlural: 'Sales Register'
}
@EndUserText.label: 'Sales Register from Excel'
define custom entity ZCE_SALES_REGISTER_NEW_PB
{

  
      @UI.facet                    : [{ id : 'Vbeln',
                purpose            : #STANDARD,
                type               : #IDENTIFICATION_REFERENCE,
                label              : 'Sales Register',
                position           : 10 },

                { id               : 'fkdat',
                purpose            : #STANDARD,
                type               : #IDENTIFICATION_REFERENCE,
                label              : 'Billing Date',
                position           : 20 },

                 { id              : 'bukrs',
                purpose            : #STANDARD,
                type               : #IDENTIFICATION_REFERENCE,
                label              : 'Company Code',
                position           : 30 }
                ]

  @UI.selectionField: [{ position: 10 }]
  @UI.lineItem: [{ label: 'Billing Document', position: 10, importance: #HIGH }]
  @UI.identification: [{ position: 10 }]
    @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_BillingDocument' ,element: 'BillingDocument' } }]
  key vbeln : vbeln;

  @UI.selectionField: [{ position: 20 }]
  @UI.lineItem: [{ label: 'Billing Date', position: 20, importance: #HIGH }]
  @UI.identification: [{ position: 20 }]
  key fkdat : datum;
  
   @UI.selectionField: [{ position: 60 }]
  @UI.lineItem: [{ label: 'Company Code', position: 60, importance: #HIGH }]
  @UI.identification: [{ position: 60 }]
  key bukrs : bukrs;

  @UI.selectionField: [{ position: 30 }]
  @UI.lineItem: [{ label: 'Item', position: 30, importance: #HIGH }]
  @UI.identification: [{ position: 30 }]
  key posnr : posnr;

  @UI.selectionField: [{ position: 40 }]
  @UI.lineItem: [{ label: 'Billing Type', position: 40, importance: #HIGH }]
  @UI.identification: [{ position: 40 }]
  key fkart : abap.char(4);
  
    @UI.selectionField: [{ position: 100 }]
  @UI.lineItem: [{ label: 'Sold-to Party', position: 100, importance: #HIGH }]
  @UI.identification: [{ position: 100 }]
  @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_Customer' ,element: 'Customer' } }]
  key sold_to : kunnr;

  @UI.lineItem: [{ label: 'Name', position: 110, importance: #HIGH }]
  @UI.identification: [{ position: 110 }]
  key sold_to_nm : abap.char(100);
  
    @UI.selectionField: [{ position: 190 }]
  @UI.lineItem: [{ label: 'Plant', position: 190, importance: #HIGH }]
  @UI.identification: [{ position: 190 }]
  key werks : werks_d;
  
  
//   @UI.lineItem                 : [{label: 'Billing Type Name', position: 50 ,importance: #HIGH }]
//      @UI.identification           : [{ label: 'Billing Type Name', position: 50 }]
//      BillingDocumentTypeName      : abap.char(50);

  @UI.lineItem: [{ label: 'Invoice Type', position: 51, importance: #HIGH }]
   @UI.identification           : [{ label: 'Invoice Type ', position: 51 }]
  InvoiceType : abap.char(50);

 

  @UI.selectionField: [{ position: 70 }]
  @UI.lineItem: [{ label: 'Sales ', position: 70, importance: #HIGH }]
  @UI.identification: [{ position: 70 }]
  salesorganization : abap.char(4);

//  @UI.lineItem: [{ label: 'Cancelled Bill.Doc.', position: 80, importance: #LOW }]
//  @UI.identification: [{ position: 80 }]
//  cancelled_bill_doc : abap.char(20);

  @UI.selectionField: [{ position: 90 }]
  @UI.lineItem: [{ label: 'Ship-to Party', position: 90, importance: #HIGH }]
  @UI.identification: [{ position: 90 }]
  shipto : kunnr;



  @UI.lineItem: [{ label: 'Sales Office', position: 120, importance: #HIGH }]
  @UI.identification: [{ position: 120 }]
  salesoffice : abap.char(20);

  @UI.lineItem: [{ label: 'Desc Sales Off', position: 130, importance: #HIGH }]
  @UI.identification: [{ position: 130 }]
  desc_sales_off : abap.char(50);

  @UI.selectionField: [{ position: 140 }]
  @UI.lineItem: [{ label: 'Material', position: 140, importance: #HIGH }]
  @UI.identification: [{ position: 140 }]
  matnr : matnr;

  @UI.lineItem: [{ label: 'Description', position: 150, importance: #HIGH }]
  @UI.identification: [{ position: 150 }]
  maktx : abap.char(100);

  @UI.lineItem: [{ label: 'Batch', position: 160, importance: #HIGH }]
  @UI.identification: [{ position: 160 }]
  batch : abap.char(20);

  @UI.lineItem: [{ label: 'Ext. Material Group', position: 170, importance: #HIGH }]
  @UI.identification: [{ position: 170 }]
  materialgroup : abap.char(20);

  @UI.lineItem: [{ label: 'Sub- Mat. Group Text', position: 180, importance: #HIGH }]
  @UI.identification: [{ position: 180 }]
  sub_mat_group_text : abap.char(50);


  @UI.lineItem: [{ label: 'Billed Quantity', position: 200, importance: #HIGH }]
  @UI.identification: [{ position: 200 }]
  @Semantics.quantity.unitOfMeasure: 'uom'
  billed_quantity : abap.quan(13,3);

//  @UI.lineItem: [{ label: 'Item Category', position: 210, importance: #HIGH }]
//  @UI.identification: [{ position: 210 }]
//  item_category : abap.char(10);

  @UI.lineItem: [{ label: 'Purchase Order Number', position: 220, importance: #HIGH }]
  @UI.identification: [{ position: 220 }]
  customer_po_no : abap.char(35);

  @UI.lineItem: [{ label: 'Document Currency', position: 230, importance: #HIGH }]
  @UI.identification: [{ position: 230 }]
  currency : waers;

  @UI.lineItem: [{ label: 'Sales Unit', position: 240, importance: #HIGH }]
  @UI.identification: [{ position: 240 }]
  uom : meins;

  @UI.lineItem: [{ label: 'Ass. Value', position: 250, importance: #HIGH }]
  @UI.identification: [{ position: 250 }]
  @Semantics.amount.currencyCode: 'Currency'
  ass_value : abap.curr(16,2);

  @UI.lineItem: [{ label: 'Gross Value', position: 260, importance: #HIGH }]
  @UI.identification: [{ position: 260 }]
  @Semantics.amount.currencyCode: 'currency'
  gross_value : abap.curr(16,2);

  @UI.lineItem: [{ label: 'Unit Price', position: 270, importance: #HIGH }]
  @UI.identification: [{ position: 270 }]
  @Semantics.amount.currencyCode: 'currency'
  unit_price : abap.curr(16,2);

  @UI.lineItem: [{ label: 'Fiscal Year', position: 280, importance: #HIGH }]
  @UI.identification: [{ position: 280 }]
  fiscal_year : abap.numc(4);

  @UI.lineItem: [{ label: 'Posting Period', position: 290, importance: #HIGH }]
  @UI.identification: [{ position: 290 }]
  posting_period : abap.numc(3);

  @UI.lineItem: [{ label: 'Month', position: 300, importance: #HIGH }]
  @UI.identification: [{ position: 300 }]
  monthss : abap.char(20);

}
