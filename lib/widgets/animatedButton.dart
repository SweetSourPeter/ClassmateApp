import 'package:app_test/models/constant.dart';
import 'package:flutter/material.dart';

class ExpandedButton extends StatefulWidget{

  final String initialText, finalText;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final Duration duration;
  final TextStyle initialStyle, finalStyle;

  ExpandedButton({
    this.initialText,
    this.finalText,
    this.duration,
    this.width,
    this.height,
    this.gradient,
    this.finalStyle,
    this.initialStyle,
    this.onPressed
  });

  _ExpandedButtonState createState() => _ExpandedButtonState();

}

class _ExpandedButtonState extends State<ExpandedButton> with TickerProviderStateMixin{

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
      if (_currentState == ButtonState.BEFORE_CLICK){
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
        onTap: (){
          toggleState();
        },
        child: AnimatedContainer(
          height: widget.height,
          width: (_currentState == ButtonState.BEFORE_CLICK) ? widget.width : widget.width + 30.0,
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
                  ? Text(
                      widget.initialText,
                      textAlign: TextAlign.center,
                      style: widget.initialStyle
                    )
                  : Text(
                      widget.finalText,
                      textAlign: TextAlign.center,
                      style: widget.finalStyle
                    )
            ),
          ),
        ),
      ),
    );
  }

}

class ShrinkButton extends StatefulWidget{

  final String initialText, finalText;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;
  final Duration duration;
  final TextStyle initialStyle, finalStyle;

  ShrinkButton({
    this.initialText,
    this.finalText,
    this.duration,
    this.width,
    this.height,
    this.gradient,
    this.finalStyle,
    this.initialStyle,
    this.onPressed
  });

  _ShrinkButtonState createState() => _ShrinkButtonState();

}

class _ShrinkButtonState extends State<ShrinkButton> with TickerProviderStateMixin{

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
      if (_currentState == ButtonState.BEFORE_CLICK){
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
        onTap: (){
          toggleState();
        },
        child: AnimatedContainer(
          height: widget.height,
          width: (_currentState == ButtonState.BEFORE_CLICK) ? widget.width : widget.width - 50.0,
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
                  style:  widget.initialStyle,
                ),
                Flexible(
                  child: Text(
                      widget.finalText,
                      style: widget.finalStyle,
                      textAlign: TextAlign.center,
                      textScaleFactor: (_currentState == ButtonState.BEFORE_CLICK) ? 1 : 0,
                    ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }

}

enum ButtonState { BEFORE_CLICK, AFTER_CLICK }