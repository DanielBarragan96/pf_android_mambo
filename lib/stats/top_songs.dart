import 'package:entregable_2/colors.dart';
import 'package:entregable_2/models/track.dart';
import 'package:entregable_2/stats/item_song.dart';
import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  final List<Track> songs;
  SongList({Key key, @required this.songs}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  TextEditingController searchController = TextEditingController();
  List<Track> _songsList = [];

  @override
  void initState() {
    _songsList.clear();
    _songsList.addAll(widget.songs);    
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
                  _searchSongs();
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _songsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemSong(song: _songsList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchSongs(){
    if(searchController.text == ""){
      _songsList.clear();
      _songsList.addAll(widget.songs);
    }else{
      if(_songsList.isNotEmpty){
        _songsList.clear();
      }

      for (int index=0;index<widget.songs.length;index++) {
        Track _newSong = widget.songs[index];

        if(_newSong.trackName.contains(searchController.text)){
          _songsList.add(_newSong);
        }
      }
    }   
  }  
}
