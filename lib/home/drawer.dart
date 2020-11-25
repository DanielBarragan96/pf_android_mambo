import 'package:entregable_2/colors.dart';
import 'package:entregable_2/home/bloc/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatefulWidget {
  final HomeBloc bloc;

  DrawerWidget({Key key, this.bloc}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User _user;
  TextEditingController _alertController = TextEditingController();

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: kBlack,
        appBar: AppBar(
          title: Text(""),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: (_user.photoURL != "" && _user.photoURL != null)
                          ? Image.network(
                              _user.photoURL,
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              height: 80,
                            )
                          : CircleAvatar(
                              backgroundColor: kMainPurple,
                              minRadius: 40,
                              maxRadius: 80,
                            ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "${_user.displayName ?? ""}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: kWhite),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${_user.email}",
                      style: TextStyle(color: kLightGray),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        "Update Spotify Key",
                        style: TextStyle(color: kWhite),
                      ),
                      leading: FaIcon(FontAwesomeIcons.spotify, color: kWhite),
                      onTap: () {
                        showUpdateKeyModal();
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Update Spotify Stats",
                        style: TextStyle(color: kWhite),
                      ),
                      leading: FaIcon(FontAwesomeIcons.spotify, color: kWhite),
                      onTap: () {
                        widget.bloc.add(LoadSpotifyStatsEvent());
                      },
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: kMainPurple,
                              child: Text(
                                "Log out",
                                style: TextStyle(color: kWhite),
                              ),
                              onPressed: () {
                                if (widget.bloc != null) {
                                  return widget.bloc.logout();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showUpdateKeyModal() {
    showDialog<String>(
      context: context,
      child: Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: kBlack),
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _alertController,
                  autofocus: true,
                  style: TextStyle(color: kWhite),
                  decoration: new InputDecoration(
                      hintStyle: TextStyle(color: kLightGray),
                      labelText: 'Spotify Key',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: kWhite),
                      hintText: 'eg. BQBThAuSDPnGl2...'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                color: kLightGray,
                child: const Text('CANCEL', style: TextStyle(color: kWhite)),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                color: kMainPurple,
                child: const Text('LOAD'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    ).then((value) {
      if (_alertController.text.length > 5) {
        widget.bloc.updateSpotifyKey(_alertController.text);
        widget.bloc.add(LoadSpotifyStatsEvent());
        _alertController.text = "";
      }
    });
  }
}
