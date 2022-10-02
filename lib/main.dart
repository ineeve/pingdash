import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pingdash/systemwidget.dart';

void main() {
  runApp(const PingDashApp());
}

class PingDashApp extends StatelessWidget {
  const PingDashApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MainPage(title: 'PingDash'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            decoration: const InputDecoration.collapsed(hintText: 'IP address'),
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
