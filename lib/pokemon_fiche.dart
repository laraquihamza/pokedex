import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import "package:pokedex/modals/pokemon.dart";
import 'package:shared_preferences/shared_preferences.dart';
class PokemonFiche extends StatefulWidget {
  Pokemon pokemon;
  PokemonFiche({required this.pokemon});

  @override
  _PokemonFicheState createState() => _PokemonFicheState();
}

class _PokemonFicheState extends State<PokemonFiche> {
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

  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(widget.pokemon.nom),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Text(
              "#${widget.pokemon.id} ${widget.pokemon.nom.toUpperCase()}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: textColor
              ),
            ),
            CachedNetworkImage(imageUrl: widget.pokemon.image, placeholder: (context, url) => CircularProgressIndicator(),
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
                        widget.pokemon.type2==""?"Type":"Types",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor
                        ),
                      ),
                      Text(
                        widget.pokemon.type2==""?widget.pokemon.type1: "${widget.pokemon.type1} - ${widget.pokemon.type2}",
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
                        widget.pokemon.poids,
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
                        widget.pokemon.taille,
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
                        widget.pokemon.talent,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  )



                ]
            ),
            Text(
              "Description",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor
              ),
            ),
 Text(
                widget.pokemon.description,
                style: TextStyle(color: textColor,
                ),
                textAlign: TextAlign.start,
   textWidthBasis: TextWidthBasis.longestLine,
              ),


          ],
        ),
      ),
    );
  }
}
