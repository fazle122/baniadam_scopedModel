import 'dart:async';
import 'package:baniadam/base_state.dart';
import 'package:baniadam/helper/map_helper.dart';
import 'package:baniadam/helper/map_marker.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:date_format/date_format.dart';
import 'package:scoped_model/scoped_model.dart';



class TrackingMap extends StatefulWidget{
  final MainModel model;
  final String id;
  final DateTime date;
  final String name;

  TrackingMap({
    this.model,
    this.id,
    this.date,
    this.name,
    Key key,
  }) : super(key: key);

  _TrackingMapState createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap>{

  List markerData = [];

  @override
  void initState() {
    widget.model.fetchTrackingData(widget.id, widget.date);
    _getMarkerData();
    super.initState();
  }

  _getMarkerData() async{
    final data =  await widget.model.fetchMarkerData(widget.id, widget.date);
    if(data != null){
      setState(() {
        markerData = data['data'];
      });
    }
  }

  Widget _buildMap() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No tracking data found!'));
        if (model.allTrackingData.length > 0 && !model.isLoading) {
          content = TrackingMapWidget(markerData);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return content;
//        return RefreshIndicator(onRefresh: (){
//          widget.model.fetchTrackingData(widget.id, widget.date);
//        }, child: content,) ;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.name + ' on ' + widget.date.toString(),style: TextStyle(fontSize: 15.0),),
    ),
      body: _buildMap(),
    );
  }

}

class TrackingMapWidget extends StatefulWidget {
  final trackData;
//  final String id;
//  final DateTime date;
//  final String name;

  TrackingMapWidget(
    this.trackData,
//    this.id,
//    this.date,
//    this.name,
);

  @override
  _TrackingMapWidgetState createState() => _TrackingMapWidgetState();
}


