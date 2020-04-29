import 'dart:async';
import 'package:baniadam/base_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation extends StatefulWidget {
  var lat;
  var lng;
  MapLocation({Key key,this.lat,this.lng}) : super(key: key);

  _MapLocationState createState() => _MapLocationState();
}

class _MapLocationState extends BaseState<MapLocation> {
  Completer<GoogleMapController> _controller = Completer();
  var lat;
  var lng;
  static LatLng _location;

  @override
  void initState(){

    _location =LatLng(widget.lat,widget.lng);
    _onAddMarkerButtonPressed(_location);
    super.initState();
  }

  final Set<Marker> _markers = {};
  Set<Marker> _marker;

  LatLng _lastMapPosition = _location;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed(LatLng position) {
    setState(() {
      _markers.remove(position);
      _markers.add(Marker(
        draggable: true,
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  _onAddMarkerButtonPressed1(LatLng pos) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        draggable: true,
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(pos.toString()),
        position: pos,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Location on map'),
          ),
        ),
//        body: Text('test')
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 4/5,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _location,
                      zoom: 11.0,
                    ),
                    mapType: _currentMapType,
                    markers: _markers,
                    onCameraMove: _onCameraMove,
//                    onTap: (LatLng pos) {
//                      setState(() {
//                        _lastMapPosition = pos;
//                      });
//                      _onAddMarkerButtonPressed1(pos);
//                    },
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.all(15.0),
//                  child: Align(
//                    alignment: Alignment.topRight,
//                    child: Column(
//                      children: <Widget>[
//                        FloatingActionButton(
//                          heroTag: "btn1",
//                          onPressed: _onMapTypeButtonPressed,
//                          materialTapTargetSize: MaterialTapTargetSize.padded,
//                          backgroundColor: Colors.green,
//                          child: const Icon(Icons.map, size: 36.0),
//                        ),
//                        SizedBox(height: 16.0),
//                      ],
//                    ),
//                  ),
//                ),
              ],
            ),

          ],
        )
    );
  }
}
