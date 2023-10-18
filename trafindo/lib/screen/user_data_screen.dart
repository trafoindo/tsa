import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trafindo/screen/editUsers_data.dart';

class DataUserScreen extends StatefulWidget {
  const DataUserScreen({Key? key}) : super(key: key);

  @override
  State<DataUserScreen> createState() => _DataUserScreenState();
}

class _DataUserScreenState extends State<DataUserScreen> {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection("users").snapshots();

  List<QueryDocumentSnapshot> usersData = [];

  // To Update the user data
  void editUserData(QueryDocumentSnapshot userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserDataScreen(userData: userData),
      ),
    );
  }

  // To Delete the User data from firestore (still not deleted from firebase authentication)
  void deleteUserAndAuth(String uid) async {
    // Get the user by UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Delete the user's authentication (email and UID) from Firebase Authentication
      try {
        await user.delete();
      } catch (e) {
        print("Error deleting user authentication: $e");
      }
    }

    // Delete user's data from Firestore
    await FirebaseFirestore.instance.collection("users").doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users Data"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("No data available");
          }

          usersData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: usersData.length,
            itemBuilder: (context, index) {
              final data = usersData[index].data() as Map<String, dynamic>;
              // final userUid = data['uid'];

              // Future<void> deleteUser(String userUid) async {
              //   final user = FirebaseAuth.instance.currentUser;

              //   if (user != null && user.uid == userUid) {
              //     try {
              //       // Konfirmasi penggunaan AlertDialog
              //       await showDialog(
              //         context: context,
              //         builder: (context) {
              //           return AlertDialog(
              //             title: const Text("Confirmation Delete User."),
              //             content: const Text("Are you sure you want to delete this user?"),
              //             actions: [
              //               TextButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: const Text("Cancel"),
              //               ),
              //               TextButton(
              //                 onPressed: () async {
              //                   Navigator.of(context).pop();
              //                   // Menghapus data pengguna dari Firestore
              //                   await FirebaseFirestore.instance
              //                       .collection("users")
              //                       .doc(userUid)
              //                       .delete();

              //                   // Menghapus akun autentikasi pengguna
              //                   await user.delete();

              //                   // Perbarui antarmuka pengguna setelah penghapusan
              //                   setState(() {
              //                     usersData.removeWhere((element) => element['uid'] == userUid);
              //                   });
              //                 },
              //                 child: const Text("Delete"),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     } catch (e) {
              //       print("Error deleting user: $e");
              //     }
              //   }
              // }

              // void deleteDataAndUser() async {
              //   final user = FirebaseAuth.instance.currentUser;

              //   if (user != null && user.uid == userUid) {
              //     try {
              //       // Delete user data from Firestore
              //       await FirebaseFirestore.instance
              //           .collection("users")
              //           .doc(data['uid'])
              //           .delete();

              //       // Delete the user's authentication account
              //       await user.delete();

              //       // Refresh the UI to reflect the changes
              //       setState(() {
              //         usersData.removeAt(index);
              //       }
              //       );
              //     } catch (e) {
              //       print("Error deleting user: $e");
              //     }
              //   }
              // }

              return Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                child: Column(
                  children: [
                    SizedBox(
                      // width: MediaQuery.sizeOf(context).width,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data['name']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '${data['email']}',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                '${data['role']}',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  editUserData(usersData[index]);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteUserAndAuth(
                                                      data['uid']);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                            title: const Text(
                                                "Delete User Account"),
                                            contentPadding:
                                                const EdgeInsets.all(20.0),
                                            content: const Text(
                                                "Are you sure want to delete this user account?"),
                                          ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // void deleteUserAndAuth(String uid) async {
  //   // Delete user's data from Firestore
  //   await FirebaseFirestore.instance.collection("users").doc(uid).delete();

  //   // Delete the user's authentication
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await user.delete();
  //   }
  // }
}
