import 'dart:math' as math;

import 'package:latlong2/latlong.dart';



class LatLngBounds {

  late LatLng _sw;
  late LatLng _ne;

  LatLngBounds.fromPoints(List<LatLng> points) {
    if (points.isNotEmpty) {
      double? minX;
      double? maxX;
      double? minY;
      double? maxY;

      for (var point in points) {
        double x = point.longitudeInRad;
        double y = point.latitudeInRad;

        if (minX == null || minX > x) {
          minX = x;
        }

        if (minY == null || minY > y) {
          minY = y;
        }

        if (maxX == null || maxX < x) {
          maxX = x;
        }

        if (maxY == null || maxY < y) {
          maxY = y;
        }
      }
      _sw = LatLng(radianToDeg(minY as double), radianToDeg(minX as double));
      _ne = LatLng(radianToDeg(maxY as double), radianToDeg(maxX as double));
    }
  }

  /// Obtain coordinates of southwest corner of the bounds
  LatLng? get southWest => _sw;

  /// Obtain coordinates of northeast corner of the bounds
  LatLng? get northEast => _ne;
}