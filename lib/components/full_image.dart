import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:simplechat/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
class FullPhoto extends StatelessWidget {
  final String url;
  const FullPhoto({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colorPrimary1,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Full Image'),
        centerTitle: true,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(url),
        ),
      ),
    );
  }
}

