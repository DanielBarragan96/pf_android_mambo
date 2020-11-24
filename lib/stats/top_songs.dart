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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: ListView.builder(
        itemCount: widget.songs.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemSong(song: widget.songs[index]);
        },
      ),
    );
  }
}
