import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trafindo/screen/detail_priority.dart';

class OperatingNormallyScreen extends StatefulWidget {
  final List<Map<String, dynamic>> operatingNormallyData;

  const OperatingNormallyScreen({Key? key, required this.operatingNormallyData})
      : super(key: key);

  @override
  _OperatingNormallyScreenState createState() =>
      _OperatingNormallyScreenState();
}

class _OperatingNormallyScreenState extends State<OperatingNormallyScreen> {
  final StreamController<int> _countController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    // Listen for changes in operatingNormallyData and update the count
    _countController.add(widget.operatingNormallyData.length);
  }

  @override
  void dispose() {
    // Dispose of the stream controller
    _countController.close();
    super.dispose();
  }
  

  List<DataRow> _buildDataTableRows() {
    List<DataRow> rows = [];

    if (widget.operatingNormallyData.isEmpty) {
      // If there's no data, create a single row with hyphens
      rows.add(const DataRow(
        cells: [
          DataCell(Text('null')),
          DataCell(Text('nul')),
          DataCell(Text('null')),
          DataCell(Text('null')),
        ],
      ));
    } else {
      for (var data in widget.operatingNormallyData) {
        final tagNumber = data['tag_number'];
        final capacity = data['capacity'];
        final manufacture = data['manufacture'];
        final area = data['area'];
        final yearOfManufacture = data['year_of_manufacture'];
        final status = data['status'];
        final recomendation = data['recomendation'];
        final location = data['location'];

        rows.add(DataRow(
          cells: [
            DataCell(GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPriority(
                      tagNumber: tagNumber,
                      manufacture: manufacture,
                      area: area,
                      capacity: capacity,
                      yearOfManufacture: yearOfManufacture,
                      status: status,
                      recommendation: recomendation,
                      location: location,
                    ),
                  ),
                );
              },
              child: Text(
                tagNumber,
                style: const TextStyle(color: Colors.red),
              ),
            )),
            DataCell(Text(capacity)),
            DataCell(Text(area)),
            DataCell(Text(manufacture)),
          ],
        ));
      }
    }
    return rows;
  }

  // Future<void> _handleRefresh() async {
  //   return await Future.delayed(const Duration(seconds: 2));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operating Normally Data'),
      ),
      body: Column(
        children: [
          StreamBuilder<int>(
            stream: _countController.stream,
            initialData: widget.operatingNormallyData.length,
            builder: (context, snapshot) {
              // Display the real-time count
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 152, 251, 152),
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Operating Normally',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${snapshot.data}',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Image.asset(
                            'assets/image/transformer.png',
                            width: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Tag Number',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Capacity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Area',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Manufacture',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                  rows: _buildDataTableRows(),
                ),
              ),
            )
          ),
          const SizedBox(height: 20.0,)
        ],
      ),
    );
  }
}
