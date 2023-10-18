import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:trafindo/app/bottom_bar.dart';

class LocationOptionsScreen extends StatefulWidget {
  const LocationOptionsScreen({super.key});

  @override
  State<LocationOptionsScreen> createState() => _LocationOptionsScreenState();
}

class _LocationOptionsScreenState extends State<LocationOptionsScreen> {
  final ref = FirebaseDatabase.instance
      .ref('1I9b0VzF8qr_d2mHbXlKEvL-QwIWsb1DGE6WszSKLwHs')
      .child('Loc');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 195, 0, 16),
                Color.fromARGB(255, 238, 107, 109),
                Color.fromARGB(255, 195, 0, 16),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data?.snapshot.value;
                    if (data != null && data is Map) {
                      final locations = data.values.toList();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            child: Image.asset(
                              "assets/image/loc_options.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'Location Users',
                                style: boldTextStyle(size: 20, color: Colors.white),
                              ),
                              const Text(
                                'This is our customer actively engaging with and utilizing our app for their specific needs and preferences.',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Use ListView.builder to create rows with 2 locations in each row
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (locations.length / 2).ceil(),
                            itemBuilder: (context, index) {
                              final startIndex = index * 2;
                              final endIndex =
                                  (startIndex + 2 < locations.length)
                                      ? startIndex + 2
                                      : locations.length;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = startIndex; i < endIndex; i++)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const BottomBar(index: 0)),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.5 - 30,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Image.asset(
                                                "assets/image/${locations[i]['location_user']}.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  color: Colors.red,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 12.0, right: 12.0),
                                                  child: Text(locations[i]['location_user'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                ),
                                              ),
                                              ),
                                              // child: ElevatedButton(
                                              //   onPressed: () {
                                              //     // Handle button click for the location
                                              //   },
                                              //   child: Text(locations[i]
                                              //       ['location_user']),
                                              // ),
                                            ),
                                        ],
                                      ).paddingBottom(20),
                                    ),
                                  if (endIndex - startIndex == 1)
                                    const Spacer(), // Add spacer for single data
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    }
                  }

                  return const Text('No data available');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
