import 'package:casbin/casbin.dart';
import 'package:flutter/material.dart';
import 'backend.dart';
import 'data_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casbin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Casbin Demo App'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: username,
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () =>
                  authenticate(username.text, password.text, context),
              child: Text('Login'),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Text(
                'Alice - data1 read (password)\nBob - data2 read (password2)\nAdmin - data1 and data2 read (admin)\n',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.black26,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}

authenticate(String username, String password, BuildContext context) {
  if (login(username, password)) {
    // create model object by getting model string from backend
    final model = Model()..loadModelFromText(getModel());
    final enforcer = Enforcer.fromModelAndAdapter(model);

    // add user permission to enforcer object by getting policy strings from
    // the backend
    getPolicy().split('\n').forEach((element) {
      final user = element.split(',')[1].trim();
      final permission = element.split(',').sublist(2);

      enforcer.addPermissionForUser(user, permission);
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            DataScreen(username.toLowerCase().trim(), enforcer),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Incorrect username or password'),
      ),
    );
  }
}
