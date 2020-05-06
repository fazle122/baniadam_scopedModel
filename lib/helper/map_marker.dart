import 'package:baniadam/models/EmployeeList.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';


/// [Fluster] can only handle markers that conform to the [Clusterable] abstract class.
///
/// You can customize this class by adding more parameters that might be needed for
/// your use case. For instance, you can pass an onTap callback or add an
/// [InfoWindow] to your marker here, then you can use the [toMarker] method to convert
/// this to a proper [Marker] that the [GoogleMap] can read.
//class MapMarker extends Clusterable {
//  final String id;
//  final LatLng position;
//  BitmapDescriptor icon;
//  InfoWindow infoWindow;
//  MarkerData markerData;
//
//  MapMarker({
//    @required this.id,
//    @required this.position,
//    this.icon,
//    isCluster = false,
//    clusterId,
//    pointsSize,
//    childMarkerId,
//    infoWindow,
//    this.markerData,
//  }) : super(
//          markerId: id,
//          latitude: position.latitude,
//          longitude: position.longitude,
//          isCluster: isCluster,
//          clusterId: clusterId,
//          pointsSize: pointsSize,
//          childMarkerId: childMarkerId,
//        );
//
//  Marker toMarker() => Marker(
//        markerId: MarkerId(isCluster ? 'cl_$id' : id),
//        position:LatLng(
//          position.latitude,
//          position.longitude,
//        ),
//        icon: icon,
////      infoWindow: InfoWindow(title: markerData.speed.toString(),snippet: markerData.activityType.toString())
////      infoWindow: InfoWindow(title: position.latitude.toString(),snippet: position.longitude.toString())
////      infoWindow: infoWindow.title != null && infoWindow.snippet != null ?InfoWindow(title: infoWindow.title,snippet: infoWindow.snippet):
////      InfoWindow(title: 'no data',snippet: 'no data')
//      );
//}


class MapMarker extends Clusterable {
  String heading;
  final String id;
  final LatLng position;
  BitmapDescriptor icon;
  InfoWindow infoWindow;
  final MarkerData markerData;

  MapMarker({
    this.heading,
    @required this.id,
    @required this.position,
    this.markerData,
    this.icon,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
    infoWindow,

  }) : super(
    markerId: id,
    latitude: position.latitude,
    longitude: position.longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    childMarkerId: childMarkerId,
  );

  Marker toMarker() => Marker(
      markerId: MarkerId(isCluster ? 'cl_$id' : id),
      icon: icon,
      rotation: heading == null ? 0.0:double.parse(heading),
      position: LatLng(position.latitude,position.longitude,),
      flat: true,
      infoWindow: markerData != null ? InfoWindow(
          title: '@ ' + convertDateFromString(markerData.activityAt) + ' - ' + formatActivityType(markerData.activityType),
          snippet: setSubtitle(markerData.isMoving,markerData.speed),
      ):null
  );

  convertDateFromString(String strDate){
    DateTime todayDate = DateTime.parse(strDate);
//    return formatDate(todayDate.toLocal(), [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]);
//    return formatDate(todayDate.toLocal(), [hh, ':', nn, ':', ss, ' ', am]);
    return formatDate(todayDate.toLocal(), [hh, ':', nn, ' ', am]);
  }

  formatActivityType(String activityType){
    String text = toBeginningOfSentenceCase(activityType);
    String activity;
    if(text.startsWith('I') || text.startsWith('O') || text.contains('_',2))
      {
        String subtext = text.substring(0,2);
        String firstPart = subtext.replaceAll(RegExp('_'), '');
        String lastPart = text.substring(3);
        activity = firstPart + ' ' + lastPart;
      }else{
      activity = text;
    }
    return activity;
  }

  setSubtitle(String isMoving,String speed){
    String subTitle;
    if(isMoving == "0"){
      subTitle = "Not moving";
    }else{
      subTitle = "Moving with speed " + speed + "/Km";
    }
    return subTitle;

  }
}
