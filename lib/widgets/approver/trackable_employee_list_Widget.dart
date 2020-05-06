import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/pages/admin/attendanceDetail.dart';
import 'package:baniadam/pages/admin/trakingMap.dart';
import 'package:baniadam/widgets/approver/test.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';


class TrackableEmployeeListWidget extends StatelessWidget {

  final MainModel model;
  final String companyId;
  final DateTime date;

  TrackableEmployeeListWidget(this.model,this.companyId,this.date);

  Widget _buildEmployeeList(List<EmployeeList> employees) {
    Widget itemCards;
    if (employees.length > 0) {
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TrackableEmployeeItemCard(employees[index], index,model,companyId,date),
        itemCount: employees.length,
      );
    } else {
      itemCards = Container();
    }
    return itemCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildEmployeeList(model.allEmployees);
      },
    );
  }
}

class TrackableEmployeeItemCard extends StatelessWidget {
  final EmployeeList employee;
  final int employeeIndex;
  final MainModel model;
  final String companyId;
  final DateTime date;

  TrackableEmployeeItemCard(this.employee, this.employeeIndex,this.model, this.companyId,this.date);

  Widget _buildItemRow(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(ApiService.CDN_URl + "" + companyId + "/" + employee.image),
                  height: 70.0,
                  width: 50.0,
                  fit: BoxFit.contain,
                  placeholder: AssetImage('assets/dummy-man.png'),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 2.5 / 5,
                          child: Text(
                            employee.name,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
        trailing: Image.asset("assets/map_location.png",width: 25.0,),
        onTap: () async {
//          List<TrackingData> trackingDataList = await model.fetchTrackingData(employee.id, date);
////          if(trackingDataList.length>0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TrackingMap( model:model,id:employee.id, name: employee.name, date: date)));
////          }else{
////            Toast.show('No tracking record in selected date', context,
////                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
////          }
        },
      ));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          _buildItemRow(context),
        ],
      ),
    );
    ;
  }
}
