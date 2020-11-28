import 'package:entregable_2/models/artist.dart';
import 'package:entregable_2/stats/item_artist.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class ArtistList extends StatefulWidget {
  final List<Artist> artists;
  ArtistList({Key key, @required this.artists}) : super(key: key);

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  TextEditingController searchController = TextEditingController();
  List<Artist> _artistsList = [];
  @override
  void initState() {
    _artistsList.clear();
    _artistsList.addAll(widget.artists);    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Buscar',
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (String text){
                  _searchArtists();
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _artistsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemArtist(artist: _artistsList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchArtists(){
    if(searchController.text == ""){
      _artistsList.clear();
      _artistsList.addAll(widget.artists);
    }else{
      if(_artistsList.isNotEmpty){
        _artistsList.clear();
      }

      for (int index=0;index<widget.artists.length;index++) {
        Artist _newSong = widget.artists[index];

        if(_newSong.artistName.contains(searchController.text)){
          _artistsList.add(_newSong);
        }
      }
    }   
  }  

}


