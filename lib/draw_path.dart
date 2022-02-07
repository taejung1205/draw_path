import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'latlng_bounds.dart';

class DrawPath {
  static const MethodChannel _channel = MethodChannel('draw_path');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //Return png byte file of map path(polyline) from list of LatLng
  static Future<Uint8List?> drawSinglePath(
      {required List<LatLng> points,
      Color color = Colors.black,
      double maxWidth = 200.0,
      double maxHeight = 200.0,
      Paint? paint,
      PaintingStyle paintingStyle = PaintingStyle.fill,
      double strokeWidth = 5,
      StrokeCap strokeCap = StrokeCap.round}) async {
    LatLngBounds bounds = LatLngBounds.fromPoints(points);


    double mapLat = bounds.northEast!.latitude - bounds.southWest!.latitude;
    double mapLng = bounds.northEast!.longitude - bounds.southWest!.longitude;
    double topLat = bounds.northEast!.latitude;
    double leftLng = bounds.southWest!.longitude;

    double width, height;


    UI.PictureRecorder pictureRecorder = UI.PictureRecorder();
    Canvas canvas = Canvas(
        pictureRecorder,);
    Paint canvasPaint;
    if (paint == null) {
      canvasPaint = Paint()
        ..color = color
        ..style = paintingStyle
        ..strokeWidth = strokeWidth
        ..strokeCap = strokeCap;
    } else {
      canvasPaint = paint;
      strokeWidth = paint.strokeWidth;
    }

    //큰쪽으로 통일
    if (mapLat < mapLng) {
      // Width is bigger
      width = maxWidth ;
      height = maxWidth * (mapLat / mapLng);
    } else {
      // Height is bigger
      width = maxHeight * (mapLng / mapLat);
      height = maxHeight;
    }

    


    if (points.length > 1) {
      Offset p1 = Offset(
        (points[0].longitude - leftLng) / mapLng * width + strokeWidth,
        (topLat - points[0].latitude) / mapLat * height + strokeWidth,
      );
      Offset p2 = Offset(
        (points[1].longitude - leftLng) / mapLng * width + strokeWidth ,
        (topLat - points[1].latitude) / mapLat * height + strokeWidth,
      );
      canvas.drawLine(p1, p2, canvasPaint);
      for (int i = 2; i < points.length; i++) {
        p1 = p2;
        p2 = Offset(
          (points[i].longitude - leftLng) / mapLng * width + strokeWidth,
          (topLat - points[i].latitude) / mapLat * height + strokeWidth,
        );
        canvas.drawLine(p1, p2, canvasPaint);
      }
    }

    print('drawRect');

    UI.Picture picture = pictureRecorder.endRecording();
    UI.Image image =
    await picture.toImage(width.toInt() + strokeWidth.toInt() * 2, height.toInt() + strokeWidth.toInt() * 2);
    ByteData? pngBytes = await image.toByteData(format: UI.ImageByteFormat.png);

    Uint8List pathImageByte;
    if (pngBytes != null) {
      pathImageByte = await pngBytes.buffer.asUint8List(
        pngBytes.offsetInBytes,
        pngBytes.lengthInBytes,
      );
      return pathImageByte;
    } else {
      print('pngBytes null!');
      return null;
    }
  }
}
