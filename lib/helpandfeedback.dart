import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndFeedback extends StatelessWidget{
	
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/marcelo.png'),
              ),
              Text('Marcelo Pinheiro',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                  color: Colors.blue,
                ),
              ),
              Card(
                color: Colors.blue[200],
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                    leading: Icon(
                      Icons.email,
                    color: Colors.blue[800],),
                    title: Text(
                        'Follow on Twitter',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blue[800  ]
                        ),
                    ),
                  ),
                ),
            ],
          ),
        )
      )

    );
  }


}

