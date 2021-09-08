import 'package:app_test/models/constant.dart';
import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatefulWidget {
  final PageController pageController;
  final bool isEdit;
  final ValueChanged<String> valueChanged;
  const SecondPage({
    Key key,
    this.pageController,
    this.isEdit = false,
    this.valueChanged,
  }) : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with AutomaticKeepAliveClientMixin {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = new TextEditingController();
  String _nickname = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    _getHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: widget.isEdit ? _height * 0.9 * 0.044 : _height * 0.044,
              ),
              Text(
                'What should your classmates call you?',
                style: largeTitleTextStyleBold(Colors.white, 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: widget.isEdit ? _height * 0.9 * 0.016 : _height * 0.016,
              ),
              Text(
                'Your profile picture displays the first letters of your nick name',
                style: simpleTextStyle(Colors.white, 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: widget.isEdit
          ? BoxDecoration(
              color: themeOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                // bottomLeft: Radius.circular(30.0),
                // bottomRight: Radius.circular(30.0),
              ),
            )
          : null,
      height: widget.isEdit ? (_height * 0.9) : _height,
      color: widget.isEdit ? null : themeOrange,
      child: Padding(
        padding: EdgeInsets.only(top: widget.isEdit ? (25) : 0),
        child: Form(
          key: formKey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: themeOrange,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.isEdit
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35.0),
                                topRight: Radius.circular(35.0),
                                bottomLeft: Radius.circular(35.0),
                                bottomRight: Radius.circular(35.0),
                              ),
                              child: SizedBox(
                                width: 65.0,
                                height: 6.0,
                                child: const DecoratedBox(
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                ),
                              )
                              // child: Container(
                              //   padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
                              //   color: Colors.black,
                              // )
                              ),
                        )
                      : Container(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: widget.isEdit
                              ? (_height * 0.9 * 0.13 - 22)
                              : _height * 0.13 - 22),
                      child: _getHeader()),
                  Padding(
                    padding: EdgeInsets.only(
                        top: widget.isEdit
                            ? _height * 0.9 * 0.22
                            : _height * 0.22,
                        left: 45,
                        right: 45),
                    child: TextFormField(
                      controller: nameTextEditingController,
                      validator: (val) {
                        if (val.length >= 25) {
                          return "Nick name has to be less than 25 chars";
                        } else if (val.length <= 0) {
                          return "The nick name can not be empty";
                        } else if (val.substring(val.length - 1) == ' ') {
                          return "The nick name can not end with empty space";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (change) {
                        setState(() {
                          _nickname = change;
                        });
                      },
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      decoration: textFieldInputDecoration(
                          widget.isEdit
                              ? _height * 0.9 * 0.036
                              : _height * 0.036,
                          'Your name...',
                          11),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: widget.isEdit
                            ? _height * 0.9 * 0.2
                            : _height * 0.2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      height:
                          widget.isEdit ? _height * 0.9 * 0.06 : _height * 0.06,
                      width: _width * 0.75,
                      child: RaisedButton(
                        hoverElevation: 0,
                        highlightColor: Color(0xDA6D39),
                        highlightElevation: 0,
                        elevation: 0,
                        color: (_nickname.isNotEmpty &&
                                formKey.currentState.validate())
                            ? Colors.white
                            : Color(0xFFFF9B6B).withOpacity(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          if (_nickname.length > 0 &&
                              formKey.currentState.validate()) {
                            if (widget.isEdit) {
                              databaseMethods.updateUserName(
                                  user.userID, _nickname);
                              Navigator.pop(context);
                            } else {
                              widget.pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.easeInCubic);
                              databaseMethods.updateUserName(
                                  user.userID, _nickname);
                              widget.valueChanged(_nickname);
                            }

                            print('username saved');
                          }
                        },
                        child: Text(
                          'Continue',
                          style: simpleTextSansStyleBold(
                              (_nickname.isNotEmpty)
                                  ? themeOrange
                                  : Colors.white,
                              16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
