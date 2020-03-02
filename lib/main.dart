import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'currency.dart';
import 'dart:async';
import 'currencylist.dart';
import 'refreshrate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpandfeedback.dart';


void main() => runApp(BitCoin());

class BitCoin extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'BitKoin',
			theme: ThemeData(
				primaryColor: Colors.blue.shade200
			),
			home: BitCoinHome(),
		);
	}

}

class BitCoinHome extends StatefulWidget{
	@override
  BitCoinHomeState createState() => BitCoinHomeState();
}

class BitCoinHomeState extends State <BitCoinHome> {
	Currency _defaultCurrency;
	var _bitCoinValue;
	var timeUpdated;
	var updateRate;
	var refreshRate;
	var now = DateTime.now();
	Timer timer;

	_loadPrefs() async{
		// obtain shared preferences 
		SharedPreferences prefs = await SharedPreferences.getInstance();

		String coin = prefs.getString('coin') ?? "USD";
		String coinDescription = prefs.getString('coinDescription') ?? "United States Dollar";
		
		_defaultCurrency = Currency(coin, coinDescription);

		//if default refresh rate is not set then defaults to every 30 seconds.
		updateRate = prefs.getInt('refreshRate') ?? 30;

		refreshRate = Duration(seconds:updateRate);
	}


	_loadData() async {

		//date + time when value was updated.
		now = DateTime.now();

		//loads shared preferences
		SharedPreferences prefs = await SharedPreferences.getInstance();

		//if default currency is not set then defaults to US$
		String coin = prefs.getString('coin') ?? "USD";
		String coinDescription = prefs.getString('coinDescription') ?? "United States Dollar";
		
		//sets default currency global variable.
		_defaultCurrency = Currency(coin, coinDescription);


		//Builds COINDESK query and processes returned JSON feed to 
		String dataURL = "https://api.coindesk.com/v1/bpi/currentprice/" + _defaultCurrency.symbol + ".json";
    http.Response response = await http.get(dataURL);
    setState(() {
      var _data = json.decode(response.body);
      _bitCoinValue = _data['bpi']['${_defaultCurrency.symbol}']['rate'];
			timeUpdated = _data['time']['updated'];
    });
  }

	Widget _buildDrawer(){
				return Drawer(
					child: ListView(
						padding: const EdgeInsets.only(top: 0.0),
						children: <Widget>[
							UserAccountsDrawerHeader(
								accountName: Text("BitKoin"),
								accountEmail: null,
								currentAccountPicture: 
									CircleAvatar(
										backgroundColor: Colors.brown,
										//child: Text(_bitCoinAvatar),
										backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/5/50/Bitcoin.png"),
									),
							),

							ListTile(
								leading: Icon(Icons.home),
								title: Text('Home'),
								onTap: () => Navigator.of(context).pop() //closed drawer
							),

            	ListTile(
								leading: Icon(Icons.attach_money),
								title: Text('Set currency'),
								onTap: () async {
                	Navigator.of(context).pop(); //closed drawer
                
									_defaultCurrency = await Navigator.push(
             				  context,
              			  MaterialPageRoute(builder: (context) => Currencylist()),
            			);

									//assumes default value in case user did NOT choose a valid currency
									if (_defaultCurrency == null){
										_loadPrefs(); //loads default currency information if defaultcurrency is returned as null.
									}

									_loadData();
              	}
							),

							ListTile(
								leading: Icon(Icons.timer),
								title: Text('Set refresh rate'),
								onTap: () async{
									Navigator.of(context).pop(); //close drawer

									updateRate = await Navigator.of(context).push(
										PageRouteBuilder(
											pageBuilder: (BuildContext context, _, __) {
												return RefreshRateList();
											},
											transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
												return FadeTransition(
													opacity: animation,
													child: child
												);
											}
										)
									);
								
									//Sets new refreh rate or retains current refresh rate in case user returned from refresh rate screen without selecting an option.
									if (updateRate != null){
										//Cancels current timer and sets new timer according to new refreshrate.
										timer.cancel();
										refreshRate = Duration(seconds:updateRate);
										timer = Timer.periodic(refreshRate, (Timer t) => _loadData());
									}
									
								}
							),

							Divider(),

							ListTile(
								leading: Icon(Icons.help),
								title: Text('Help & feedback'),
								onTap: () async {
                	Navigator.of(context).pop(); //closed drawer
                
									await Navigator.push(
             				 context,
              				MaterialPageRoute(builder: (context) => HelpAndFeedback()),
            			);
								}	
							)
						]
					)
				);
  }

	_loadParms() async {
		await _loadPrefs();
		await _loadData();

		refreshRate = Duration(seconds:updateRate);
		timer = Timer.periodic(refreshRate, (Timer t) => _loadData());
	}


	@override
  void initState(){
  	super.initState();

		_loadParms();	//loads default
  }

	//Layout vars
	

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			drawer: _buildDrawer(), 
			appBar: AppBar(
				title: Text('BitKoin'),
			),
			body: 
				Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: 
								[
									Column(
										children: [
											(_defaultCurrency==null) ? Text( "" ) : Text( '$_bitCoinValue', style: Theme.of(context).textTheme.display1),
											(_defaultCurrency==null) ? Text( "loading" ) : Text('${_defaultCurrency.description}' ),
										],
									),	
									Column(
										children: [
											(_defaultCurrency==null) ? Text( "" ) : Text('Last updated:' ),
											(_defaultCurrency==null) ? Text( "" ) : Text('$now' ),
									]
									)
								],
						),
				),
		);
	}

}
