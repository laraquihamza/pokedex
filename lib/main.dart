 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/modals/PokemonResponse.dart';
import 'package:pokedex/pokemon_fiche.dart';
import 'modals/pokemon.dart';
import 'search.dart';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  bool mode=false;
  Color backgroundColor=Colors.white;
  Color textColor=Colors.black;
  late SharedPreferences prefs;
  List<Pokemon> pokemons=[];

  Future<Null> get_preferences()async{
    prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("mode")) {
        mode=false;
    }
    else{
      mode= prefs.getBool("mode")!;
    }

  }
  void get_pokemons()async{
    var temp=await PokemonResponse().get_pokemons();
    setState(() {
      pokemons=temp;
    });

  }
  void initState(){
    get_preferences();
    get_pokemons();

  }
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: Theme(
        data:Theme.of(context).copyWith(
          canvasColor: Colors.red,
        ),
        child: Drawer(
          child:ListView(
          children: [
            SwitchListTile(title: Text("Mode Sombre"),
              value: mode,
              onChanged: (b){
              setState(() {
                backgroundColor=b?Colors.grey[800]!:Colors.white;
                textColor=b?Colors.white:Colors.grey[800]!;
                prefs.setBool("mode", b);
                mode=b;

              });
              },

              tileColor: Colors.red,
            ),
          ],
          )
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body:
              ListView.builder(
                itemCount: pokemons.length,
                  itemBuilder: (context,index){
                  var pokemon=pokemons[index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PokemonFiche(pokemon: pokemon);
                      }));
                    },
                    child: Card(
                      color: backgroundColor,
                          child:  Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text(
                                  "#${pokemon.id} ${pokemon.nom.toUpperCase()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    color: textColor
                                  ),
                                ),
                                CachedNetworkImage(imageUrl: pokemon.image, placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                                imageBuilder: (context,imageProvider){
                                  return Image(image: imageProvider, width: MediaQuery.of(context).size.width*0.5,);
                                },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Column(
                                      children: [
                                        Text(
                                          pokemon.type2==""?"Type":"Types",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor
                                          ),
                                        ),
                                        Text(
                                          pokemon.type2==""?pokemon.type1: "${pokemon.type1} - ${pokemon.type2}",
                                          style: TextStyle(color: textColor),
                                        )
                                    ],
                                  ),
                                    Column(
                                      children: [
                                        Text(
                                          "Poids",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor
                                          ),
                                        ),
                                        Text(
                                            pokemon.poids,
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Taille",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor
                                          ),
                                        ),
                                        Text(
                                          pokemon.taille,
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Talent",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor
                                          ),
                                        ),
                                        Text(
                                          pokemon.talent,
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    )



                                  ]
                                )

                              ],
                            ),
                          )
                        ),
                  );

              }),

      floatingActionButton:   FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Search(pokemons:pokemons);
          }));
      },
        child: new Icon(Icons.search,
          color: Colors.white,),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.white,

      ),
      home: MyHomePage(title: 'Pokédex'),
    );
  }
}
