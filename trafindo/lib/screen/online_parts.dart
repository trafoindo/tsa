// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class OnlinePartsReplacement extends StatefulWidget {
//   const OnlinePartsReplacement({super.key});

//   @override
//   State<OnlinePartsReplacement> createState() => _OnlinePartsReplacementState();
// }

// class _OnlinePartsReplacementState extends State<OnlinePartsReplacement> {

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   // String _userName = 'Loading...'; // Initial value while fetching data
//   String _userLocation = 'Loading...'; // Initial value while fetching data

//   final ref = FirebaseDatabase.instance
//       .ref('1I9b0VzF8qr_d2mHbXlKEvL-QwIWsb1DGE6WszSKLwHs')
//       .child('ConmonFilter');

//   int totalTagNumber = 0;
//   int offlinePartsReplacementNeededCount = 0;
//   int onlinePartsReplacementNeededCount = 0;
//   int operatingNormallyCount = 0;
//   int offlineMaintenancePriorityCount = 0;

//   List<Map<String, dynamic>> offlineMaintenancePriorityDataTemp = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();

//     // listen for changes
//     ref.onValue.listen((event) {
//       DataSnapshot snapshot = event.snapshot;

//       if (snapshot.value is List) {
//         List<dynamic> values = snapshot.value as List<dynamic>;

//       offlineMaintenancePriorityDataTemp.clear();

//         int total = 0;
//         int offlinePartsReplacement = 0;
//         int onlinePartsReplacement = 0;
//         int operatingNormally = 0;
//         int offlineMaintenancePriority = 0;

//         for (var value in values) {
//           if (value is Map<dynamic, dynamic> && value['status'] != null) {
//             if (value['location'] == _userLocation) {
//               total++;
//               switch (value['status']) {
//                 case 'Offline Parts Replacement Needed':
//                   offlinePartsReplacement++;
//                   break;
//                 case 'Online Parts Replacement Needed':
//                   onlinePartsReplacement++;
//                   break;
//                 case 'Operating Normally':
//                   operatingNormally++;
//                   break;
//                 case 'Offline Maintenance Priority':
//                   offlineMaintenancePriority++;
//                   offlineMaintenancePriorityDataTemp.add({
//                     'tag_number': value['tag_number'],
//                     'capacity': value['capacity'],
//                     'manufacture': value['manufacture'],
//                     'area': value['area'],
//                     'year_of_manufacture': value['year_of_manufacture'],
//                     'status': value['status'],
//                     'recomendation': value['recomendation'],
//                     'location': value['location'],
//                   });
//                   break;
//               }
//             }
//           }
//         }
      
//         setState(() {
//           totalTagNumber = total;
//           offlinePartsReplacementNeededCount = offlinePartsReplacement;
//           onlinePartsReplacementNeededCount = onlinePartsReplacement;
//           operatingNormallyCount = operatingNormally;
//           offlineMaintenancePriorityCount = offlineMaintenancePriority;
//         });
//       }
//     });
//   }

//   Future<void> _loadUserData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         final userData =
//             await _firestore.collection('users').doc(user.uid).get();
//         setState(() {
//           // _userName = userData['name']; // Replace 'name' with the actual field name in Firestore
//           _userLocation = userData['location']; // Replace 'name' with the actual field name in Firestore
//         });
//       }
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Online Parts Replacement Needed'
//         ),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width-40,
//                 height: 100,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color.fromARGB(255, 152, 251, 152),
//                       blurRadius: 2.0,
//                       spreadRadius: 2.0,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Online Parts Replacement Needed',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     const SizedBox(
//                       height: 5.0,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '$onlinePartsReplacementNeededCount', 
//                           style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           width: 10.0,
//                         ),
//                         Image.asset(
//                           'assets/image/transformer.png',
//                           width: 30,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 15.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trafindo/screen/detail_priority.dart';

class OnlinePartsReplacementScreen extends StatefulWidget {
  final List<Map<String, dynamic>> onlinePartsData;

  const OnlinePartsReplacementScreen({Key? key, required this.onlinePartsData})
      : super(key: key);

  @override
  _OnlinePartsReplacementScreenState createState() =>
      _OnlinePartsReplacementScreenState();
}

class _OnlinePartsReplacementScreenState extends State<OnlinePartsReplacementScreen> {
  final StreamController<int> _countController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    // Listen for changes in onlinePartsData and update the count
    _countController.add(widget.onlinePartsData.length);
  }

  @override
  void dispose() {
    // Dispose of the stream controller
    _countController.close();
    super.dispose();
  }
  

  List<DataRow> _buildDataTableRows() {
    List<DataRow> rows = [];

    if (widget.onlinePartsData.isEmpty) {
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
      for (var data in widget.onlinePartsData) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Parts Replacement Needed'),
      ),
      body: Column(
        children: [
          StreamBuilder<int>(
            stream: _countController.stream,
            initialData: widget.onlinePartsData.length,
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
                        color: Color.fromARGB(255, 255, 255, 102),
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Online Parts Replacement Needed',
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
