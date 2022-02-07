import 'dart:async';
import 'dart:typed_data';

import 'package:draw_path/draw_path.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as ll;

import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Completer<GoogleMapController> _controller = Completer();
  Uint8List? _imageByte;

  Polyline _polyline = Polyline(
      polylineId: PolylineId('polyline'),
      points: [],
  );

  static final CameraPosition _initialPos = CameraPosition(
    target: LatLng(37.0, -120),
    zoom: 15,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Draw Path'),
        ),
        body: Center(
          child:  GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _initialPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: _onMapTap,
            polylines: {_polyline},
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _generateImage,
          child: Icon(Icons.add),
        ),
      );
  }

  void _onMapTap(LatLng latLng){
    print(latLng.latitude.toString() + " " + latLng.longitude.toString());
    _polyline.points.add(latLng);
    setState(() {});
  }

  _generateImage() async {
    print('Generate Image');
    _imageByte = await DrawPath.drawSinglePath(
        points: _latLngList(_polyline.points),
        strokeWidth: 30,
        maxWidth: 200,
        maxHeight: 200,
    );
    if(_imageByte == null) {
      return;
    } else {
      showDialog(context: context,
          builder: (context) =>
              Container(
                color: Colors.white,
                child: Image.memory(_imageByte!,),
              ));
    }
  }

  List<ll.LatLng> _latLngList(List<LatLng> list){
    List<ll.LatLng> newList = [];
    for(LatLng latLng in list){
      newList.add(ll.LatLng(latLng.latitude, latLng.longitude));
    }
    return newList;
  }
}
