import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';

class SubmitAssignmentPage extends StatefulWidget {
  const SubmitAssignmentPage({Key? key}) : super(key: key);

  @override
  _SubmitAssignmentPageState createState() => _SubmitAssignmentPageState();
}

class _SubmitAssignmentPageState extends State<SubmitAssignmentPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
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
                            border:
                                Border.all(color: Colors.black26, width: 1.0),
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
                      "Submit Assignment",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsPage()));
                        },
                        icon: Icon(
                          Icons.notifications,
                          color: primaryColor,
                        )),
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                const Text(
                  "Python Assignment 1",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "9th Janurary 2022",
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "11: 59 PM",
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.school,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Vipeen Jaiswal",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  height: h * 0.55,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                  ),
                  child: Center(
                      child: SfPdfViewer.network(
                          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
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
