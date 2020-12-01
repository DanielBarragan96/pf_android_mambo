import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:entregable_2/models/artist.dart';
import 'package:entregable_2/models/track.dart';

class MapUser {
  final String userid;
  final LatLng coord;
  final String name;
  final Track favsong;
  final Artist favartist;
  bool liked;

  MapUser({
    @required this.userid,
    @required this.coord,
    @required this.name,
    @required this.favsong,
    @required this.favartist,
    this.liked = false,
  });
}


