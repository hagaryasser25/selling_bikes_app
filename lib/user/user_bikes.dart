import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:selling_bikes_app/models/bikes_model.dart';
import 'package:selling_bikes_app/user/book_buy.dart';

class UserBike extends StatefulWidget {
  String type;
  String name;
  String phone;
  static const routeName = '/rentedBike';
  UserBike({required this.type, required this.name, required this.phone});

  @override
  State<UserBike> createState() => _UserBikeState();
}

class _UserBikeState extends State<UserBike> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Bikes> bikesList = [];
  List<Bikes> searchList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    print(FirebaseAuth.instance.currentUser!.uid);
    super.didChangeDependencies();
    fetchDoctors();
  }

  @override
  void fetchDoctors() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("bikes").child('${widget.type}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Bikes p = Bikes.fromJson(event.snapshot.value);
      bikesList.add(p);
      searchList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
            appBar: AppBar(
                backgroundColor: HexColor('#6bbcba'),
                title: Text('شراء ${widget.type}')),
            body: Padding(
              padding: EdgeInsets.only(top: 20.h, right: 20.h, left: 20.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                        itemCount: bikesList.length,
                        itemBuilder: ((context, index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          right: 15,
                                          left: 15,
                                          bottom: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 100.w,
                                            height: 170.h,
                                            child: Image.network(
                                                '${bikesList[index].imageUrl.toString()}'),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                child: Text(
                                                    'نوع الدراجة : ${bikesList[index].name}',
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                  'السعر : ${bikesList[index].price}',
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              RatingBar.builder(
                                                initialRating: bikesList[index]
                                                    .rating!
                                                    .toDouble(),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 18,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate:
                                                    (double rating2) async {
                                                  rating2.toDouble();
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;

                                                  if (user != null) {
                                                    String uid = user.uid;
                                                    int date = DateTime.now()
                                                        .millisecondsSinceEpoch;

                                                    DatabaseReference
                                                        companyRef =
                                                        FirebaseDatabase.instance
                                                            .reference()
                                                            .child('bikes')
                                                            .child(
                                                                '${widget.type}')
                                                            .child(bikesList[
                                                                    index]
                                                                .id
                                                                .toString());

                                                    await companyRef.update({
                                                      'rating': rating2.toInt(),
                                                    });
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              ConstrainedBox(
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                        width: 100.w,
                                                        height: 40.h),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary:
                                                        HexColor('#6bbcba'),
                                                  ),
                                                  child: Text("شراء الان"),
                                                  onPressed: () async {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return BookBike(
                                                        name: '${widget.name}',
                                                        phoneNumber:
                                                            '${widget.phone}',
                                                        bikeName:
                                                            '${bikesList[index].name}',
                                                        bikePrice:
                                                            '${bikesList[index].price}',
                                                      );
                                                    }));
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h)
                              ],
                            ),
                          );
                        })),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
