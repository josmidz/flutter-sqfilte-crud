import 'dart:math';

import 'package:contact_app/add/addContact.dart';
import 'package:contact_app/home/add_favory_view.dart';
import 'package:contact_app/home/favori_view.dart';
import 'package:contact_app/home/user_view.dart';
import 'package:contact_app/list_colors.dart';
import 'package:contact_app/user/user.dart';
import 'package:flutter/material.dart';

class ContactHome extends StatefulWidget {
  @override
  _ContactHomeState createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHome> {
  BuildContext _ctx;
  List<User> _listUser = [];
  List<User> _listFavoriUser = [];

  @override
  void initState() {
    _loadContact();
    _loadFavoriesContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
        backgroundColor: Color(0xff3E2723),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Text(
              'Favori',
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 60,
            child: Row(
              children: [
                FloatingActionButton(
                  mini: true,
                  heroTag: 'b',
                  backgroundColor: Color(0xffBCAAA4),
                  child: Icon(Icons.add),
                  onPressed: () {
                    _showFavoriList();
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                    child: ListView.builder(
                        itemCount: _listFavoriUser.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () => _showFavoriDetails(user: _listFavoriUser[index]),
                            child: FavoriView(
                              user: _listFavoriUser[index],
                              color: listColors[Random().nextInt(listColors.length)],
                            ),
                          );
                        }))
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Column(
              children: [
                if (_listUser.length <= 0)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 32.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Aucun contact n'a été trouvé, veuillez en ajouter",
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (_, i) {
                          return Divider(
                            color: Color(0xffBCAAA4),
                          );
                        },
                        itemCount: _listUser.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key("${_listUser[index].id}"),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              _deleteUser(
                                  id: _listUser[index].id, index: index);
                            },
                            child: UserView(
                              user: _listUser[index],
                            ),
                          );
                        }),
                  )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffBCAAA4),
        heroTag: 'a',
        child: Icon(Icons.add),
        onPressed: _openAddContactScreen,
      ),
    );
  }

  void _openAddContactScreen() async {
    dynamic _result = await Navigator.of(_ctx)
        .push(MaterialPageRoute(builder: (context) => AddContact()));
    if (_result == true) {
      _loadContact();
    }
  }

  final _dbHelper = UserDbHelper();
  void _loadContact() async {
    _listUser = await _dbHelper.getUsers();
    setState(() {});
  }

  void _loadFavoriesContact() async {
    _listFavoriUser = await _dbHelper.getFavoriteUsers();
    setState(() {});
  }

  void _deleteUser({dynamic id, dynamic index}) async {
    dynamic _deleted = await _dbHelper.deleteUser(id);
    if (_deleted > 0) {
      _listUser.removeAt(index);
      _loadContact();
      _loadFavoriesContact();
    }
  }
 

  void _showFavoriList() {
    showModalBottomSheet(
        context: _ctx,
        builder: (context) {
          return Container(
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 70.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _listUser.length,
                        itemBuilder: (context, index) {
                          return AddFavoryView(
                            user: _listUser[index],
                            addFavori: _addToFavori,
                            removeFavori: _removeFromFavori,
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }


  void _showFavoriDetails({User user}) {
    showModalBottomSheet(
        context: _ctx,
        builder: (context) {
          return Container(
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 70.0,
                          height: 5.0,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: user.photo != null
                                      ? MemoryImage(user.photo)
                                      : AssetImage("assets/img/user_pic.png"),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Nom :",
                                style: TextStyle(
                                  color: Color(0xff3E2723),
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: Text(
                                user.nom,
                                style: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Description :",
                                style: TextStyle(
                                  color: Color(0xff3E2723),
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: Text(
                                user.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  

  void _addToFavori(dynamic id) async {
    Navigator.of(_ctx).pop();
    final _user = User(favorite: 1);
    dynamic _added = await _dbHelper.updateUser(user: _user,id:id);
    if (_added > 0) {
      _loadContact();
      _loadFavoriesContact();
    }
  }

  void _removeFromFavori(dynamic id) async {
    Navigator.of(_ctx).pop();
    final _user = User(favorite: 0);
    dynamic _added = await _dbHelper.updateUser(user: _user,id: id);
    if (_added > 0) {
      _loadContact();
      _loadFavoriesContact();
    }
  }
}
