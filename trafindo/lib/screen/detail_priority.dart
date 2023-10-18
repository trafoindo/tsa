import 'package:flutter/material.dart';

class DetailPriority extends StatelessWidget {
  final String tagNumber;
  final String manufacture;
  final String area;
  final String capacity;
  final String yearOfManufacture;
  final String status;
  final String recommendation;
  final String location;

  const DetailPriority({
    Key? key,
    required this.tagNumber,
    required this.manufacture,
    required this.area,
    required this.capacity,
    required this.yearOfManufacture,
    required this.status,
    required this.recommendation,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$tagNumber'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/image/trafo.png',
              height: 100,
            ),
            const SizedBox(height: 20.0,),
            const Text(
              'DETAIL INFORMATIONS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            ListTile(
              title: Text('Tag Number'),
              subtitle: Text(tagNumber),
            ),
            ListTile(
              title: Text('Manufacture'),
              subtitle: Text(manufacture),
            ),
            ListTile(
              title: Text('Area'),
              subtitle: Text(area),
            ),
            ListTile(
              title: Text('Capacity'),
              subtitle: Text(capacity),
            ),
            ListTile(
              title: Text('Year of Manufacture'),
              subtitle: Text(yearOfManufacture),
            ),
            ListTile(
              title: Text('Status'),
              subtitle: Text(status),
            ),
            ListTile(
              title: Text('Recommendation'),
              subtitle: Text(recommendation),
            ),
            ListTile(
              title: Text('Location'),
              subtitle: Text(location),
            )
            // Add more widgets to display additional details here
          ],
        ),
      ),
    );
  }
}
