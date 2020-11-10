import 'package:contact_app/user/user.dart';
import 'package:flutter/material.dart';

class AddFavoryView extends StatelessWidget {
  final User user;
  AddFavoryView({this.user, this.removeFavori, this.addFavori});
  final Function(dynamic id) removeFavori;
  final Function(dynamic id) addFavori;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: user.photo != null
                      ? MemoryImage(user.photo)
                      : AssetImage("assets/img/user_pic.png"),
                  fit: BoxFit.cover),
              shape: BoxShape.circle),
        ),
        title: Text(
          user.nom,
          style:
              TextStyle(color: Color(0xff3E2723), fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Column(
          children: [
            if (user.favorite ==0)
              FlatButton.icon(
                color: Color(0xff3E2723),
                  onPressed: () {
                    addFavori(user.id);
                  },
                  icon: Icon(Icons.add,color: Colors.white),
                  label: Text("Ajouter",style: TextStyle(color: Colors.white),))
            else
              FlatButton.icon(
                color: Colors.redAccent,
                  onPressed: () {
                    removeFavori(user.id);
                  },
                  icon: Icon(Icons.delete_forever,color: Colors.white),
                  label: Text("Elever",style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
