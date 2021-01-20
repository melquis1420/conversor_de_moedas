/* before importing the libraries, you need to include the HTTP package in the project
* enter the pubspec.lock file
* below cupertino_icons ^ 0.1.2 add:
* http: ^ 0.12.0 + 2 and click on packages get
 */

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=3a10ae68";

void main()async{
  runApp(MaterialApp(
  home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
      )),
  ));

}


/*Make the request
 * In the API and return a Json.
 * Do not forget to put async, as a future action.
 * "await" waits for the data to arrive.
 * Takes the body from the Json file and transforms it into a Map.
 */
Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);

}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//Controladores dos campos
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();



  double dolar;
  double euro;

  /* Converts reais to dollars and euros.
   * Check if the fields are empty.
   * If they are, delete the other 2 fields.
   */
  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real= double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text= (real/euro).toStringAsFixed(2);

  }

  /* Converts dollars to reais and euros.
   * Check if the fields are empty.
   * If they are, delete the other 2 fields.
   */

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text= (dolar * this.dolar).toStringAsFixed(2);
    euroController.text= (dolar*this.dolar/euro).toStringAsFixed(2);


  }

  /* Converts euros to dollars and reais.
   * Check if the fields are empty.
   * If they are, delete the other 2 fields.
   */

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text=(euro*this.euro).toStringAsFixed(2);
    dolarController.text=(euro*this.euro/dolar).toStringAsFixed(2);


  }

//Clears all fields.
  void _clearAll(){
    realController.text="";
    dolarController.text="";
    euroController.text="";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,

      ),


    /* Body returns a Map because JSon will return a Map.body:
     * Uses the snapshot to check the connection status and return
     * loading data or loading error, depending on status.
     */

      body: FutureBuilder<Map>(
        future:getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25.0),
                  textAlign: TextAlign.center,)
                );
            default:
              if (snapshot.hasError){
                return Center(
                    child: Text("Erro ao Carregar Dados...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,)
                );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:<Widget> [
                        Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dolares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged),
                      ],
                    ),
                  );
              }
              }
          }
        ),

    );
  }
}

  /*
   * Build the fields to fill
   * You must pass the field name, the prefix, the controller and
   * the conversion function it must perform.
   */
Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color:Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}


