import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Card(
          child: ListTile(
            leading: FlutterLogo(size: 72.0),
            title: Text('Three-line ListTile'),
            subtitle: Text(
              'A sufficiently long subtitle warrants three lines.',
            ),
            //trailing: Icon(Icons.more_vert),
            //isThreeLine: true,
          ),
        ),
      ],
    );
  }
}
