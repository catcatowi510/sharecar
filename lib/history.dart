import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <CustomListItem>[
        CustomListItem(
            image: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
            title: 'Three-line ListTile',
            subtitle: '31/12/2024 20:00 - 550.000 VND',
            status: Text('Hoàn thành', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.withOpacity(1.0))),
          ),

        CustomListItem(
          image: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
          title: 'Three-line ListTile',
          subtitle: '31/12/2024 20:00 - 550.000 VND',
          status: Text('Hoàn thành', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.withOpacity(1.0))),
        ),

        CustomListItem(
          image: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
          title: 'Three-line ListTile',
          subtitle: '31/12/2024 20:00 - 550.000 VND',
          status: Text('Hoàn thành', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.withOpacity(1.0))),
        )
        // Card(
        //   child: ListTile(
        //     leading: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
        //     title: Text('Three-line ListTile'),
        //     subtitle: Text(
        //       '31/12/2024 20:00 - 550.000 VND',
        //     ),
        //     //trailing: Icon(Icons.more_vert),
        //     //isThreeLine: true,
        //   ),
        // ),
        // Card(
        //   child: ListTile(
        //     leading: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
        //     title: Text('Three-line ListTile'),
        //     subtitle: Text(
        //       '31/12/2024 20:00 - 550.000 VND',
        //     ),
        //     //trailing: Icon(Icons.more_vert),
        //     //isThreeLine: true,
        //   ),
        // ),
        // Card(
        //   child: ListTile(
        //     leading: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
        //     title: Text('Three-line ListTile'),
        //     subtitle: Text(
        //       '31/12/2024 20:00 - 550.000 VND',
        //     ),
        //     //trailing: Icon(Icons.more_vert),
        //     //isThreeLine: true,
        //   ),
        // ),
        // Card(
        //   child: ListTile(
        //     leading: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
        //     title: Text('Three-line ListTile'),
        //     subtitle: Text(
        //       '31/12/2024 20:00 - 550.000 VND',
        //     ),
        //     //trailing: Icon(Icons.more_vert),
        //     //isThreeLine: true,
        //   ),
        // ),
        // Card(
        //   child: ListTile(
        //     leading: Image.asset('assets/images/bg_car.jpg', width: 50, height: 50, fit: BoxFit.cover),
        //     title: Text('Three-line ListTile'),
        //     subtitle: Text(
        //       '31/12/2024 20:00 - 550.000 VND',
        //     ),
        //     //trailing: Icon(Icons.more_vert),
        //     //isThreeLine: true,
        //   ),
        // ),
      ],
    );
  }
}
class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final Widget image;
  final String title;
  final String subtitle;
  final Text status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 1, child: image),
          Expanded(
            flex: 3,
            child: _ItemDescription(title: title, subtitle: subtitle, status: status),
          )
        ],
      ),
    );
  }
}

class _ItemDescription extends StatelessWidget {
  const _ItemDescription({required this.title, required this.subtitle, required this.status});

  final String title;
  final String subtitle;
  final Text status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(subtitle, style: const TextStyle(fontSize: 10.0)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          status,
        ],
      ),
    );
  }
}
