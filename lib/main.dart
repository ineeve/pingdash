import 'package:flutter/material.dart';
import 'package:pingdash/systemwidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'PingDash'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SystemWidget> _systems = [];
  final TextEditingController _controller = TextEditingController();

  Widget _buildPopup(BuildContext context) {
    return AlertDialog(
      title: const Text('Add System'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration.collapsed(hintText: 'ip address'),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _systems = [
                ..._systems,
                SystemWidget(
                  ip: _controller.text,
                  deleteCb: (String ip) {
                    setState(() {
                      _systems.removeWhere((element) => element.ip == ip);
                      _systems = [...(_systems)];
                    });
                  },
                )
              ];
            });
            _controller.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          childAspectRatio: 2,
          crossAxisCount: 3,
          children: _systems,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopup(context),
          );
        },
        tooltip: 'Add System',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
