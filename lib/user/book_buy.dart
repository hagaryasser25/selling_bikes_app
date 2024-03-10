import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selling_bikes_app/admin/admin_home.dart';
import 'package:selling_bikes_app/user/user_home.dart';

class BookBike extends StatefulWidget {
  String name;
  String phoneNumber;
  String bikeName;
  String bikePrice;
  static const routeName = '/bookBike';
  BookBike(
      {required this.name,
      required this.phoneNumber,
      required this.bikeName,
      required this.bikePrice});

  @override
  State<BookBike> createState() => _BookBikeState();
}

class _BookBikeState extends State<BookBike> {
  var quantityController = TextEditingController();
  var wayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
            ),
            child: Padding(
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
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 65.h,
                    child: TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#6bbcba'), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: "الكمية",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 65.h,
                    child: TextField(
                      controller: wayController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#6bbcba'), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: "طريقة الأستلام",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: double.infinity, height: 65.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('#6bbcba'),
                      ),
                      onPressed: () async {
                        //int price = int.parse(priceController.text);
                        int quantity = int.parse(quantityController.text);
                        String way = wayController.text.trim();
                        String p = '${widget.bikePrice}';
                        int price = int.parse(p);
                        int total = price * quantity;

                        if (way.isEmpty || quantity == 0) {
                          CherryToast.info(
                            title: Text('Please Fill all Fields'),
                            actionHandler: () {},
                          ).show(context);
                          return;
                        }
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          DatabaseReference companyRef = FirebaseDatabase
                              .instance
                              .reference()
                              .child('bookings');

                          String? id = companyRef.push().key;
                          int dt = DateTime.now().millisecondsSinceEpoch;

                          await companyRef.child(id!).set({
                            'id': id,
                            'name': '${widget.bikeName}',
                            'price': price,
                            'amount': '${quantity}',
                            'total': total,
                            'userName': '${widget.name}',
                            'userPhone': '${widget.phoneNumber}',
                            'way': way,
                          });
                        }

                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('ادفع الأن'),
                                  content: Text('اختر طريقة الدفع'),
                                  actions: [
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.credit_card,
                                              size: 18),
                                          label: Text('بطاقة الأئتمان'),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Notice"),
                                                  content: SizedBox(
                                                    height: 65.h,
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor:
                                                            HexColor('#155564'),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xfff8a55f),
                                                              width: 2.0),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            'ادخل رقم الفيزا',
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary:
                                                            HexColor('#6bbcba'),
                                                      ),
                                                      child: Text("دفع"),
                                                      onPressed: () {},
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.credit_card,
                                              size: 18),
                                          label: Text('كاش'),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Notice"),
                                                  content: Text(
                                                      "تم الحجز وسيتم الدفع كاش"),
                                                  actions: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary:
                                                            HexColor('#6bbcba'),
                                                      ),
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            UserHome.routeName);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ));
                      },
                      child: Text('حفظ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: HexColor('#6bbcba'),
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, AdminHome.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم الحجز"),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
