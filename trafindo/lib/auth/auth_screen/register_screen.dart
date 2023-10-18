import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trafindo/auth/auth_method.dart';
import 'package:trafindo/auth/snack_bar.dart';
import 'package:trafindo/auth/textfield_input.dart';
import 'package:trafindo/screen/user_data_screen.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ref = FirebaseDatabase.instance
      .ref('1I9b0VzF8qr_d2mHbXlKEvL-QwIWsb1DGE6WszSKLwHs')
      .child('Loc');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  TextEditingController selectedRoleController = TextEditingController();
  // TextEditingController selectedLocationController = TextEditingController();
  bool isLoading = false;

  List<String> roles = ['Customers', 'Admin', 'Super Admin'];
  String selectedRole = 'Customers';
  
  List<String> locations = [];
  String selectedLocation = 'Cilacap';

  @override
  void initState() {
    super.initState();

    ref.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        if (data.containsKey("location_user")) {
          dynamic locationUser = data["location_user"];
          if (locationUser is List) {
            setState(() {
              locations = locationUser.cast<String>();
              selectedLocation =
                  locations.isNotEmpty ? locations.first : 'Cilacap';
            });
          }
        }
      }
    });
  }

  void onRoleChanged(String? newRole) {
    setState(() {
      selectedRole = newRole ?? 'Customers';
    });
  }

  void onLocationChange(String? newLocation) {
    setState(() {
      selectedLocation = newLocation ?? 'Cilacap';
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    locationController.dispose();
    // selectedLocationController.dispose();
    selectedRoleController.dispose();
  }

  void signupUser() async {
    // set is loading to true.
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        location: selectedLocation,
        name: nameController.text,
        role: selectedRole);
    // if string return is success, user has been creaded and navigate to next screen other witse show error.
    if (res == "success") {
      // setState(() {
      //   isLoading = false;
      // });
      //navigate to the next screen
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DataUserScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register New Account"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                // const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset("assets/image/trafoindo_logo.jpeg"),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    'Company Name *',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                TextFieldInput(
                  textEditingController: nameController,
                  hintText: 'Enter your name',
                  textInputType: TextInputType.text,
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    'Email *',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                TextFieldInput(
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    'Password *',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    'Location *',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                TextFieldInput(
                    textEditingController: locationController,
                    hintText: 'Enter your location',
                    textInputType: TextInputType.text),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  child: Text(
                    'Role *',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(4)),
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: roles
                          .map((role) => DropdownMenuItem<String>(
                                value: role,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(
                                    role,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: onRoleChanged,
                    ),
                  ),
                ),
                InkWell(
                  onTap: signupUser,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          color: Colors.red),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 75,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
