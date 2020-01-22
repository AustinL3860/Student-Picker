import 'package:flutter/material.dart';

class AboutWidget extends StatefulWidget {
  AboutWidget();

  @override
  createState() => new _AboutState();
}

class _AboutState extends State<AboutWidget> {

  static const AssetImage bannerImage = AssetImage('assets/banner.jpg');

  _AboutState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GGC Student Picker'),
        ),
        body: Column(children: <Widget>[
          Image(
            image: bannerImage,
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Created by:',
                            style: TextStyle(fontSize: 28.0),
                          ),
                          Text('Austin, Jerson, Phillip',
                            style: TextStyle(fontSize: 28.0),
                          ),
                          Text(
                            'ITEC 4550',
                            style: TextStyle(fontSize: 22.0),
                          ),
                          Image(
                            image: AssetImage('assets/istockphoto-691713206-612x612.jpg'),
                            height: 300.0,
                          ),
                          Text('12/3/2019', style: TextStyle(fontSize: 20.0)),
                        ]),
                  ))),
        ])
    );
  }
}
