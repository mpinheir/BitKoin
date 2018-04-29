import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'currency.dart';
import 'dart:async';
import 'currencylist.dart';
import 'refreshrate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpandfeedback.dart';


void main() => runApp(new BitCoin());

class BitCoin extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'BitKoin',
			theme: new ThemeData(
				primaryColor: Colors.blue.shade200
			),
			home: new BitCoinHome(),
		);
	}

}

class BitCoinHome extends StatefulWidget{
	@override
  BitCoinHomeState createState() => new BitCoinHomeState();
}

class BitCoinHomeState extends State <BitCoinHome> {
	Currency _defaultCurrency;
	var _bitCoinValue;
	var timeUpdated;
	var updateRate;
	var refreshRate;
	var now = new DateTime.now();
	Timer timer;

	_loadPrefs() async{
		// obtain shared preferences 
		SharedPreferences prefs = await SharedPreferences.getInstance();

		String coin = prefs.getString('coin') ?? "USD";
		String coinDescription = prefs.getString('coinDescription') ?? "United States Dollar";
		
		_defaultCurrency = new Currency(coin, coinDescription);

		//if default refresh rate is not set then defaults to every 30 seconds.
		updateRate = prefs.getInt('refreshRate') ?? 30;

		refreshRate = new Duration(seconds:updateRate);
	}


	_loadData() async {

		//date + time when value was updated.
		now = new DateTime.now();

		//loads shared preferences
		SharedPreferences prefs = await SharedPreferences.getInstance();

		//if default currency is not set then defaults to US$
		String coin = prefs.getString('coin') ?? "USD";
		String coinDescription = prefs.getString('coinDescription') ?? "United States Dollar";
		
		//sets default currency global variable.
		_defaultCurrency = new Currency(coin, coinDescription);


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
				return new Drawer(
					child: new ListView(
						padding: const EdgeInsets.only(top: 0.0),
						children: <Widget>[
							new UserAccountsDrawerHeader(
								accountName: new Text("BitKoin"),
								accountEmail: null,
								currentAccountPicture: 
									new CircleAvatar(
										backgroundColor: Colors.brown,
										//child: new Text(_bitCoinAvatar),
										backgroundImage: new NetworkImage("https://upload.wikimedia.org/wikipedia/commons/5/50/Bitcoin.png"),
									),
							),

							new ListTile(
								leading: new Icon(Icons.home),
								title: new Text('Home'),
								onTap: () => Navigator.of(context).pop() //closed drawer
							),

            	new ListTile(
								leading: new Icon(Icons.attach_money),
								title: new Text('Set currency'),
								onTap: () async {
                	Navigator.of(context).pop(); //closed drawer
                
									_defaultCurrency = await Navigator.push(
             				 context,
              				new MaterialPageRoute(builder: (context) => new Currencylist()),
            			);

									//assumes default value in case user did NOT choose a valid currency
									if (_defaultCurrency == null){
										_loadPrefs(); //loads default currency information if defaultcurrency is returned as null.
									}

									_loadData();
              	}
							),

							new ListTile(
								leading: new Icon(Icons.timer),
								title: new Text('Set refresh rate'),
								onTap: () async{
									Navigator.of(context).pop(); //close drawer

									updateRate = await Navigator.of(context).push(
										new PageRouteBuilder(
											pageBuilder: (BuildContext context, _, __) {
												return new RefreshRateList();
											},
											transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
												return new FadeTransition(
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
										refreshRate = new Duration(seconds:updateRate);
										timer = new Timer.periodic(refreshRate, (Timer t) => _loadData());
									}
									
								}
							),

							new Divider(),

							new ListTile(
								leading: new Icon(Icons.help),
								title: new Text('Help & feedback'),
								onTap: () async {
                	Navigator.of(context).pop(); //closed drawer
                
									await Navigator.push(
             				 context,
              				new MaterialPageRoute(builder: (context) => new HelpAndFeedback()),
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

		refreshRate = new Duration(seconds:updateRate);
		timer = new Timer.periodic(refreshRate, (Timer t) => _loadData());
	}


	@override
  void initState(){
  	super.initState();

		_loadParms();	//loads default
  }

	//Layout vars
	

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			drawer: _buildDrawer(), 
			appBar: new AppBar(
				title: new Text('BitKoin'),
			),
			body: 
				new Center(
						child: new Column(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: 
								[
									new Column(
										children: [
											(_defaultCurrency==null) ? new Text( "" ) : new Text( '$_bitCoinValue', style: Theme.of(context).textTheme.display1),
											(_defaultCurrency==null) ? new Text( "loading" ) : new Text('${_defaultCurrency.description}' ),
										],
									),	
									new Column(
										children: [
											(_defaultCurrency==null) ? new Text( "" ) : new Text('Last updated:' ),
											(_defaultCurrency==null) ? new Text( "" ) : new Text('$now' ),
									]
									)
								],
						),
				),
		);
	}

}
