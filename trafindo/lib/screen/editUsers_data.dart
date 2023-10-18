import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUserDataScreen extends StatefulWidget {
  final QueryDocumentSnapshot userData;

  const EditUserDataScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditUserDataScreen> createState() => _EditUserDataScreenState();
}

class _EditUserDataScreenState extends State<EditUserDataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String selectedRole = ''; // To store the selected role
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the existing user data
    nameController.text = widget.userData['name'];
    emailController.text = widget.userData['email'];
    selectedRole = widget.userData['role'];
    locationController.text = widget.userData['location'];
  }

  void saveChanges() {
    // Save the changes to Firestore
    final updatedData = {
      'name': nameController.text,
      'email': emailController.text,
      'role': selectedRole,
      'location': locationController.text,
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData.id)
        .update(updatedData)
        .then((_) {
      Navigator.pop(context); // Close the edit screen after saving changes
    }).catchError((error) {
      // Handle errors here
      print("Error updating user data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:20.0, right: 20.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    border: InputBorder.none, // Remove default border
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:20.0, right: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['Customers', 'Admin', 'Super Admin'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:20.0, right: 20.0),
                child: TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
