import 'package:app_test/models/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_test/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

class PreviewImage extends StatefulWidget {
  final String imageUrl;

  PreviewImage({this.imageUrl});

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  // _toastInfo(String info) {
  //   Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  // }

  // _saveImage(source) async {
  //   launch("data:application/octet-stream;base64,$source");
  //   // var appDocDir = await getTemporaryDirectory();
  //   // String savePath = appDocDir.path + "/temp.png";
  //   // await Dio().download(source, savePath);
  //   //
  //   // await ImageGallerySaver.saveFile(savePath);
  //   //
  //   // _toastInfo('The image has been downloaded to your gallery!');
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 73,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/arrow-back.png',
                        ),
                        // iconSize: 30.0,
                        color: const Color(0xFFFFB811),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: MediaQuery.of(context).size.height - 300,
                width: getRealWidth(maxWidth),
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Container(
              height: 73,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        icon: Image.asset(
                          'assets/images/download.png',
                        ),
                        // iconSize: 30.0,
                        color: const Color(0xFFFFB811),
                        onPressed: () {
                          _requestPermission();
                          //_saveImage(widget.imageUrl);
                          print("reached launch method");
                          launch(widget.imageUrl.toString());
                          print("reached launch method end");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
