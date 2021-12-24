import 'package:flutter/widgets.dart';
import 'package:pokedex/result_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'modals/pokemon.dart';
import 'result_name.dart';

import 'package:flutter/material.dart';
class Search extends StatefulWidget{
  List<Pokemon> pokemons ;
  Search({required this.pokemons}){
  }
  @override _Search createState() {
    return _Search();
  }

}

class _Search extends State<Search>{
  bool mode=false;
  late SharedPreferences prefs;
  late String name_pokemon="";
  TextEditingController contr= new TextEditingController();

  Color textColor=Colors.grey[800]!;
  Color backgroundColor=Colors.white;
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


  List<String> types=["Normal","Feu","Eau","Plante","Électrik","Glace",
    "Combat","Poison","Sol","Vol","Psy","Insecte","Roche","Spectre","Dragon"];
  String type="Normal";
  @override
  Widget build(BuildContext context) {
    initState();

    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      appBar: AppBar(title: Text("Pokédex",
      ),
      ),
      body:
        Column(
          children: [

            Text("Nom du Pokémon",
              style: TextStyle(
                  color: textColor
              ),
            ),
            TextField(
              controller: contr,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textColor
                    )
                  )
                ),
              ),
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultName(name: contr.text.toString(),pokemons: widget.pokemons,)));
            },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("Recherche par nom"),
            ),
            Theme(
              data: ThemeData(
                canvasColor: backgroundColor
              ),
              child: DropdownButton<String>(
                value: type,
                  onChanged: (s){
                  type=s.toString();
                  },
                  items: types.map<DropdownMenuItem<String>>(
                      (value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(color: textColor),));
                      }).toList()),
            ),
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultType(type:type, pokemons: widget.pokemons,)));
            },
              color: Colors.red,
              textColor: Colors.white,
              child: Text("Recherche par type"),
            ),

          ],
      ),
    );
  }

}