// ignore_for_file: unused_element, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_print, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/const/AppColors.dart';
import 'package:e_commerce_app/ui/bottom_nav_controller.dart';
import 'package:e_commerce_app/widgets/customButton.dart';
import 'package:e_commerce_app/widgets/myTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (_) => BottomNavController())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Sumbit the form to continue.",
                  style:
                      TextStyle(fontSize: 22.sp, color: AppColors.deep_green),
                ),
                Text(
                  "We will not share you information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                myTextField(
                    "enter your name", TextInputType.text, _nameController),
                myTextField("enter your phone number", TextInputType.number,
                    _phoneController),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "date of birth",
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "choose your gender",
                    prefixIcon: DropdownButton<String>(
                      items: gender.map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                            onTap: () {
                              setState(() {
                                _genderController.text = value;
                              });
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                myTextField(
                    "enter you age", TextInputType.number, _ageController),
                SizedBox(
                  height: 50.h,
                ),
                customButton("Continue", () => sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
