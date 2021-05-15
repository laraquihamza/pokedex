 import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Pokédex'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String myData="";
  List<Widget> lis=[];
  Future<Null> loaddata() async{
    myData = await rootBundle.loadString("assets/pokedex2.csv");
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(myData);
    print(rowsAsListOfValues.length+1);
    lis=[];
    for(int i=1; i<rowsAsListOfValues.length; i++){
      Column col_poke=new Column(
        children: [
          new Text(rowsAsListOfValues[i][1].toString().toUpperCase(),
          textScaleFactor: 1.5,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        new Image.network(rowsAsListOfValues[i][2],
            width: MediaQuery.of(context).size.width*0.5,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Column(
                children: [
                  new Text("Talent",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  new Text(rowsAsListOfValues[i][3]),
                ],
              ),
              new Column(
                children: [
                  new Text("Catégorie",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  new Text(rowsAsListOfValues[i][4]),
                ],
              ),
              new Column(
                children: [
                  new Text("Poids",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  new Text(rowsAsListOfValues[i][5]),
                ],
              ),
              new Column(
                children: [
                  new Text("Taille",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  new Text(rowsAsListOfValues[i][6]),
                ],
              ),
              new Column(
                children: [
                  new Text("Type 1",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  new Text(rowsAsListOfValues[i][9]),

                ],
              ),
              new Column(
                children: [
                  new Text("Type 2",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  new Text(rowsAsListOfValues[i][8]),

                ],
              ),

            ],
          ),
          new Column(
            children: [
              new Text("Description",
    style: TextStyle(
    fontWeight: FontWeight.bold
    )
              ),
              new Text(rowsAsListOfValues[i][7].replaceAll("     ","").replaceAll("\n","")),
            ],
          ),

        ],
      );
      Card car= new Card(
        child:col_poke
    );
      lis.add(car);
    }
  }
  Widget get_data(){
    return FutureBuilder(
        future: loaddata(),
        builder: (context,snapshot){
          return Column(
            children: lis,
          );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            get_data()
          ],
        ),
      ),
    );
  }
}
