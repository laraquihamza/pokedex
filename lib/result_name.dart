import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/modals/PokemonResponse.dart';
import 'package:pokedex/pokemon_fiche.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../search.dart';
import 'modals/pokemon.dart';

class ResultName extends StatefulWidget {
  List<Pokemon> pokemons;
  String name="";
  ResultName({required this.pokemons, required this.name}) {
  }


  @override
  _ResultName createState() {
    return _ResultName();
  }
}

class _ResultName extends State<ResultName> {
  _ResultName(){
  }
  bool mode=false;
  late SharedPreferences prefs;
  Color backgroundColor=Colors.white;
  Color textColor=Colors.black;
  List<Pokemon> filtered=[];
  Future<Null> get_preferences()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      mode=prefs.getBool("mode")!;
      backgroundColor=mode?Colors.grey[800]!:Colors.white;
      textColor=mode?Colors.white:Colors.grey[800]!;

    });

  }
  void initState(){
    get_preferences().whenComplete((){
      setState(() {

      });
    }
    );
    filtered=PokemonResponse().filter_by_name(widget.pokemons, widget.name);

  }

  @override
  Widget build(BuildContext context) {
    initState();
    return      Scaffold(
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
                      mode=b;
                      backgroundColor=b?Colors.grey[800]!:Colors.white;
                      textColor=b?Colors.white:Colors.grey[800]!;
                      prefs.setBool("mode", b);
                    });
                  },

                  tileColor: Colors.red,
                ),
              ],
            )
        ),
      ),
      appBar: AppBar(
        title: Text("Recherche"),
      ),
      resizeToAvoidBottomInset: false,
      body:
      filtered.length==0?
      Center(
        child: Text("Aucun résultat :/",style: TextStyle(color: textColor),),
      )
          :ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context,index){
            var pokemon=filtered[index];
            print("pokepok${widget.name}");
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

          })
    );

  }
}
