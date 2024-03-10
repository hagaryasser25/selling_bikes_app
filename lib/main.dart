import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:selling_bikes_app/admin/add_bike.dart';
import 'package:selling_bikes_app/admin/admin_home.dart';
import 'package:selling_bikes_app/admin/admin_list.dart';
import 'package:selling_bikes_app/auth/admin_login.dart';
import 'package:selling_bikes_app/auth/login.dart';
import 'package:selling_bikes_app/auth/signup.dart';
import 'package:selling_bikes_app/user/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com'
              ? const AdminHome()
              : UserHome(),
      routes: {
        SignUp.routeName: (ctx) => SignUp(),
        LoginPage.routeName: (ctx) => LoginPage(),
        AdminLogin.routeName: (ctx) => AdminLogin(),
        AdminHome.routeName: (ctx) => AdminHome(),
        UserHome.routeName: (ctx) => UserHome(),
        AddBike.routeName: (ctx) => AddBike(),
        AdminBookings.routeName: (ctx) => AdminBookings(),
      },
    );
  }
}
