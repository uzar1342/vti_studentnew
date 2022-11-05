import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';

import 'package:vti_student/home/profile/developer_webview_page.dart';
import 'package:vti_student/home/profile/feedback_page.dart';
import 'package:vti_student/home/profile/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool getNotifications = true;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomSheet: Container(
        margin: EdgeInsets.only(bottom: 70),
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "App developed & maintained by,",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeveloperWebviewPage(
                                  url: "https://virash.in/",
                                )));
                  },
                  child: Text(
                    "Virash Technologies LLP",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationsPage()));
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: primaryColor,
                    )),
                const Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                IconButton(
                  onPressed: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) => AlertDialog(
                    //           shape: const RoundedRectangleBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(16.0))),
                    //           title: Text(
                    //             "Logout",
                    //             style: TextStyle(
                    //                 color: Colors.red.shade400,
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //           content: const Text("Do you wish to logout?"),
                    //           actions: [
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.pop(context);
                    //               },
                    //               child: Text(
                    //                 "No",
                    //                 style: TextStyle(color: primaryColor),
                    //               ),
                    //             ),
                    //             // TextButton(
                    //             //   onPressed: () async {
                    //             //     Navigator.pushAndRemoveUntil(
                    //             //         context,
                    //             //         MaterialPageRoute(
                    //             //             builder: (context) =>
                    //             //                 const LoginPage()),
                    //             //         (route) => false);
                    //             //     Fluttertoast.showToast(
                    //             //         msg: "Logged out");
                    //             //   },
                    //             //   child: Text(
                    //             //     "Yes",
                    //             //     style: TextStyle(
                    //             //         color: primaryColor),
                    //             //   ),
                    //             // )
                    //             Container(
                    //               padding: const EdgeInsets.all(14.0),
                    //               decoration: BoxDecoration(
                    //                   color: primaryColor,
                    //                   borderRadius: const BorderRadius.all(
                    //                       Radius.circular(14.0))),
                    //               child: const Text(
                    //                 "Yes",
                    //                 style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //             ),
                    //           ],
                    //         ));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ProfilePage())));
                  },
                  icon: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            const Divider(),
            SwitchListTile(
                title: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: w * 0.08,
                    ),
                    const Text("Push Notifications"),
                  ],
                ),
                value: getNotifications,
                activeColor: primaryColor,
                onChanged: (value) {
                  setState(() {
                    getNotifications = !getNotifications;
                  });
                }),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
              leading: Icon(
                Icons.feedback,
                color: primaryColor,
              ),
              title: const Text("Help us improve?"),
              subtitle: const Text("Feel free to leave a feedback"),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.star,
                color: primaryColor,
              ),
              title: const Text("Like Us"),
              subtitle: const Text("Leave a review"),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeveloperWebviewPage(
                            url: "https://virash.in/about-us")));
              },
              leading: Icon(
                Icons.person,
                color: primaryColor,
              ),
              title: const Text("About Us"),
              subtitle: const Text("Want to know more about us"),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Share.share(
                    "Check out Virash for the best learning experience, https://www.virash.in/");
              },
              leading: Icon(
                Icons.share,
                color: primaryColor,
              ),
              title: const Text("Share"),
              subtitle: const Text("Share the joy of learning with peers"),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(),
          ],
        ),
      )),
    );
  }
}
