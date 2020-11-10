import 'dart:io';
import 'dart:typed_data';

import 'package:contact_app/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _nomController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Uint8List _userPhoto;
  BuildContext _ctx;
  final _dbHelper = UserDbHelper();

  _hideKeyboard({BuildContext context}) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return GestureDetector(
      onTap: () => _hideKeyboard(context: context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff3E2723),
          title: Text('Ajout'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: _userPhoto == null
                              ? AssetImage('assets/img/user_pic.png')
                              : MemoryImage(_userPhoto),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showPhotoBottomSheet(context: context);
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xff3E2723),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Entrez votre nom SVP',
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(width: 1.0, color: Color(0xff3E2723)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(width: 1.0, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                constraints: BoxConstraints(maxHeight: 100.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(width: 1.0, color: Color(0xff3E2723)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          BorderSide(width: 1.0, color: Colors.grey[400]),
                    ),
                  ),
                  // maxLines: 3,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: _saveUser,
                    child: Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff3E2723),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FlatButton(
                    onPressed:_annulerFx,
                    child: Text(
                      'Annuler',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff3E2723),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  File _image;
  final picker = ImagePicker();

  Future _getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _userPhoto = await pickedFile.readAsBytes();
    }
    setState(() {});
  }

  Future _getImageFromGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _userPhoto = await pickedFile.readAsBytes();
    }
    setState(() {});
  }

  void _saveUser() async {
    if (_nomController.text.isEmpty || _descriptionController.text.isEmpty) {
      _showDialog(sms: "Veuillez renseigner les informations demandées");
    } else if (_userPhoto == null) {
      _showDialog(sms: "Veuillez sélectionner ou capturer une image");
    } else {
      final _random = DateTime.now().millisecondsSinceEpoch;
      var _imageName = "${_random}user_pic.png";
      final _user = User(
          description: _descriptionController.text.trim().toLowerCase(),
          nom: _nomController.text.trim().toLowerCase(),
          favorite: 0,
          photo: _imageName);
      dynamic _saved = await _dbHelper.insertUser(user: _user);
      //-save user pic
      dynamic _pic = await _dbHelper.saveImageFileLocally(
          bytes: _userPhoto, filename: _imageName);
      if (_saved > 0) {
        Navigator.of(_ctx).pop(true);
      }
    }
  }

  void _annulerFx() {
    _nomController.clear();
    _descriptionController.clear();
    _userPhoto = null;
    setState(() {});
  }

  void _showDialog({String title, String sms}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext _) {
          return CupertinoAlertDialog(
            title: Text(
              title ?? "Message",
              style: TextStyle(color: Color(0xff3E2723)),
            ),
            content: Container(
              child: Text(
                sms ?? "Information",
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            actions: [
              OutlineButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              )
            ],
          );
        });
  }

  void _showPhotoBottomSheet({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 0.2 * MediaQuery.of(context).size.height,
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  // color: ctColor10,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: ListTile(
                          leading: Icon(Icons.photo_camera),
                          onTap: () {
                            Navigator.of(context).pop();
                            _getImageFromCamera();
                          },
                          title: Text("Prendre une photo"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            _getImageFromGalery();
                          },
                          leading: Icon(Icons.photo_library),
                          title: Text("Choisir une photo"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
