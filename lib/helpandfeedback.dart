import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndFeedback extends StatelessWidget{
	
  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppBar(
				title: Text('Help & Feedback'),
			),
			body:
        Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: 
								[
									Column(
										children: [
											Text( "Application created by Marcelo Pinheiro" ),
                      FlatButton(
                        onPressed: _launchURL,
                        child: new Text('Twitter @mpinheir', style: TextStyle(color: Colors.blue)),
                      ),
										],
									),	
									Text("Bitcoin data feed by Coindesk", style: TextStyle(color: Colors.blue) ),
                  Text("Github Repository" ),
								],
						),
				),
    );
  }

  _launchURL() async {
   const url = 'https://twitter.com/mpinheir';
   if (await canLaunch(url)) {
     await launch(url);
   } else {
      throw 'Could not launch $url';
    }
  }
}

