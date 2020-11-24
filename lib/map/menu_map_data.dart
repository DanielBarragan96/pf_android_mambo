import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> _coords = [
  LatLng(20.659684585453792, -103.45644380897282),
  LatLng(20.58794293024975, -103.41349761933088),
  LatLng(20.709674113035824, -103.38253621011972),
  LatLng(20.6232340206758, -103.32710534334183),
  LatLng(20.703134533765034, -103.29913996160033)
];

class Users {
  final LatLng coord;
  final String firstname;
  final String lastname;
  final String favsong;
  final String favartist;
  final String imgsong;
  final String imgartist;
  bool liked;

  Users({
    @required this.coord,
    @required this.firstname,
    @required this.lastname,
    @required this.favsong,
    @required this.favartist,
    @required this.imgsong,
    @required this.imgartist,
    this.liked = false,
  });
}

List<Users> _usersList = [
  Users(
    coord: _coords[0],
    firstname: 'Sergio',
    lastname: 'El Bailador',
    favsong: 'Sergio El Bailador',
    favartist: 'Bronco',
    imgsong:
        'https://img.discogs.com/Vkn9bWHky8u_a7JUu0SvA1BfxOo=/fit-in/600x597/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-9312147-1478401824-1218.jpeg.jpg',
    imgartist:
        'https://www.mm-group.org/wp-content/uploads/2018/04/Bronco-Logo.jpg',
  ),
  Users(
    coord: _coords[1],
    firstname: 'Juan',
    lastname: 'Colorado',
    favsong: 'Juan Colorado',
    favartist: 'Pepe Aguilar',
    imgsong:
        'https://images.genius.com/fb6a3f92a94dd8a89605d720faae9250.600x600x1.jpg',
    imgartist:
        'https://lavozdgo.com/wp-content/uploads/2020/08/PEPE-AGUILAR-3.jpg',
  ),
  Users(
    coord: _coords[2],
    firstname: 'John',
    lastname: 'Travolta',
    favsong: 'Staying Alive',
    favartist: 'Bee Gees',
    imgsong:
        'https://e-cdns-images.dzcdn.net/images/cover/5f342a3be01c48d530088a21cdf778cf/350x350.jpg',
    imgartist:
        'https://www.logolynx.com/images/logolynx/90/90e355ddaf6cd14a8d7f2ddf950aff12.jpeg',
  ),
  Users(
    coord: _coords[3],
    firstname: 'Chris',
    lastname: 'Martin',
    favsong: 'Fix You',
    favartist: 'Coldplay',
    imgsong:
        'https://img.discogs.com/WG_kmCwjIkoHFF6J-0o-XJt4CmM=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-479908-1365163091-8878.jpeg.jpg',
    imgartist:
        'https://i.pinimg.com/originals/6d/d6/c3/6dd6c30b60ab882e081e3a10305ddc26.png',
  ),
  Users(
    coord: _coords[4],
    firstname: 'Michael',
    lastname: 'Jackson',
    favsong: 'Thriller',
    favartist: 'Michael Jackson',
    imgsong:
        'https://images-na.ssl-images-amazon.com/images/I/51xoJyk%2BU2L._AC_.jpg',
    imgartist:
        'https://assets.soundpark.news/__export/1604345604666/sites/debate/img/2020/11/02/michael_jackson_1.jpg_347796135.jpg',
  ),
];

List<Users> getUsersList() {
  return _usersList;
}

Set<Marker> _mapMarkers = {
  Marker(
    markerId: MarkerId(_coords[0].toString()),
    position: _coords[0],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    infoWindow: InfoWindow(
      title: _coords[0].toString(),
    ),
    onTap: () {},
  ),
  Marker(
    markerId: MarkerId(_coords[1].toString()),
    position: _coords[1],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    infoWindow: InfoWindow(
      title: _coords[1].toString(),
    ),
    onTap: () {},
  ),
  Marker(
    markerId: MarkerId(_coords[2].toString()),
    position: _coords[2],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    infoWindow: InfoWindow(
      title: _coords[2].toString(),
    ),
    onTap: () {},
  ),
  Marker(
    markerId: MarkerId(_coords[3].toString()),
    position: _coords[3],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    infoWindow: InfoWindow(
      title: _coords[3].toString(),
    ),
    onTap: () {},
  ),
  Marker(
    markerId: MarkerId(_coords[4].toString()),
    position: _coords[4],
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    infoWindow: InfoWindow(
      title: _coords[4].toString(),
    ),
    onTap: () {},
  ),
};

Set<Marker> getMarkersSet() {
  return _mapMarkers;
}
