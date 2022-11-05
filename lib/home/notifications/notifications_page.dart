import 'package:flutter/material.dart';
import 'package:vti_student/configs/globals.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        // top: 10.0,
                        // left: 15.0,
                        ),
                    //padding: const EdgeInsets.only(left: 5.0),
                    height: h * 0.05,
                    width: h * 0.05,
                    decoration: BoxDecoration(
                        // color: primaryColor,
                        border: Border.all(color: Colors.black26, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black87,
                      size: 18.0,
                    ),
                  ),
                ),
                Text(
                  "Notifications",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0),
                ),
                IconButton(
                  onPressed: () {
                    //Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Expanded(child: ListView.builder(itemBuilder: (context, index) {
              return Container(
                //height: h * 0.2,
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  elevation: 3.0,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "09 Janurary 2022, Monday",
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: h * 0.09,
                              width: h * 0.09,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  image: DecorationImage(
                                      image: AssetImage(
                                    index % 2 == 0
                                        ? "assets/images/notifications.jpg"
                                        : "assets/images/notifications2.jpg",
                                  )),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                            ),
                            SizedBox(
                              width: w * 0.04,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: w * 0.58,
                                  child: const Text(
                                    "Hello, this is the title.",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Container(
                                  width: w * 0.58,
                                  child: const Text(
                                    "Hello, this is the notification subtitle, ok ok.",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.02,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            })),
          ],
        ),
      )),
    );
  }
}
