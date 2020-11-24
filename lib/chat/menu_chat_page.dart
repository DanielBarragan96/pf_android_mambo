import 'package:entregable_2/colors.dart';
import 'package:entregable_2/home/bloc/home_bloc.dart';
import 'package:entregable_2/home/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuChatPage extends StatefulWidget {
  final HomeBloc bloc;
  final BuildContext context;

  MenuChatPage({
    Key key,
    @required this.bloc,
    @required this.context,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MenuChatPage> {
  User _user;
  DatabaseReference _firebaseDatabase;
  List<Map<String, dynamic>> _data = [];
  final String deafaultImgUrl =
      "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child("profiles/${_user.uid}/chats/");

    _firebaseDatabase.once().then((dataSnapShot) {
      Map chats = dataSnapShot.value;
      chats.forEach((key, value) {
        FirebaseDatabase.instance
            .reference()
            .child("profiles/$key/")
            .once()
            .then((dataSnapShot) {
          _data.add({
            "picture":
                "${(dataSnapShot.value["image"] == "" || dataSnapShot.value["image"] == null) ? deafaultImgUrl : dataSnapShot.value["image"]}",
            "name": "${dataSnapShot.value["name"]}",
            "id": "${dataSnapShot.key}"
          });
          setState(() {});
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      drawer: DrawerWidget(
        bloc: widget.bloc,
      ),
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: BlocProvider(
        create: (context) {
          return widget.bloc;
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          cubit: widget.bloc,
          builder: (context, state) {
            if (state is MenuChatState) {
              return Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: kLightPurple,
                      ),
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            widget.bloc
                                .add(SingleChatEvent(userName: _data[index]));
                          },
                          child: ListTile(
                            leading: Image.network(_data[index]["picture"]),
                            title: Text(
                              "${_data[index]["name"]}",
                              style: TextStyle(color: kWhite),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else
              return Center();
          },
        ),
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
                  onPressed: () {
                    widget.bloc.add(MenuMapEvent());
                  },
                  iconSize: 25.0,
                  color: kLightGray,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.users),
                  onPressed: () {},
                  iconSize: 25.0,
                  color: kWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
