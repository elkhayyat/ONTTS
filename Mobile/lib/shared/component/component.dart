import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

void navigateTo(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Directionality(textDirection: TextDirection.ltr, child: widget)));
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) =>
            Directionality(textDirection: TextDirection.ltr, child: widget)),
    (Route<dynamic> route) => false,
  );
}

Widget cachedImage(image, {double width = 150.0, double height = 225.0}) {
  return CachedNetworkImage(
    imageUrl: image,
    width: width,
    height: height,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    ),
    placeholder: (context, url) => Center(
      child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: loadingIcon(),
      ),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

void showToast({required String message, required Color backgroundColor}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor,
      textColor: Colors.yellowAccent,
      fontSize: paragraphFontSize);
}

Widget loadingIcon({Color? color}) {
  if (Platform.isIOS) {
    return const CupertinoActivityIndicator();
  } else {
    return color != null
        ? CircularProgressIndicator(
            color: color,
          )
        : const CircularProgressIndicator();
  }
}

