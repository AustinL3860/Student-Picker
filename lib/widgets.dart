import 'package:flutter/material.dart';

class widget extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new Container(child: new Text(''));
  }
}

class banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var assetsImage = new AssetImage('Images/banner.jpg');
var image = new Image(image: assetsImage, width: 40.0, height: 40.0);
    return new Container(child: image);
  }
}
