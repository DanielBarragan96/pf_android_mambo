import 'package:entregable_2/colors.dart';
import 'package:entregable_2/home/bloc/home_bloc.dart';
import 'package:entregable_2/home/drawer.dart';
import 'package:entregable_2/map/menu_map_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:entregable_2/models/artist.dart';
import 'package:entregable_2/models/track.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

List<MapUser> _usersList = [];
Set<Marker> _mapMarkers = {};

class MapPage extends StatefulWidget {
  final HomeBloc bloc;
  final BuildContext context;

  MapPage({
    Key key, 
    @required this.bloc, 
    @required this.context
  }): super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _mapController;
  Position _currentPosition;
  int _user_index = 0;
  String _darkMapStyle;
  final LatLng _center = const LatLng(20.608160, -103.414496);
  User _user = FirebaseAuth.instance.currentUser;
  DatabaseReference _firebaseDatabase;

  @override
  void initState() {
    _loadDarkThemeMap();
    _getUsersInfo();
    super.initState();
  }

  Future _loadDarkThemeMap() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_dark.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      drawer: DrawerWidget(
        bloc: widget.bloc,
      ),
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Stack(
        children: <Widget>[
          //SizedBox(height: 20),
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _mapMarkers,
            onLongPress: null,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: kLightPurple,
                    child: Icon(Icons.people),
                    onPressed: () {
                      _showUserCard(context, _usersList[_user_index]);
                    },
                  ),
                  SizedBox(height: 30),
                  FloatingActionButton(
                    backgroundColor: kLightPurple,
                    child: Icon(Icons.location_pin),
                    onPressed: () {
                      _getCurrentPosition(context);
                    },
                  ),
                  SizedBox(height: 30),
                  FloatingActionButton(
                    backgroundColor: kLightPurple,
                    child: Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                        "$_currentPosition",
                        subject: "Aqui me encuentro",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height / 10,
        child: Container(
          color: kMainPurple,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.spotify),
                  onPressed: () {
                    widget.bloc.add(MenuStatsEvent());
                  },
                  iconSize: 25.0,
                  color: kLightGray,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.mapMarkedAlt),
                  onPressed: () {},
                  iconSize: 25.0,
                  color: kWhite,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.users),
                  onPressed: () {
                    widget.bloc.add(MenuChatEvent());
                  },
                  iconSize: 25.0,
                  color: kLightGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition(BuildContext context) async {
    // get current position
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child("profiles/${_user.uid}/location/");
    _firebaseDatabase.update({
      "lat": _currentPosition.latitude,
      "long": _currentPosition.longitude,
    });

    // move camera
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition.latitude,
            _currentPosition.longitude,
          ),
          zoom: 15.0,
        ),
      ),
    );
  }

  void _onMapCreated(controller) {
    setState(() {
      _mapController = controller;
      _mapController.setMapStyle(_darkMapStyle);
    });
  }

  Future<String> _getGeolocationAddress(Position position) async {
    var places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (places != null && places.isNotEmpty) {
      final Placemark place = places.first;
      return "${place.thoroughfare}, ${place.locality}";
    }
    return "No address availabe";
  }

  void _showUserCard(BuildContext context, MapUser user) async {
    String address = await _getGeolocationAddress(
      Position(latitude: user.coord.latitude, longitude: user.coord.longitude),
    );

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            user.coord.latitude - 0.005,
            user.coord.longitude,
          ),
          zoom: 15.0,
        ),
      ),
    );

    await showModalBottomSheet(
      backgroundColor: kBlack,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24.0,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${user.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: kWhite,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 40, horizontal: 120),
                  child: Placeholder(
                    color: kMainPurple,
                    fallbackHeight: 128,
                    fallbackWidth: 32,
                  ),
                ),
                Text(
                  address,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kWhite,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        iconSize: 50,
                        color: user.liked ? Colors.red : kMainPurple,
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          user.liked = !user.liked;
                          setState(() {});
                          _likeUser(user);
                          Navigator.of(context).pop();
                          _showUserCard(context, _usersList[_user_index]);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.format_list_bulleted,
                            color: kMainPurple),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showStatsCard(context, user);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.fast_forward, color: kMainPurple),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _user_index++;
                            if (_user_index == _usersList.length) {
                              _user_index = 0;
                            }
                          });
                          _showUserCard(context, _usersList[_user_index]);
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
    );
  }

  void _showStatsCard(BuildContext context, MapUser user) async {
    await showModalBottomSheet(
      backgroundColor: kBlack,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24.0,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${user.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: kWhite,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            user.favsong.albumImageUrl,
                            fit: BoxFit.fill,
                            width: 140,
                            height: 140,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${user.favsong.trackName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            user.favartist.artistImageUrl,
                            fit: BoxFit.fill,
                            width: 140,
                            height: 140,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${user.favartist.artistName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        iconSize: 50,
                        color: user.liked ? Colors.red : kMainPurple,
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          user.liked = !user.liked;
                          setState(() {});
                          _likeUser(user);
                          Navigator.of(context).pop();
                          _showUserCard(context, _usersList[_user_index]);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.people, color: kMainPurple),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showUserCard(context, _usersList[_user_index]);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        iconSize: 50,
                        icon: Icon(Icons.fast_forward, color: kMainPurple),
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _user_index++;
                            if (_user_index == _usersList.length) {
                              _user_index = 0;
                            }
                          });
                          _showUserCard(context, _usersList[_user_index]);
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
    );
  }

  void _getUsersInfo() async {
    FirebaseDatabase _firebaseDatabase;
    Map retrievedData;

    _firebaseDatabase = await FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .once()
        .then((DataSnapshot data){
          setState((){
            retrievedData = data.value;
          });
        });

    retrievedData.forEach((key, value) {
      LatLng coords = LatLng(value["location"]["lat"],value["location"]["long"]);
      _usersList.add(
        MapUser(
          userid: key,
          coord: coords,
          name: value["name"],
          favsong: Track(
            artistName:    value["stats"]["tracks"][1]["artistname"],
            trackName:     value["stats"]["tracks"][1]["trackname"],
            albumName:     value["stats"]["tracks"][1]["albumname"],
            albumImageUrl: value["stats"]["tracks"][1]["albumimageurl"],
            trackUri:      value["stats"]["tracks"][1]["trackuri"],
            trackUrl:      value["stats"]["tracks"][1]["trackurl"],
          ),
          favartist: Artist(
            artistName:     value["stats"]["artists"][1]["artistname"],
            artistImageUrl: value["stats"]["artists"][1]["artistimageurl"],
            artistUrl:      value["stats"]["artists"][1]["artisturl"],
          )
        )
      );
      _mapMarkers.add(
        Marker(
          markerId: MarkerId(coords.toString()),
          position: coords,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),        
      ); 
    });    
  }

  Future<void> _likeUser(MapUser otherUser) async {
    User _ownUser = FirebaseAuth.instance.currentUser;
    DatabaseReference _firebaseDatabase;
    Map retrievedData;

    _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child("matches/${_ownUser.uid}/${otherUser.userid}/");
    
    if(_ownUser.uid != otherUser.userid){

      await FirebaseDatabase.instance
          .reference()
          .child("matches")
          .once()
          .then((DataSnapshot data){
            setState((){
              retrievedData = data.value;
            });
          });
          
      if(retrievedData["${otherUser.userid}"]["${_ownUser.uid}"]["match"] == "accepted"){
        _firebaseDatabase.update({
          "match": 'accepted',
        });


        _firebaseDatabase = FirebaseDatabase.instance
            .reference()
            .child("profiles/${_ownUser.uid}/chats/${otherUser.userid}/messages");
        _firebaseDatabase.push().set({
          "senderName": _ownUser.displayName,
          "senderId": _ownUser.uid,
          "text": "Hola. Hicimos match!!",
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "senderPhotoUrl": _ownUser.photoURL,
        });
        //copia
        _firebaseDatabase = FirebaseDatabase.instance
            .reference()
            .child("profiles/${otherUser.userid}/chats/${_ownUser.uid}/messages");        
        _firebaseDatabase.push().set({
          "senderName": _ownUser.displayName,
          "senderId": _ownUser.uid,
          "text": "Hola. Hicimos match!!",
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "senderPhotoUrl": _ownUser.photoURL,
        });                         
      }else{
        _firebaseDatabase.update({
          "match": 'accepted',
        });  
        _firebaseDatabase = FirebaseDatabase.instance
            .reference()
            .child("matches/${otherUser.userid}/${_ownUser.uid}/");     

        _firebaseDatabase.update({
          "match": 'waiting',
        });              
      }
    }
  }
}
