import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RefreshRateList extends StatefulWidget{
	@override
  RefreshRateListState createState() => RefreshRateListState();
}

class RefreshRateListState extends State <RefreshRateList>{
  static final String routeName = '/refreshrate';

	final List<String> list = ["Every 30 seconds", "Every Minute", "Every 5 Minutes", "Every 15 Minutes", "Every 30 minutes",  "Every Hour", "Every 24 hours" ];
	final Map refreshRate = { 'Every 30 seconds': 30, 'Every Minute': 60, 'Every 5 Minutes': 300, 'Every 15 Minutes': 900, 'Every 30 minutes': 1800, 'Every Hour': 3600,'Every 24 hours': 90000 };


  void _savePrefs( int refreshRate ) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    prefs.setInt('refreshRate', refreshRate);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: 
        AppBar(
				  title: Text('Refresh rate'),
			  ),
			body: Center(
        child: ListView.builder(
              	itemCount: 7,
              	itemBuilder: (BuildContext context, int index){
                      return Column(
												children: <Widget>[
													 ListTile(
                        		title: Text(list[index]),
                        		onTap:(){
															_savePrefs(refreshRate[ list[index]]);
                            	Navigator.of(context).pop(refreshRate[ list[index] ] );
                						}
													),
												  Divider()
												],
											);
								}
				)
			)
		);
	}
}