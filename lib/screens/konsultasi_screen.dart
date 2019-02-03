import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'widgets/chat_message.dart';

var _scaffoldContext;

class KonsultasiScreen extends StatefulWidget {
  _KonsultasiScreenState createState() => _KonsultasiScreenState();
}

class _KonsultasiScreenState extends State<KonsultasiScreen> {
  String peerId;
  String peerAvatar;
  String id;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  bool isLoading;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    groupChatId = '';

    isLoading = false;

    getData();
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      groupChatId = prefs.getString('id') ?? '';
      isLoading = false;
    });
    // print(isLoading);
  }

  Widget buildItem(int index, var document) {
    if (document['idFrom'] == groupChatId) {
      // Right (my message)
      return Container(
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                document['content'],
                style: TextStyle(color: Colors.black),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
              // margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: new CircleAvatar(
                child: new Image.network(
                    "http://res.cloudinary.com/kennyy/image/upload/v1531317427/avatar_z1rc6f.png"),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: new CircleAvatar(
                    child: new Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Male_Doctor_Flat_Icon_Vector.svg/2000px-Male_Doctor_Flat_Icon_Vector.svg.png"),
                  ),
                ),
                Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0)),
                  // margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child("messages")
                  .child(groupChatId)
                  .orderByChild("timestamp")
                  .onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // print(jsonDecode(snapshot.data.snapshot.value));
                  if (snapshot.data.snapshot.value != null) {
                    print(snapshot.data.snapshot.value);
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    List<dynamic> list = map.values.toList();
                    print(list);
                    list.sort((a, b) {
                      return b["timestamp"].compareTo(a["timestamp"]);
                    });
                    listMessage = list;
                    // print(list);
                    // return Container();
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(index, listMessage[index]),
                      itemCount: listMessage.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                  return Container();
                }
              },
            ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseDatabase.instance
          .reference()
          .child('messages')
          .child(groupChatId)
          .push()
          .set({
        "content": content,
        "idFrom": groupChatId,
        "timestamp": DateTime.now().millisecondsSinceEpoch
      });
      documentReference.then((onValue) {
        print("yaaa");
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
    );
  }
}
