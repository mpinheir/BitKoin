import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndFeedback extends StatelessWidget{
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppBar(
				title: Text('Help & Feedback'),
			),
      body: new Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'App by   ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Marcelo Pinheiro\n',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () { launch('https://twitter.com/mpinheir');
                  },
              ),
              TextSpan(
                text: 'Bitcoin data by ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'Coindesk\n',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () { launch('https://www.coindesk.com/coindesk-api');
                  },
              ),
              TextSpan(
                text: 'Github app repository',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () { launch('https://github.com/mpinheir/BitKoin');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }


}

