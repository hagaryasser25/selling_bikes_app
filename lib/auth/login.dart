import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:selling_bikes_app/auth/admin_login.dart';
import 'package:selling_bikes_app/auth/signup.dart';
import 'package:selling_bikes_app/user/user_home.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
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
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#6bbcba'), width: 2.0),
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
                            BorderSide(color: HexColor('#6bbcba'), width: 2.0),
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
                    child: Text('تسجيل الدخول',style: TextStyle(
                      color: Colors.white,
                    ),),
                    
                    onPressed: () async {
                      var email = emailController.text.trim();
                      var password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text("please fill all fields"))
                            .show(context);

                        return;
                      }

                      ProgressDialog progressDialog = ProgressDialog(context,
                          title: Text('Logging In'),
                          message: Text('Please Wait'));
                      progressDialog.show();

                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                                email: email, password: password);

                        if (userCredential.user != null) {
                          progressDialog.dismiss();
                         Navigator.pushNamed(context, UserHome.routeName);
                        }
                      } on FirebaseAuthException catch (e) {
                        progressDialog.dismiss();
                        if (e.code == 'user-not-found') {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("user not found"))
                              .show(context);

                          return;
                        } else if (e.code == 'wrong-password') {
                          MotionToast(
                                  primaryColor: Colors.blue,
                                  width: 300,
                                  height: 50,
                                  position: MotionToastPosition.center,
                                  description: Text("wrong email or password"))
                              .show(context);

                          return;
                        }
                      } catch (e) {
                        MotionToast(
                                primaryColor: Colors.blue,
                                width: 300,
                                height: 50,
                                position: MotionToastPosition.center,
                                description: Text("something went wrong"))
                            .show(context);

                        progressDialog.dismiss();
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.h,),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AdminLogin.routeName);
                    },
                    child: Text(
                      'تسجيل الدخول كأدمن',
                      style: TextStyle(color: HexColor('#6bbcba')),
                    )),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUp.routeName);
                      },
                      child: Text(
                        'اضغط هنا لأنشاء حساب',
                        style: TextStyle(color: HexColor('#6bbcba')),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
