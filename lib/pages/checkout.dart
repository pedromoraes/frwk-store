import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final currencyFormatter = intl.NumberFormat.simpleCurrency();

_getRows(List cart) {
  return cart.map((item) => item['id']).toSet().toList().map((p) {
    final items = cart.where((e) => e['id'] == p).toList();
    final price = currencyFormatter.format(items.length * items[0]['price']);
    return {"count": items.length, "name": items[0]["name"], "price": price};
  });
}

_finishOrder(data) async {
  final doc = pw.Document();
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
            child: pw.ListView(
                children: [pw.Text('Your order:')].cast<pw.Widget>() +
                    _getRows(data.cart)
                        .map((p) => pw.Text(
                            "${p['count']} ${p['name']}: ${p['price']} "))
                        .toList()
                        .cast<pw.Widget>() +
                    [
                      pw.Text('Total: ' +
                          currencyFormatter.format(
                              data.cart.fold(0, (a, b) => a + b['price'])))
                    ]));
      }));
  await Printing.sharePdf(bytes: await doc.save(), filename: 'order.pdf');
  data.cart.clear();
}

checkoutPage(BuildContext context, data) {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: ListView(
              itemExtent: 30.0,
              children: <Widget>[Text('Your order:')] +
                  _getRows(data.cart)
                      .map((p) =>
                          Text("${p['count']} ${p['name']}: ${p['price']} "))
                      .toList()
                      .cast<Widget>() +
                  [
                    Text('Total: ' +
                        currencyFormatter.format(
                            data.cart.fold(0, (a, b) => a + b['price']))),
                    TextButton(
                        onPressed: () async {
                          await _finishOrder(data);
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text('Finish & Print order'))
                  ].cast<Widget>())));
}
