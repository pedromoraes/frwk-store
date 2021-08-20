import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'products.dart';
import 'pages/login.dart';
import 'pages/checkout.dart';

void main() {
  runApp(App());
}

class Data {
  bool login = false;
  List cart = [];
}

final data = Data();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Framework Fruit Shop',
      home: StoreDisplay(title: 'Framework Fruit Shop'),
      routes: {
        '/login': (context) => loginPage(context, data),
        '/checkout': (context) => checkoutPage(context, data),
      },
    );
  }
}

class StoreDisplay extends StatefulWidget {
  StoreDisplay({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _StoreDisplayState createState() => _StoreDisplayState();
}

class _StoreDisplayState extends State<StoreDisplay> {
  var _dataset = products;

  void _add(product) {
    setState(() {
      data.cart.add(product);
    });
  }

  void _buy() {
    Navigator.pushNamed(context, data.login ? '/checkout' : '/login')
        .then((_) => setState(() {
              data.cart.clear();
            }));
  }

  void _refineSearch(String query) {
    setState(() {
      _dataset = query.isEmpty
          ? products
          : products
              .where(
                  (p) => p['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  Widget _checkoutButton() {
    return TextButton.icon(
        onPressed: () => _buy(),
        icon: Icon(Icons.shopping_bag),
        label: Text("(${data.cart.length}) Checkout"));
  }

  @override
  Widget build(BuildContext context) {
    var currencyFormatter = intl.NumberFormat.simpleCurrency();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: data.cart.length > 0 ? _checkoutButton() : null,
      body: Center(
          child: Column(children: [
        TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search products',
              isDense: true,
            ),
            onChanged: (e) => _refineSearch(e)),
        Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 30.0,
                ),
                padding: EdgeInsets.all(20.0),
                itemCount: _dataset.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.0),
                          borderRadius: BorderRadius.circular(0.85)),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_dataset[index]["name"]),
                              Text(currencyFormatter
                                  .format(products[index]["price"]))
                            ]),
                        Expanded(
                            child: Image(
                          image: AssetImage(_dataset[index]["img"]),
                          fit: BoxFit.fitHeight,
                        )),
                        TextButton(
                            onPressed: () => {_add(_dataset[index])},
                            child: Text('Buy'))
                      ]));
                }))
      ])),
    );
  }
}