class _TrackingMapWidgetState extends BaseState<TrackingMapWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = Set();
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 20;
  Fluster<MapMarker> _clusterManager;
  double _currentZoom = 14;
  bool _isMapLoading = true;
  bool _areMarkersLoading = true;
  final String _markerImageUrl = 'https://img.icons8.com/office/80/000000/marker.png';
  final Color _clusterColor = Colors.blue;
  final Color _clusterTextColor = Colors.white;

  final List<LatLng> polyLinePoints = <LatLng>[];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  List data;
  Position myPosition;
  static BitmapDescriptor myIcon;
  static BitmapDescriptor startMarkerIcon;
  static BitmapDescriptor endMarkerIcon;
  static BitmapDescriptor myIcon1;
  final List<MarkerData> markerData1 = <MarkerData>[];
  final List<MarkerData> markerData2 = <MarkerData>[];
  final List<MarkerData> markerData3 = <MarkerData>[];

  double centerLat;
  double centerLong;

  Marker topMarker;
  Marker bottomMarker;




  @override
  void initState() {
    data = widget.trackData;
//    _getTrackingData();
    getCurrentLocation();
    getMarkerImage();
    getMarkerData(data);
    collectPolyLinePoints(data);
    setCenter(data);

    super.initState();
  }


  void getCurrentLocation() async{
    Position pos = await Geolocator().getCurrentPosition();
    if(pos!= null) {
      setState(() {
        myPosition = pos;
      });
    }
  }

  getMarkerImage(){
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/arrow_direction.png')
        .then((onValue) {
      setState(() {
        myIcon = onValue;
      });
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/marker_end.png')
        .then((onValue) {
      setState(() {
        startMarkerIcon = onValue;
      });
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/marker_end.png')
        .then((onValue) {
      setState(() {
        endMarkerIcon = onValue;
      });
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/arrow_up.png')
        .then((onValue) {
      setState(() {
        myIcon1 = onValue;
      });
    });
  }

  getMarkerData(data) async{

    for (int index = 0; index < data.length; index++) {
      await markerData2.add(
          _createMarkerDate(data[index]['id'],data[index]['activity_type'].toString(),data[index]['activity_at_raw'].toString(),data[index]['speed'].toString(),
              data[index]['latitude'].toString(),data[index]['longitude'].toString(),data[index]['heading'].toString(),data[index]['is_moving'].toString())
      );
    }
  }


  collectPolyLinePoints(data){
    for(int i=0; i<data.length;i++){
      polyLinePoints.add(_createLatLng(double.parse(data[i]['latitude']),double.parse(data[i]['longitude'])));

      if(i == 0 ){
        topMarker = Marker(
            markerId: MarkerId('first'),
            position: LatLng(double.parse(data[i]['latitude']),double.parse(data[i]['longitude'])),
            infoWindow: InfoWindow(title:convertDateFromString(data[i]['activity_at_raw'])),
//            icon: BitmapDescriptor.defaultMarker
            icon: startMarkerIcon
        );
      }
      if(i == data.length-1){
        bottomMarker = Marker(
            markerId: MarkerId('last'),
            position: LatLng(double.parse(data[i]['latitude']),double.parse(data[i]['longitude'])),
            infoWindow: InfoWindow(title:convertDateFromString(data[i]['activity_at_raw'])),
//            icon: BitmapDescriptor.defaultMarker,
            icon:endMarkerIcon
        );
      }
    }
  }

  setCenter(data){
    List lat =[];
    List long =[];
    for (int index = 0; index < data.length-1; index++) {
      double latitude = double.parse(data[index]['latitude']);
      double longitude = double.parse(data[index]['longitude']);

      if(!latitude.isNegative) lat.add(latitude);
      if(!longitude.isNegative) long.add(longitude);
    }

    lat.sort();
    long.sort();

    double minLat = lat.first;
    double maxLat = lat.last;
    double minLong = long.first;
    double maxLong = long.last;

    setState(() {
      centerLat = (minLat+maxLat)/2;
      centerLong = (minLong+maxLong)/2;
    });


  }



  convertDateFromString(String strDate){
    DateTime todayDate = DateTime.parse(strDate);
//    return formatDate(todayDate.toLocal(), [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);
    return formatDate(todayDate.toLocal(), [hh, ':', nn, ':', ss, ' ', am]);
  }





  void _initMarkers() async {
    final List<MapMarker> markers = [];
    for (MarkerData data in markerData1) {
      final BitmapDescriptor markerImage =
      await MapHelper.getMarkerImageFromUrl(_markerImageUrl);
      await markers.add(
        MapMarker(
//          heading: data.heading,
          id: 'i'+data.id.toString(),//'i' => info icon
          position: LatLng(double.parse(data.latitude),double.parse(data.longitude)),
          icon: markerImage,
          markerData: MarkerData(data.id,data.activityType,data.activityAt,data.speed,data.latitude,data.longitude,data.heading,data.isMoving),
        ),
      );
    }

    for (MarkerData data in markerData2) {
      await markers.add(
        MapMarker(
          heading: data.heading,
          id: 'd'+data.id.toString(),//'d' => direction
          position: LatLng(double.parse(data.latitude),double.parse(data.longitude)),
          icon: myIcon,
          markerData: MarkerData(data.id,data.activityType,data.activityAt,data.speed,data.latitude,data.longitude,data.heading,data.isMoving),
        ),
      );
    }
    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      50,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }



  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    setState(() {
      _isMapLoading = false;
    });
    _addPolyline();
    _initMarkers();
  }

//  Future<bool> _onBackPressed() {
//    Navigator.pushReplacement(context, MaterialPageRoute(
//        builder: (context) => TrackableEmployeesForAdmin()
//    ));
//  }


  getMarkersForMap(){
    Set<Marker> tmpMarkers = Set();
    tmpMarkers.add(topMarker);
    tmpMarkers.addAll(_markers.toSet());
    tmpMarkers.add(bottomMarker);
    return tmpMarkers;
  }




  void _addPolyline() {
    final int polylineCount = polylines.length;
    if (polylineCount == 12) {
      return;
    }
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);
    final Polyline polyline = Polyline(
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: polyLinePoints,
      onTap: () {
//        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  MarkerData _createMarkerDate(int id,String activityType,String activityAt,String speed,String latitude,String longitude,String heading,String isMoving ) {
    return MarkerData(id,activityType,activityAt,speed,latitude,longitude,heading,isMoving);
  }




  @override
  Widget build(BuildContext context) {
       return
           data.length> 0 ?  myPosition == null? Center(child:CircularProgressIndicator()) : Stack(
            children: <Widget>[
              // Google Map widget
              Opacity(
                opacity: _isMapLoading ? 0 : 1,
                child: GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
//                    target: LatLng(myPosition.latitude, myPosition.longitude),//avg_lat = (max_lat+min_lat)/2,avg_lon = (max_lon+min_lon)/2// intended to place at CENTER
                    target: LatLng(centerLat, centerLong),
                    zoom: _currentZoom,
                  ),

                  markers: getMarkersForMap(),
//                  markers: Set<Marker>.of(_markers),
                  polylines: Set<Polyline>.of(polylines.values),
                  onMapCreated: (controller) => _onMapCreated(controller),
                  onCameraMove: (position) => _updateMarkers(position.zoom),
                ),
              ),

              // Map loading indicator
              Opacity(
                opacity: _isMapLoading ? 1 : 0,
                child: Center(child: CircularProgressIndicator()),
              ),

              // Map markers loading indicator
              if (_areMarkersLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      elevation: 2,
                      color: Colors.grey.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Loading',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ): CircularProgressIndicator();
  }
}





