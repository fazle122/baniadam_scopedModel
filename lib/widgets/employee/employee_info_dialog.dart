import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeInfoDialog extends StatefulWidget {
  final MainModel model;

  EmployeeInfoDialog(this.model);

  @override
  State<StatefulWidget> createState() {
    return _EmployeeInfoDialogState();
  }
}

class _EmployeeInfoDialogState extends BaseState<EmployeeInfoDialog> {
  String _path;
  FileType _pickingType;
  String _extension;
  String _fileName;
  var _imagePaths;
  bool updateImage = false;
  File galleryFile;

  @override
  void initState() {
    widget.model.fetchEmployeeInformation();
    widget.model.fetchCompanyId();
    super.initState();
  }

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (galleryFile != null) {
      setState(() {
        _fileName = galleryFile.path;
        _imagePaths = galleryFile.path;
        updateImage = true;
      });
    }
    setState(() {});
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
      height: 200.0,
      width: 300.0,
      child: file == null
          ? Center(
              child: Container(
                  padding: const EdgeInsets.only(left: 0.0),
                  height: 180.0,
                  width: 250.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    child: widget.model.employeeInformation.photoUrl != null &&
                            widget.model.employeeInformation.photoUrl != "''"
                        ? Image.network(ApiService.CDN_URl +
                            '' +
                            widget.model.companyId.companyID +
                            '/' +
                            widget.model.employeeInformation.photoUrl)
                        : Image.asset('assets/profile.png'),
                  )),
            )
          : Image.file(file),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(25.0),
        title: Center(child: Text('Personal information')),
        content: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                displaySelectedFile(galleryFile),
//                    Center(
//                      child: Container(
//                          padding: const EdgeInsets.only(left: 0.0),
//                          height: 120.0,
//                          width: 130.0,
//                          child: Material(
//                            borderRadius: BorderRadius.circular(5.0),
//                            child: widget.data['photoAttachment'] != null &&
//                                widget.data['photoAttachment'] != "''"
////                                ?Text(data['photoAttachment']):Text('null')
//                                ? Image.network(widget.data['photoAttachment'])
//                                : Image.asset('assets/profile.png'),
//                          )),
//                    ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.model.employeeInformation.empName,
                          style: TextStyle(
                              fontSize: 23.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.model.employeeInformation.empDesignation,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: InkWell(
                    child: Text(
                      updateImage ? 'Choose another' : 'Update image',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      imageSelectorGallery();
//                          _pickingType = FileType.IMAGE;
//                          _extension = 'jpg|jpeg|png';
//                          _getSelectedFile();
                    },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                SizedBox(height: 10.0),
                updateImage
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCancelButton(context),
                          _buildUpdateButton(context)
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 30.0,
                              color: Theme.of(context).buttonColor,
                              child: Center(
                                  child: Text(
                                'Ok',
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                            onTap: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ))
        // _filterOptions(context),
        );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return InkWell(
      child: Container(
        width: 100.0,
        height: 30.0,
        color: Theme.of(context).buttonColor,
        child: Center(
            child: Text(
          'Update',
          style: TextStyle(color: Colors.white),
        )),
      ),
      onTap: () async {
        _submitData(model.updateEmployeeProfilePic);
      },
    );
  }

  void _submitData(Function updateEmployeeProfilePic) {
    if (_imagePaths != null) {
      FormData formData = new FormData.from({
        "photoAttachment": new UploadFileInfo(new File(_imagePaths), _fileName),
      });
      updateEmployeeProfilePic(formData).then((Map<String, dynamic> response) {
        if(response = null){
          Toast.show('Something wrong, please try again.', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          Navigator.of(context).pop();
        }
        if (response['success']) {
          Toast.show(response['message'], context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          Navigator.of(context).pop();
        } else {
          Toast.show('Something wrong, please try again.', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          Navigator.of(context).pop();
        }
      });
    }

//      if (successinformation == null) {
//        Toast.show(
//            "Please make sure you provided all data properly.Maximum image size for photo attachment is 100KB",
//            context,
//            duration: Toast.LENGTH_SHORT,
//            gravity: Toast.CENTER);
//      } else if (successinformation['success']) {
//        Toast.show(successinformation['message'], context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//        String photoUrl;
//        final Map<String, dynamic> detailData =
//            await ApiService.getEmployeeDetail();
//        if (detailData != null) {
//          setState(() {
//            photoUrl = detailData['photoAttachment'];
//          });
//        }
//        Navigator.of(context, rootNavigator: true).pop(photoUrl);
////      Toast.show(successinformation['message'], context,
////          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
////      Navigator.of(context, rootNavigator: true).pop('success');
//      } else {
//        Toast.show(successinformation['message'], context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//      }
  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
      child: Container(
        width: 100.0,
        height: 30.0,
        color: Theme.of(context).buttonColor,
        child: Center(
            child: Text(
          'Cancel',
          style: TextStyle(color: Colors.white),
        )),
      ),
      onTap: () async {
        Navigator.of(context).pop();
      },
    );
  }
}
