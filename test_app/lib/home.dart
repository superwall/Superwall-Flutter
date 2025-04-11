import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class Home extends StatelessWidget {
// Home screen with buttons to trigger Superwall events and navigation.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/configureTest');
                  },
                  child: Text("Configuration test")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/subscriptionStatusTest');
                  },
                  child: Text("Subscription Status Test")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/purchaseControllerTest');
                  },
                  child: Text("Purchase Controller Test")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/delegateTest');
                  },
                  child: Text("Delegate Test")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/handlerTest');
                  },
                  child: Text("Handler Test")),
            ],
          ),
        ),
      );
}
