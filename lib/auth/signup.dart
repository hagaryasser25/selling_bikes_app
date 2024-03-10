import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:ndialog/ndialog.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/SignUp';
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: EdgeInsets.only(right: 10.w, left: 10.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  height: 65.h,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: HexColor('#155564'),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#155564'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'اسم المستخدم',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  height: 65.h,
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#155564'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'رقم الهاتف',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  height: 65.h,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#155564'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'البريد الألكترونى',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  height: 65.h,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#155564'), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'كلمة المرور',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: double.infinity, height: 65.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor('#6bbcba'),
                    ),
                    child: Text('انشاء حساب',style: TextStyle(
                      color: Colors.white,
                    ),),
                    onPressed: () async {
                      var name = nameController.text.trim();
                      var phoneNumber = phoneNumberController.text.trim();
                      var email = emailController.text.trim();
                      var password = passwordController.text.trim();

                      if (name.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          phoneNumber.isEmpty) {
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text("please fill all fields"))
                            .show(context);

                        return;
                      }

                      if (password.length < 6) {
                        // show error toast
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text(
                                    "Weak Password, at least 6 characters are required"))
                            .show(context);

                        return;
                      }

                      ProgressDialog progressDialog = ProgressDialog(context,
                          title: Text('Signing Up'),
                          message: Text('Please Wait'));
                      progressDialog.show();

                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        User? user = userCredential.user;

                        if (userCredential.user != null) {
                          DatabaseReference userRef = FirebaseDatabase.instance
                              .reference()
                              .child('users');

                          String uid = userCredential.user!.uid;
                          int dt = DateTime.now().millisecondsSinceEpoch;

                          await userRef.child(uid).set({
                            'name': name,
                            'email': email,
                            'password': password,
                            'uid': uid,
                            'dt': dt,
                            'phoneNumber': phoneNumber,
                          });

                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        } else {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("failed"))
                              .show(context);
                        }
                        progressDialog.dismiss();
                      } on FirebaseAuthException catch (e) {
                        progressDialog.dismiss();
                        if (e.code == 'email-already-in-use') {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("email is already exist"))
                              .show(context);
                        } else if (e.code == 'weak-password') {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("password is weak"))
                              .show(context);
                        }
                      } catch (e) {
                        progressDialog.dismiss();
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text("something went wrong"))
                            .show(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
