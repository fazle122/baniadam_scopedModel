import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/pages/admin/attendanceDetail.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:intl/intl.dart';

class PresentListWidget extends StatelessWidget {

  final MainModel model;
  final String companyId;
  PresentListWidget(this.model,this.companyId);

  Widget _buildEmployeeList(List<EmployeeList> employees) {
    Widget itemCards;
    if (employees.length > 0) {
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            PresentEmployeeItemCard(employees[index], index,model,companyId),
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

class PresentEmployeeItemCard extends StatelessWidget {
  final EmployeeList employee;
  final int employeeIndex;
  final MainModel model;
  final String companyId;


  PresentEmployeeItemCard(this.employee, this.employeeIndex,this.model, this.companyId);

  Widget _buildItemRow(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListTile(
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
//              Container(
//                  decoration: BoxDecoration(
//                    border: Border.all(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
//                  ),
//                  padding: const EdgeInsets.only(left: 0.0),
//                  height: 60.0,
//                  width: 50.0,
//                  child: ApiService.CDN_URl == null?
//                  Material(
//                      borderRadius: BorderRadius.circular(5.0),
//                      child:Center(
//                          child: Icon(
//                            Icons.person,
//                            size: 40.0,
//                          )))
//                      :
//                  Material(
//                      borderRadius: BorderRadius.circular(5.0),
//                      child: employee.image == null ||
//                          employee.image == ""
//                          ? Center(
//                          child: Icon(
//                            Icons.person,
//                            size: 40.0,
//                          ))
//                          : Image.network(employee.image))
//              ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
//                      padding: EdgeInsets.all(18.0),
                    margin: EdgeInsets.only(top: 5.0),
                    child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
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
        trailing: Icon(Icons.sentiment_dissatisfied),
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AttendanceDetailListPageForAdmin(
                      model,
                      employee.id,
                      DateFormat('yyyy-MM-dd').format(DateTime.now())
                  )));
        },
      );
    });
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
