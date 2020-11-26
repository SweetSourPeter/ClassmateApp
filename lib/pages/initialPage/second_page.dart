import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key key}) : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  String _nikname = '';

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: _height * 0.23),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'How would you like your friends to call you?',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.only(top: _height * 0.22),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      onChanged: (texto) {
                        setState(() {
                          _nikname = texto;
                        });
                      },
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          //labelText: '',
                          hintText: "I would like to be called...",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 18),
                          border: InputBorder.none),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Your nickname',
                          style: TextStyle(fontSize: 14, color: Colors.white38),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '${_nikname.length} / 16',
                          style: TextStyle(fontSize: 14, color: Colors.white38),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
