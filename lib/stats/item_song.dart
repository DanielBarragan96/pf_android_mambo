import 'package:entregable_2/colors.dart';
import 'package:entregable_2/models/track.dart';
import 'package:flutter/material.dart';

class ItemSong extends StatelessWidget {
  final Track song;
  ItemSong({Key key, @required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Cambiar image.network por Extended Image con place holder en caso de error o mientras descarga la imagen
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          color: kLightBlack,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: (song.albumImageUrl == "" || song.albumImageUrl == null)
                    ? Placeholder(
                        color: Colors.purple,
                        fallbackHeight: 32,
                        fallbackWidth: 32,
                      )
                    : Image.network(
                        song.albumImageUrl,
                        height: 80,
                        width: 80,
                      ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${song.albumName}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: kWhite,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${song.trackName}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: kWhite,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${song.artistName}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: kWhite,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
