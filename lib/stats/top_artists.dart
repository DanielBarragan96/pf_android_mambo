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
                itemCount: widget.artists.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemArtist(artist: widget.artists[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


