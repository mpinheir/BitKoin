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
                        onPressed: ()=> _launchURL( 'https://twitter.com/mpinheir' ),
                        child: Text('Twitter @mpinheir', style: TextStyle(color: Colors.blue)),
                      ),
										],
									),
                  FlatButton(
                    onPressed: ()=> _launchURL( 'https://www.coindesk.com/coindesk-api' ),
                    child: Text("Data feed by Coindesk", style: TextStyle(color: Colors.blue)),
                  ),
                  FlatButton(
                    onPressed: ()=> _launchURL( 'http://bit.ly/BitKoinGithub' ),
                    child: Text("Bitkoin Github Repository", style: TextStyle(color: Colors.blue)),
                  ),
								],
						),
				),
    );
  }

  _launchURL( String url ) async {
   if (await canLaunch(url)) {
     await launch(url);
   } else {
      throw 'Could not launch $url';
    }
  }
}

