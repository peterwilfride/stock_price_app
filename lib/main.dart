import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/stock_price?key=d9614ac5&symbol=";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

Future<Map> getData(String stockName) async {
  http.Response response = await http.get(Uri.parse(request+stockName));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final stockNameController = TextEditingController(text: "ALUP11");

  late String name;
  late double price;

  @override
  void dispose() {
    stockNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Stock Price"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),

      body: FutureBuilder<Map>(
        future: getData(stockNameController.text),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Erro ao carregar dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
              ));
            } else {
              name = snapshot.data!["results"][stockNameController.text]["company_name"];
              price = snapshot.data!["results"][stockNameController.text]["price"];
              print(name);
              print(price);
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: stockNameController,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.blue),
                            hintText: "Enter with stock symbol"
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text("Pesquisar")
                      ),
                    ]
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      const Text(
                        "name",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        )
                      ),
                      VerticalDivider(),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20
                        )
                      )
                    ]
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      const Text(
                        "price", 
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        )
                      ),
                      VerticalDivider(),
                      Text(
                        price.toString(),
                        style: const TextStyle(
                          fontSize: 20
                        )
                      )
                    ]
                  )
                ]
              ),
            );
          }
        }
      ),
    );
  }
}