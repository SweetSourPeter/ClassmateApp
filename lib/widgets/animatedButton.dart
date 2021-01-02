import 'package:app_test/models/constant.dart';
import 'package:app_test/models/message_model.dart';
import 'package:app_test/models/userTags.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class ExpandedButton extends StatefulWidget {
  final String initialText, finalText;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final Duration duration;
  final TextStyle initialStyle, finalStyle;

  ExpandedButton(
      {this.initialText,
      this.finalText,
      this.duration,
      this.width,
      this.height,
      this.gradient,
      this.finalStyle,
      this.initialStyle,
      this.onPressed});

  _ExpandedButtonState createState() => _ExpandedButtonState();
}

class _ExpandedButtonState extends State<ExpandedButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  ButtonState _currentState;
  Duration _duration;

  void initState() {
    super.initState();
    _currentState = ButtonState.BEFORE_CLICK;
    _duration = Duration(milliseconds: 100);
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        return widget.onPressed();
      }
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleState() {
    setState(() {
      if (_currentState == ButtonState.BEFORE_CLICK) {
        _currentState = ButtonState.AFTER_CLICK;
        _controller.forward();
      } else {
        _currentState = ButtonState.BEFORE_CLICK;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          toggleState();
        },
        child: AnimatedContainer(
          height: widget.height,
          width: (_currentState == ButtonState.BEFORE_CLICK)
              ? widget.width
              : widget.width + 30.0,
          duration: _duration,
          decoration: BoxDecoration(
            gradient: (_currentState == ButtonState.BEFORE_CLICK)
                ? widget.gradient
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.brown[50], Colors.brown[50]],
                  ),
            border: Border.all(
              color: (_currentState == ButtonState.BEFORE_CLICK)
                  ? Colors.transparent
                  : orengeColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Center(
                child: (_currentState == ButtonState.BEFORE_CLICK)
                    ? Text(widget.initialText,
                        textAlign: TextAlign.center, style: widget.initialStyle)
                    : Text(widget.finalText,
                        textAlign: TextAlign.center, style: widget.finalStyle)),
          ),
        ),
      ),
    );
  }
}

class ShrinkButton extends StatefulWidget {
  final String initialText, finalText;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final Duration duration;
  final String userName;
  final TextStyle initialStyle, finalStyle;
  final UserTags userTag;
  ValueNotifier reset = ValueNotifier(false);
  ShrinkButton(
      {this.initialText,
      this.finalText,
      this.duration,
      this.width,
      this.height,
      this.gradient,
      this.finalStyle,
      this.initialStyle,
      this.onPressed,
      this.userName,
      this.userTag});

  _ShrinkButtonState createState() => _ShrinkButtonState();
}

class _ShrinkButtonState extends State<ShrinkButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  ButtonState _currentState;
  Duration _duration;
  final List<GlobalKey<TagsState>> tagStateKeyList = [
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
    GlobalKey<TagsState>(),
  ];
  void initState() {
    super.initState();
    widget.reset.addListener(() {
      debugPrint("value notifier is true");
      toggleState();
    });
    _currentState = ButtonState.BEFORE_CLICK;
    _duration = Duration(milliseconds: 100);
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        return widget.onPressed();
      }
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleState() {
    setState(() {
      if (_currentState == ButtonState.BEFORE_CLICK) {
        _currentState = ButtonState.AFTER_CLICK;
        _controller.forward();
      } else {
        _currentState = ButtonState.BEFORE_CLICK;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          toggleState();
          if (_currentState == ButtonState.AFTER_CLICK) {
            showMyDialog();
          }
        },
        child: AnimatedContainer(
          height: widget.height,
          width: (_currentState == ButtonState.BEFORE_CLICK)
              ? widget.width
              : widget.width - 50.0,
          duration: _duration,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.initialText,
                style: widget.initialStyle,
              ),
              Flexible(
                child: Text(
                  widget.finalText,
                  style: widget.finalStyle,
                  textAlign: TextAlign.center,
                  textScaleFactor:
                      (_currentState == ButtonState.BEFORE_CLICK) ? 1 : 0,
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Future showMyDialog() {
    return showDialog(
        context: context,
        child: Padding(
          padding: EdgeInsets.only(top: 240.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: dialogContent(context),
          ),
        )).then((value) => toggleState());
  }

  dialogContent(BuildContext context) {
    print(widget.userTag.toString());
    return Stack(
      children: [
        Container(
          height: 320,
          width: 400,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0))
              ]),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'About ' + widget.userName,
                // 'About Peter',
                style: simpleTextStyleBlack(),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'College',
                              style: simpleTextStyleBlack(),
                            ),
                          ),
                          subtitle: widget.userTag.college == null
                              ? null
                              : buildTags(
                                  widget.userTag.college, tagStateKeyList[0]),
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'Language',
                              style: simpleTextStyleBlack(),
                            ),
                          ),
                          subtitle: widget.userTag.language == null
                              ? null
                              : buildTags(
                                  widget.userTag.language, tagStateKeyList[1]),
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'GPA',
                              style: simpleTextStyleBlack(),
                            ),
                          ),
                          subtitle: widget.userTag.gpa == null
                              ? null
                              : buildTags(
                                  widget.userTag.gpa, tagStateKeyList[2]),
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'Study Habits',
                              style: simpleTextStyleBlack(),
                            ),
                          ),
                          subtitle: widget.userTag.strudyHabits == null
                              ? null
                              : buildTags(widget.userTag.strudyHabits,
                                  tagStateKeyList[3]),
                        ),
                      ],
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CustomPaint(size: Size(200, 200), painter: DrawTriangle()),
        ),
      ],
    );
  }

  Tags buildTags(
    List tagLists,
    GlobalKey<TagsState> tagStateKey,
  ) {
    return Tags(
      alignment: WrapAlignment.start,
      key: tagStateKey,
      spacing: 6,
      runSpacing: 6,
      // direction: Axis.horizontal,
      // symmetry: true,
      // textField: TagsTextField(
      //   textStyle: TextStyle(fontSize: _fontSize),
      //   constraintSuggestion: true,
      //   suggestions: [],
      //   onSubmitted: (String str) {
      //     // Add item to the data source.
      //     setState(() {
      //       // required
      //       tagLists.add(str);
      //     });
      //   },
      // ),
      itemCount: tagLists.length == null ? 0 : tagLists.length, // required
      itemBuilder: (int index) {
        final item = tagLists[index];
        return ItemTags(
          customData: false,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 4.0,
          ),
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item,
          activeColor: Colors.deepOrange,
          textColor: Colors.white,
          color: Colors.deepOrange,
          // active: item.active,
          // customData: item.customData,
          textStyle: TextStyle(
            fontSize: 14,
            // color: Colors.white,
          ),
          combine: ItemTagsCombine.withTextBefore,
          onPressed: (item) {
            setState(() {
              // required
              tagLists.removeAt(index);
            });
          },
          onLongPressed: (item) => print(item),
        );
      },
    );
  }
}

enum ButtonState { BEFORE_CLICK, AFTER_CLICK }

class DrawTriangle extends CustomPainter {
  Paint _paint;
  DrawTriangle() {
    _paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 3 + 25, 20);
    path.lineTo(size.width * 2 / 3 - 25, 20);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
