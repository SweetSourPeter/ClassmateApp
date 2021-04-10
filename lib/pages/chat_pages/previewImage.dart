// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io' show Platform;

class PreviewImage extends StatefulWidget {
  final String imageUrl;

  PreviewImage({this.imageUrl});

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  String savePath;

  Future<String> _findPath(String imageUrl) async {
    final cache = DefaultCacheManager();

    final tmp = await cache.getFileFromCache(imageUrl);

    return tmp.file.path;
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  _saveImage(source) async {
    await _requestPermission();
    if (Platform.isIOS) {
      _findPath(source).then((value) async {
        final result = await ImageGallerySaver.saveFile(value);
        if (result['isSuccess']) {
          _toastInfo('The image has been downloaded to your gallery!');
        } else {
          _toastInfo('Failed to download the image. Try again later.');
        }
      });
    } else if (Platform.isAndroid) {
      _findPath(source).then((value) async {
        final result = await ImageGallerySaver.saveFile(value);
        print(result);
        if (result['isSuccess']) {
          _toastInfo('The image has been downloaded to your gallery!');
        } else {
          _toastInfo('Failed to download the image. Try again later.');
        }
      });
    }
  }

  @override
  void initState() {
    // var appDocDir = await getTemporaryDirectory();
    // setState(() {
    //   savePath = appDocDir.path + "/temp.png";
    // });
    // await Dio().download(widget.imageUrl, savePath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
              child: Container(
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
            ),
            Container(
              color: Colors.black,
              child: InteractiveViewer(
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  height: MediaQuery.of(context).size.height - 300,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
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
                          _saveImage(widget.imageUrl);
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
