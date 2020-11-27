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
              ),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchController.text == ""?
                  widget.songs.length:
                  _searchSongs().length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemSong(
                    song: searchController.text == ""?
                      widget.songs[index]:
                      _searchSongs()[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Track> _searchSongs(){
    List<Track> newList;

    for (int index=0;index<widget.songs.length;index++) {
      if(widget.songs[index].trackName.contains(searchController.text)){
        newList.add(widget.songs[index]);
      }
    }   

    return newList;
  }
}
