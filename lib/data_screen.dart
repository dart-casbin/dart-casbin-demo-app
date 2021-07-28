import 'package:casbin/casbin.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class DataScreen extends StatelessWidget {
  final String username;
  final Enforcer enforcer;

  DataScreen(this.username, this.enforcer);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: username == 'bob' ? 1 : 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Casbin'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              },
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Data 1',
              ),
              Tab(
                text: 'Data 2',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            enforcer.enforce([username, 'data1', 'read'])
                ? TabContainer(
                    'This is Alice\'s data',
                    false,
                  )
                : TabContainer(
                    'You\'re not authorized to view this page',
                    true,
                  ),
            enforcer.enforce([username, 'data2', 'read'])
                ? TabContainer(
                    'This is Bob\'s data',
                    false,
                  )
                : TabContainer(
                    'You\'re not authorized to view this page',
                    true,
                  ),
          ],
        ),
      ),
    );
  }
}

class TabContainer extends StatelessWidget {
  final bool showRedBg;
  final String text;
  TabContainer(this.text, this.showRedBg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28.0),
      color: showRedBg ? Colors.red : Colors.white,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 32,
            color: showRedBg ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
