import 'package:contact_app/user/user.dart';
import 'package:flutter/material.dart';

class FavoriView extends StatelessWidget {
  final User user;
  final color;
  FavoriView({this.user,this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: color ?? Colors.blue)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: user.photo != null
                            ? MemoryImage(user.photo)
                            : AssetImage("assets/img/user_pic.png"),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle),
              ),
              Positioned(
                bottom: -2.0,
                right: 0.0,
                child: Icon(
                  Icons.brightness_1,
                  size: 17.0,
                  color: color ?? Colors.blue,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
