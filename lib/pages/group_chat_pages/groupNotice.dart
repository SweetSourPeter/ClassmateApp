import 'package:app_test/models/user.dart';
import 'package:app_test/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:app_test/models/constant.dart';
import 'package:intl/intl.dart';

class GroupNotice extends StatefulWidget {
  final String courseId;

  GroupNotice({
    this.courseId,
  });

  @override
  _GroupNoticeState createState() => _GroupNoticeState();
}

class _GroupNoticeState extends State<GroupNotice> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String lastGroupNoticeTime;
  String groupNoticeText;
  double leaderProfileColor = 1.0;
  String leaderName = 'yayaya';
  bool isEdit;
  TextEditingController _groupNoticeController = new TextEditingController();
  FocusNode myFocusNode = FocusNode();

  setGroupNotice() {
    final noticeTime = DateTime.now().millisecondsSinceEpoch;
    databaseMethods.setGroupNotice(
        widget.courseId, _groupNoticeController.text, noticeTime);
    setState(() {
      isEdit = false;
      lastGroupNoticeTime =
          DateTime.fromMillisecondsSinceEpoch(noticeTime).toString();
      groupNoticeText = _groupNoticeController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    databaseMethods.getGroupNotice(widget.courseId).then((ret) {
      setState(() {
        groupNoticeText = ret['groupNoticeText'];
        lastGroupNoticeTime =
            DateTime.fromMillisecondsSinceEpoch(ret['noticeTime']).toString();
        _groupNoticeController.text = groupNoticeText;
      });
    });
    isEdit = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    double sidebarSize = _width * 0.05;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Color(0xffF9F6F1),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: _height * 0.10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: sidebarSize * 0.55),
                          child: Container(
                            child: IconButton(
                              icon: Image.asset(
                                'assets/images/arrow-back.png',
                                height: 17.96,
                                width: 10.26,
                              ),
                              // iconSize: 30.0,
                              color: const Color(0xFFFF7E40),
                              onPressed: () {
                                // databaseMethods.setUnreadNumber(widget.courseId, widget.myEmail, 0);
                                // databaseMethods.setUnreadGroupChatNumberToZero(
                                //     widget.courseId, currentUser.userID);
                                Navigator.of(context).pop();
                              },
                            ),
                            // iconSize: 30.0,
                          ),
                        ),
                        Container(
                            child: Text(
                          'Group Notice',
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                        isEdit
                            ? Padding(
                                padding: EdgeInsets.only(right: sidebarSize*0.65),
                                child: Container(
                                    child: GestureDetector(
                                  onTap: () {
                                    if (_groupNoticeController.text.isNotEmpty) {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                            content: Text('All members will be notified of this notice. Post it now?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setGroupNotice();
                                                  Navigator.pop(context, 'Post');
                                                },
                                                child: const Text('Post'),
                                              ),
                                            ],
                                          ),
                                          barrierDismissible: true
                                      );
                                    } else {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                            content: Text('Clear group notice?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setGroupNotice();
                                                  Navigator.pop(context, 'Clear');
                                                },
                                                child: const Text('Clear'),
                                              ),
                                            ],
                                          ),
                                          barrierDismissible: true
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Done',
                                    style: GoogleFonts.montserrat(
                                        color: themeOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )),
                              )
                            : Padding(
                                padding: EdgeInsets.only(right: sidebarSize),
                                child: Container(
                                    child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEdit = true;
                                    });
                                    myFocusNode.requestFocus();
                                  },
                                  child: Text(
                                    'Edit',
                                    style: GoogleFonts.montserrat(
                                        color: themeOrange,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )),
                              )
                      ],
                    ),
                  ),
                  Container(
                      height: _height * 0.12,
                      child: Padding(
                        padding: EdgeInsets.only(left: sidebarSize),
                        child: Row(
                          children: [
                            Container(
                              height: _width * 0.13,
                              width: _width * 0.13,
                              child: CircleAvatar(
                                backgroundColor:
                                    listProfileColor[leaderProfileColor.toInt()],
                                radius: sidebarSize / 15,
                                child: Container(
                                  child: Text(
                                    // 单个字22，双字18
                                    (leaderName.split(' ').length >= 2 &&
                                            leaderName
                                                .split(' ')[
                                                    leaderName.split(' ').length -
                                                        1]
                                                .isNotEmpty)
                                        ? leaderName
                                                .split(' ')[0][0]
                                                .toUpperCase() +
                                            leaderName
                                                .split(' ')[
                                                    leaderName.split(' ').length -
                                                        1][0]
                                                .toUpperCase()
                                        : leaderName[0].toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            leaderName.split(' ').length >= 2
                                                ? 19
                                                : 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: sidebarSize * 0.5,
                                  bottom: sidebarSize * 0.5,
                                  left: sidebarSize * 0.9),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    leaderName,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xffFF7E40)),
                                  ),
                                  Container(
                                    child: Text(
                                      lastGroupNoticeTime != null
                                          ? (lastGroupNoticeTime.substring(0, 4) +
                                              '.' +
                                              lastGroupNoticeTime.substring(
                                                  5, 7) +
                                              '.' +
                                              lastGroupNoticeTime.substring(
                                                  8, 10) +
                                              '  ' +
                                              lastGroupNoticeTime.substring(
                                                  10, 16))
                                          : 'Loading...',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff949494)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    child: isEdit
                        ? Container(
                            padding: EdgeInsets.all(sidebarSize),
                            width: _width,
                            color: Colors.white,
                            child: TextField(
                                style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff949494)),
                                controller: _groupNoticeController,
                                keyboardType: TextInputType.multiline,
                                focusNode: myFocusNode,
                                minLines: 1,
                                maxLines: null,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 31.0),
                                )),
                          )
                        : Container(
                            padding: EdgeInsets.all(sidebarSize),
                            width: _width,
                            color: Colors.white,
                            child: Text(
                              groupNoticeText ?? 'Loading...',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff949494)),
                            ),
                          ),
                  ),
                  isEdit
                      ? Container()
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: _height * 0.08),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: sidebarSize * 0.5),
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                              ),
                              Text(
                                'Only the group leader can edit.',
                                style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff949494)),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: sidebarSize * 0.5),
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            )),
      ),
    );
  }
}
