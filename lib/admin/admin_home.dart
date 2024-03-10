import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:selling_bikes_app/admin/admin_bikes.dart';
import 'package:selling_bikes_app/admin/admin_list.dart';
import 'package:selling_bikes_app/auth/login.dart';

class AdminHome extends StatefulWidget {
  static const routeName = '/adminHome';
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
              backgroundColor: HexColor('#6bbcba'),
              title: Align(
                  alignment: Alignment.center, child: Text('الصفحة الرئيسية'))),
          body: Column(
            children: [
              Image.asset('assets/images/rented.jpg'),
              SizedBox(height: 20.h),
              Text(
                'الخدمات المتاحة',
                style: TextStyle(fontSize: 27, color: HexColor('#155564')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 19.w, left: 19.w),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                           Navigator.pushNamed(context, AdminBookings.routeName);
                        },
                        child:
                            card('assets/images/list.jfif', "طلبيات الشراء")),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AdminBike(
                              type: 'دراجة نارية',
                            );
                          }));
                        },
                        child: card(
                            'assets/images/motor.png', 'أضافة دراجة نارية')),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h, right: 20.w, left: 20.w),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AdminBike(
                              type: 'دراجة هوائية',
                            );
                          }));
                        },
                        child: card(
                            'assets/images/bike2.png', 'أضافة دراجة هوائية')),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                        child: card('assets/images/exit3.png', "تسجيل الخروج")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget card(String url, String text) {
  return Container(
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: 150.w,
        height: 150.h,
        child: Column(children: [
          SizedBox(
            height: 2.h,
          ),
          Container(width: 130.w, height: 100.h, child: Image.asset(url)),
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 18, color: HexColor('#32486d')))
        ]),
      ),
    ),
  );
}
