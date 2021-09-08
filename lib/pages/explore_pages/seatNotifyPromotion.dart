import 'package:flutter/material.dart';

class SeatNotifyPromotion extends StatefulWidget {
  SeatNotifyPromotion({Key key}) : super(key: key);

  @override
  _SeatNotifyPromotionState createState() => _SeatNotifyPromotionState();
}

class _SeatNotifyPromotionState extends State<SeatNotifyPromotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
