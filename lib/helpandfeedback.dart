import 'package:flutter/material.dart';

class HelpAndFeedback extends StatelessWidget{
	
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
			appBar: new AppBar(
				title: new Text('Help & Feedback'),
			),
			body:
        new Center(
						child: new Column(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: 
								[
									new Column(
										children: [
											new Text( "Application created by Marcelo Pinheiro" ),
											new Text( "Twitter @mpinheir" ),
										],
									),	
									new Text("Bitcoin data feed by Coindesk" ),
								],
						),
				),
    );
  }
}

