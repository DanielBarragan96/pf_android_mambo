import 'package:entregable_2/home/bloc/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../colors.dart';

class SingleChatPage extends StatefulWidget {
  final HomeBloc bloc;
  final BuildContext context;
  final Map<String, dynamic> userChat;

  SingleChatPage({
    Key key,
    @required this.bloc,
    @required this.context,
    @required this.userChat,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SingleChatPage> {
  User _user;
  DatabaseReference _firebaseDatabase;
  DatabaseReference _firebaseDatabase2;
  final _textController = TextEditingController();

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    _firebaseDatabase = FirebaseDatabase.instance
        .reference()
        .child("profiles/${_user.uid}/chats/${widget.userChat["id"]}/messages");
    _firebaseDatabase2 = FirebaseDatabase.instance
        .reference()
        .child("profiles/${widget.userChat["id"]}/chats/${_user.uid}/messages");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            widget.bloc.add(MenuChatEvent());
          },
          iconSize: 20.0,
          color: kWhite,
        ),
        title: Text("${widget.userChat["name"]}"),
      ),
      body: Center(
        child: Column(
          children: [
            _messageList(),
          ],
        ),
      ),
      bottomNavigationBar: _composeMessage(),
    );
  }

  _messageList() {
    //construir lista de mensajes del chat
    return Flexible(
      child: FirebaseAnimatedList(
        query: _firebaseDatabase,
        // sort: (a, b) => b.key.compareTo(a.key),
        reverse: false,
        itemBuilder: (context, resultado, animation, index) {
          return _messageFromData(resultado, animation);
        },
      ),
    );
  }

  _messageFromData(DataSnapshot resultado, Animation<double> animation) {
    //get message content
    final String msgTxt = resultado.value["text"] ?? "--";
    final int sentTime = resultado.value["timestamp"] ?? 0;
    final String senderId = resultado.value["senderId"] ?? "";
    // final String senderPhotoUrl = resultado.value["senderPhotoUrl"];

    //calculate position
    const int MAX_LETTER = 30;
    const int MIN_LETTER = 16;
    const int LETTER_SIZE = 10;
    bool isMe = senderId == _user.uid;
    double screenW75 = MediaQuery.of(context).size.width * 0.75;
    double screenW25 = MediaQuery.of(context).size.width * 0.25;
    double minMsgW = 240;

    //validate position
    double msgMargin = (msgTxt.length < MIN_LETTER)
        ? minMsgW
        : (msgTxt.length < MAX_LETTER)
            ? minMsgW - (msgTxt.length - MIN_LETTER) * LETTER_SIZE
            : screenW25;

    //parse time as String
    final String sentTimeString = (sentTime == 0)
        ? ""
        : DateTime.fromMillisecondsSinceEpoch(sentTime)
            .toString()
            .substring(11, 16);

    //create message widget
    return Container(
      constraints: BoxConstraints(maxWidth: 100),
      margin: (isMe)
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20, left: msgMargin)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: msgMargin, left: 20),
      padding: EdgeInsets.only(left: 15.0, right: 15, top: 15.0, bottom: 5),
      width: screenW75,
      decoration: BoxDecoration(
        color: (isMe) ? kMainPurple : kDarkGray,
        borderRadius: (isMe)
            ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            msgTxt,
            style: TextStyle(color: kWhite),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                sentTimeString,
                style: TextStyle(color: kLightGray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _composeMessage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      child: Container(
        color: kMainPurple,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25.0,
              color: kWhite,
              onPressed: () {
                //TODO Tomar foto
              },
            ),
            Expanded(
              child: TextField(
                style: TextStyle(color: kWhite),
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {},
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                  hintStyle: TextStyle(color: kWhite),
                ),
                onSubmitted: (msg) {
                  _onTextSubmitted(_textController.text);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: kWhite,
              onPressed: () {
                _onTextSubmitted(_textController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTextSubmitted(String text) async {
    _textController.clear();
    setState(() {});
    _firebaseDatabase.push().set({
      "senderName": _user.displayName,
      "senderId": _user.uid,
      "text": text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "senderPhotoUrl": _user.photoURL,
    });
    //copia chat user 2
    _firebaseDatabase2.push().set({
      "senderName": _user.displayName,
      "senderId": _user.uid,
      "text": text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "senderPhotoUrl": _user.photoURL,
    });
  }
}
