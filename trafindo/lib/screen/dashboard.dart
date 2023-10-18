import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trafindo/screen/detail_priority.dart';
import 'package:trafindo/screen/offline_parts.dart';
import 'package:trafindo/screen/online_parts.dart';
import 'package:trafindo/screen/operating_normally.dart';

class DashboardScreen extends StatefulWidget {
  // const DashboardScreen({super.key});
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName = 'Loading...'; // Initial value while fetching data
  String _userLocation = 'Loading...'; // Initial value while fetching data

  final ref = FirebaseDatabase.instance
      .ref('1I9b0VzF8qr_d2mHbXlKEvL-QwIWsb1DGE6WszSKLwHs')
      .child('ConmonFilter');

  int totalTagNumber = 0;
  int offlinePartsReplacementNeededCount = 0;
  int onlinePartsReplacementNeededCount = 0;
  int operatingNormallyCount = 0;
  int offlineMaintenancePriorityCount = 0;

  List<Map<String, dynamic>> offlineMaintenancePriorityDataTemp = [];
  List<Map<String, dynamic>> offlinePartsReplacementNeededTemp = [];
  List<Map<String, dynamic>> onlinePartsReplacementNeededTemp = [];
  List<Map<String, dynamic>> operatingNormallyTemp = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // listen for changes
    ref.onValue.listen((event) {
      int total = 0;
      int offlinePartsReplacement = 0;
      int onlinePartsReplacement = 0;
      int operatingNormally = 0;
      int offlineMaintenancePriority = 0;

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value is List) {
        List<dynamic> values = snapshot.value as List<dynamic>;

        offlineMaintenancePriorityDataTemp.clear();
        offlinePartsReplacementNeededTemp.clear();
        onlinePartsReplacementNeededTemp.clear();
        operatingNormallyTemp.clear();

        for (var value in values) {
          if (value is Map<dynamic, dynamic> && value['status'] != null) {
            if (value['location'] == _userLocation) {
              total++;
              switch (value['status']) {
                case 'Offline Parts Replacement Needed':
                  offlinePartsReplacement++;
                  offlinePartsReplacementNeededTemp.add({
                    'tag_number': value['tag_number'],
                    'capacity': value['capacity'],
                    'manufacture': value['manufacture'],
                    'area': value['area'],
                    'year_of_manufacture': value['year_of_manufacture'],
                    'status': value['status'],
                    'recomendation': value['recomendation'],
                    'location': value['location'],
                  });
                  break;
                case 'Online Parts Replacement Needed':
                  onlinePartsReplacement++;
                  onlinePartsReplacementNeededTemp.add({
                    'tag_number': value['tag_number'],
                    'capacity': value['capacity'],
                    'manufacture': value['manufacture'],
                    'area': value['area'],
                    'year_of_manufacture': value['year_of_manufacture'],
                    'status': value['status'],
                    'recomendation': value['recomendation'],
                    'location': value['location'],
                  });
                  break;
                case 'Operating Normally':
                  operatingNormally++;
                  operatingNormallyTemp.add({
                    'tag_number': value['tag_number'],
                    'capacity': value['capacity'],
                    'manufacture': value['manufacture'],
                    'area': value['area'],
                    'year_of_manufacture': value['year_of_manufacture'],
                    'status': value['status'],
                    'recomendation': value['recomendation'],
                    'location': value['location'],
                  });
                  break;
                case 'Offline Maintenance Priority':
                  offlineMaintenancePriority++;
                  offlineMaintenancePriorityDataTemp.add({
                    'tag_number': value['tag_number'],
                    'capacity': value['capacity'],
                    'manufacture': value['manufacture'],
                    'area': value['area'],
                    'year_of_manufacture': value['year_of_manufacture'],
                    'status': value['status'],
                    'recomendation': value['recomendation'],
                    'location': value['location'],
                  });
                  break;
              }
            }
          }
        }

        setState(() {
          totalTagNumber = total;
          offlinePartsReplacementNeededCount = offlinePartsReplacement;
          onlinePartsReplacementNeededCount = onlinePartsReplacement;
          operatingNormallyCount = operatingNormally;
          offlineMaintenancePriorityCount = offlineMaintenancePriority;
        });
      }
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          _userName = userData[
              'name']; // Replace 'name' with the actual field name in Firestore
          _userLocation = userData[
              'location']; // Replace 'name' with the actual field name in Firestore
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  List<DataRow> _buildDataTableRows() {
    List<DataRow> rows = [];

    if (offlineMaintenancePriorityDataTemp.isEmpty) {
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
      for (var data in offlineMaintenancePriorityDataTemp) {
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

  Widget _buildPieChart() {
    if (totalTagNumber <= 0) {
      return const Text('Error: Tag Number should not 0');
    }

    try {
      return PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 20,
          sections: [
            PieChartSectionData(
              color: Colors.red,
              value: (offlineMaintenancePriorityCount / totalTagNumber) * 100,
              title:
                  "${((offlineMaintenancePriorityCount / totalTagNumber) * 100).toStringAsFixed(2)}%",
              radius: 50,
            ),
            PieChartSectionData(
              color: Colors.orange,
              value:
                  (offlinePartsReplacementNeededCount / totalTagNumber) * 100,
              title:
                  "${((offlinePartsReplacementNeededCount / totalTagNumber) * 100).toStringAsFixed(2)}%",
              radius: 50,
            ),
            PieChartSectionData(
              color: Colors.yellow,
              value: (onlinePartsReplacementNeededCount / totalTagNumber) * 100,
              title:
                  "${((onlinePartsReplacementNeededCount / totalTagNumber) * 100).toStringAsFixed(2)}%",
              radius: 50,
            ),
            PieChartSectionData(
              color: Colors.green,
              value: (operatingNormallyCount / totalTagNumber) * 100,
              title:
                  "${((operatingNormallyCount / totalTagNumber) * 100).toStringAsFixed(2)}%",
              radius: 50,
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle the exception gracefully, e.g., show an error message
      return const Text('Error: Unable to render the PieChart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _userName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Condition Monitoring',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$totalTagNumber ', //Total of tag_number
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
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
                      const VerticalDivider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Maintenance Priority',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$offlineMaintenancePriorityCount', //Total of tag_number with status "Offline Maintenance Priority"
                                  style: const TextStyle(
                                      fontSize: 32,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
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
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey,
              //         blurRadius: 2.0,
              //         spreadRadius: 0.0,
              //       ),
              //     ],
              //   ),
              //   height: 200,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       const Expanded(
              //         flex: 1,
              //         child: Padding(
              //           padding: EdgeInsets.all(10.0),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'Trafo Monitoring Chart',
              //                 style: TextStyle(fontWeight: FontWeight.bold),
              //               ),
              //               SizedBox(height: 10),
              //               Row(
              //                 children: [
              //                   CircleAvatar(
              //                     radius: 10,
              //                     backgroundColor: Colors.red,
              //                   ),
              //                   SizedBox(width: 3),
              //                   Text(
              //                     'Maintenance Priority',
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 10),
              //               Row(
              //                 children: [
              //                   CircleAvatar(
              //                     radius: 10,
              //                     backgroundColor: Colors.orange,
              //                   ),
              //                   SizedBox(width: 3),
              //                   Text(
              //                     'Offline Parts',
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 10),
              //               Row(
              //                 children: [
              //                   CircleAvatar(
              //                     radius: 10,
              //                     backgroundColor: Colors.yellow,
              //                   ),
              //                   SizedBox(width: 3),
              //                   Text(
              //                     'Online Parts',
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 10),
              //               Row(
              //                 children: [
              //                   CircleAvatar(
              //                     radius: 10,
              //                     backgroundColor: Colors.green,
              //                   ),
              //                   SizedBox(width: 3),
              //                   Text(
              //                     'Operating Normally',
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: _buildPieChart(),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Trafo Monitoring Chart ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Maintenance Priority : $offlineMaintenancePriorityCount',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.orange,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Offline Parts : $offlinePartsReplacementNeededCount',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.yellow,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Online Parts : $onlinePartsReplacementNeededCount',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.green,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Operating Normally : $operatingNormallyCount',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildPieChart(),
                    ),
                  ],
                ),
              ),

              // Container(
              //   decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.grey,
              //           blurRadius: 2.0,
              //           spreadRadius: 0.0,
              //         ),
              //       ],
              //     ),
              //   // width: MediaQuery.sizeOf(context).width,
              //   height: 200,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Text('Trafo Monitoring Chart', style: TextStyle(fontWeight: FontWeight.bold),),
              //       SizedBox(
              //         height: 150,
              //         child: _buildPieChart(),
              //       )
              //     ],
              //   ),

              // ),

              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OperatingNormallyScreen(
                            operatingNormallyData: operatingNormallyTemp,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: (MediaQuery.sizeOf(context).width / 3) - 20,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 152, 251, 152),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Image.asset(
                                  'assets/image/operation.png',
                                  width: 50,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Center(
                            child: Text(
                              'Operating Normally ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OnlinePartsReplacementScreen(
                            onlinePartsData: onlinePartsReplacementNeededTemp,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: (MediaQuery.sizeOf(context).width / 3) - 20,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 102),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Image.asset(
                                  'assets/image/online.png',
                                  width: 50,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Center(
                            child: Text(
                              'Online Parts ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OfflinePartsReplacementScreen(
                            offlinePartsData: offlinePartsReplacementNeededTemp,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: (MediaQuery.sizeOf(context).width / 3) - 20,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 166, 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Image.asset(
                                  'assets/image/offline.png',
                                  width: 50,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Center(
                            child: Text(
                              'Offline Parts ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SingleChildScrollView(
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
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
