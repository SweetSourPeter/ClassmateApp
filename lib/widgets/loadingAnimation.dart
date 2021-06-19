import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';


class SimpleLoadingScreen extends StatelessWidget {
  SimpleLoadingScreen(this.backgroundColor);
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    // return Lottie.asset(
    //   'assets/icon/Simplified Loading Animation.zip',
    //   fit: BoxFit.contain,
    // );
    return Container(
      color: backgroundColor,
      child: Lottie.asset(
        'assets/icon/Simplified Loading Animation.zip',
        fit: BoxFit.fill,
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  LoadingScreen(this.backgroundColor);
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Lottie.asset(
          'assets/icon/Loading Animation_Json.zip',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class ShimmerLoadingScreen extends StatelessWidget {
  ShimmerLoadingScreen(this.backgroundColor);
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: backgroundColor,
      child: Shimmer.fromColors(
          baseColor: backgroundColor,
          highlightColor: Colors.grey[100],
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
            )
          )
      )
    );
  }
}

class PictureLoadingScreen extends StatelessWidget {
  PictureLoadingScreen(this.backgroundColor);
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: backgroundColor,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/GroupChatLoading.png'
              ),
              //fit: BoxFit.fill
            ),
            shape: BoxShape.circle
        ),
      ),
    );
  }
}