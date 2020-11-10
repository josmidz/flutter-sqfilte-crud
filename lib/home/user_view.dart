import 'package:contact_app/user/user.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  final User user;
  UserView({this.user});
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
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.nom,
                style: TextStyle(
                    color: Color(0xff3E2723), fontWeight: FontWeight.bold),
              ),
            ),
            if(user.favorite > 0)
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Favori",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0
                  ),
                ),
              )
          ],
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
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
      ),
    );
  }
}
