import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/assignments/assignments_page.dart';
import 'package:vti_student/home/assignments/submit_assignment_page.dart';
import 'package:vti_student/home/calendar/calendar_page.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';
import 'package:vti_student/home/resources/all_resources_page.dart';
import 'package:vti_student/home/video_lectures/all_video_lectures_page.dart';

import 'package:vti_student/home/video_lectures/video_lecture_paid_page.dart';

class CourseDetailsPage extends StatefulWidget {
  final String courseId, courseName, courseDuration;
  const CourseDetailsPage(
      {Key? key,
      required this.courseId,
      required this.courseName,
      required this.courseDuration})
      : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  bool isVideoLectures = true;

  bool isLoading = true;
  int activePageIndex = 0;

  List<dynamic> courseDetails = [];
  List<dynamic> upComingLectures = [];

  fetchCourseDetails() async {
    final url = Uri.parse(Urls().courseDetailsUrl);
    var body = json.encode([
      {
        "mobile_number": userPhone,
        "student_id": userId,
        "course_id": widget.courseId,
      }
    ]);

    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        courseDetails = jsonDecode(response.body);

        isLoading = false;
      });
    }
  }

  fetchUpComingSchedule() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().lectureScheduleUrl);

    var body = json.encode([
      {
        "mobile_number": userPhone,
        "student_id": userId,
        "course_id": widget.courseId,
      }
    ]);

    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    ); 

    if (response.statusCode == 200) {
      setState(() {
        upComingLectures = jsonDecode(response.body);

        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchCourseDetails();
    fetchUpComingSchedule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * 0.35,
                      ),
                      SpinKitFadingCube(
                        color: primaryColor,
                      )
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                border: Border.all(
                                    color: Colors.black26, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black87,
                              size: 18.0,
                            ),
                          ),
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
                            ))
                      ],
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Text(
                      widget.courseName,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    ),
                    SizedBox(
                      height: h * 0.015,
                    ),
                    const Text(
                      "By Virash Training Institute",
                      style: TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: h * 0.04,
                    ),
                    Container(
                      height: h * 0.25,
                      width: w,
                      decoration: const BoxDecoration(
                          // color: primaryColor,
                          // image: DecorationImage(
                          //     image: NetworkImage(graphicsList[5]['banner']),
                          //     fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(
                        Radius.circular(14.0),
                      )),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14.0),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: graphicsList[5]['banner'],
                          placeholder: (context, url) => SpinKitChasingDots(
                            color: primaryColor,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    const Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           isVideoLectures = true;
                    //         });
                    //       },
                    //       child: Container(
                    //         height: 50,
                    //         width: w * 0.4,
                    //         decoration: BoxDecoration(
                    //           color: isVideoLectures
                    //               ? primaryColor
                    //               : Colors.grey.shade200,
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(14.0),
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Icon(
                    //               Icons.play_circle,
                    //               color: isVideoLectures
                    //                   ? Colors.white
                    //                   : primaryColor,
                    //             ),
                    //             Text(
                    //               "Lecture Details",
                    //               style: TextStyle(
                    //                   color: isVideoLectures
                    //                       ? Colors.white
                    //                       : primaryColor),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           isVideoLectures = false;
                    //         });
                    //       },
                    //       child: Container(
                    //         height: 50,
                    //         width: w * 0.4,
                    //         decoration: BoxDecoration(
                    //           color: !isVideoLectures
                    //               ? primaryColor
                    //               : Colors.grey.shade200,
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(14.0),
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Icon(
                    //               Icons.assignment,
                    //               color: !isVideoLectures
                    //                   ? Colors.white
                    //                   : primaryColor,
                    //             ),
                    //             Text(
                    //               "Teacher Notes",
                    //               style: TextStyle(
                    //                   color: !isVideoLectures
                    //                       ? Colors.white
                    //                       : primaryColor),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: h * 0.02,
                    // ),
                    Center(child: _menuBar(context)),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    AnimatedSwitcher(
                        // transitionBuilder:
                        //     (Widget child, Animation<double> animation) =>
                        //         Transition(
                        //           sizeFactor: animation,
                        //           child: child,
                        //         ),
                        duration: const Duration(milliseconds: 500),
                        child: isVideoLectures
                            ? Container(
                                key: const ValueKey<int>(0),
                                child: _videoLectures(),
                              )
                            : Container(
                                key: const ValueKey<int>(1),
                                child: _resourcesLectures(),
                              )),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    _upComingLectures(),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    _assignments()
                  ],
                ),
        ),
      )),
    );
  }

  _resourcesLectures() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Resources / Notes",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ],
        ),
        const Text(
          "Notes, pdfs, links any resources shared by the faculties will be displayed here.",
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: 5,
            itemBuilder: (context, index) {
              if (index == 4) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllResourcesPage()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "View More",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0))),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          index % 2 == 0
                              ? Icon(Icons.picture_as_pdf,
                                  color: Colors.red.shade300)
                              : const FaIcon(
                                  FontAwesomeIcons.globe,
                                  color: Colors.blue,
                                ),
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Container(
                            width: w * 0.7,
                            child: index % 2 == 0
                                ? const Text(
                                    "Code example of looping in Java",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    "How to setup Flutter in windows",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }

  _upComingLectures() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Lectures",
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        ListView.builder(
            itemCount:
                upComingLectures.length < 3 ? upComingLectures.length : 3,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              if (index == 2) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalendarPage(
                                  lecutres: upComingLectures,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "View More",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                width: w,
                margin: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 3.0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.amber.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/python_logo.png",
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  width: w * 0.02,
                                ),
                                const Text(
                                  "Django Framework",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                )
                              ],
                            ),
                            upComingLectures[index]['training_mode'] == "Online"
                                ? Container(
                                    padding: const EdgeInsets.all(5.0),
                                    height: h * 0.04,
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: Row(
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.globe,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                        SizedBox(
                                          width: w * 0.01,
                                        ),
                                        const Text(
                                          "Online",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(5.0),
                                    height: h * 0.04,
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: Row(
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.school,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                        SizedBox(
                                          width: w * 0.01,
                                        ),
                                        const Text(
                                          "Offline",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        ),

                        const Divider(),

                        Row(
                          children: [
                            const Text(
                              "Chapter : ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Learning the basic",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Row(
                        //       children: const [
                        //         Icon(
                        //           Icons.access_time,
                        //           color: Colors.blue,
                        //         ),
                        //         SizedBox(
                        //           width: 4.0,
                        //         ),
                        //         Text(
                        //           "06:00 PM",
                        //           style: TextStyle(
                        //               color: Colors.black54,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       width: w * 0.02,
                        //     ),
                        //     const Icon(
                        //       Icons.arrow_forward,
                        //       color: Colors.black26,
                        //     ),
                        //     SizedBox(
                        //       width: w * 0.02,
                        //     ),
                        //     Row(
                        //       children: [
                        //         Icon(
                        //           Icons.access_time,
                        //           color: Colors.red.shade300,
                        //         ),
                        //         const SizedBox(
                        //           width: 4.0,
                        //         ),
                        //         const Text(
                        //           "07:30 PM",
                        //           style: TextStyle(
                        //               color: Colors.black54,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: h * 0.01),
                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Instructor : ",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  upComingLectures[index]['faculty_name'],
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),

                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Colors.purple.shade200,
                                ),
                                SizedBox(
                                  width: w * 0.02,
                                ),
                                Text(
                                  "${upComingLectures[index]['day']} | ${upComingLectures[index]['lecture_date']}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),

                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled,
                                  color: Colors.green.shade200,
                                ),
                                SizedBox(
                                  width: w * 0.01,
                                ),
                                Text(upComingLectures[index]['start_time'],
                                    style:
                                        const TextStyle(color: Colors.black54)),
                              ],
                            ),
                            const Text(
                              "To",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled,
                                  color: Colors.red.shade200,
                                ),
                                SizedBox(
                                  width: w * 0.01,
                                ),
                                Text(upComingLectures[index]['end_time'],
                                    style:
                                        const TextStyle(color: Colors.black54)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }

  Widget _menuBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0XFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(14.0)),
              onTap: () {
                setState(() {
                  activePageIndex = 0;
                  isVideoLectures = true;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (activePageIndex == 0)
                    ? BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14.0)),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle,
                      color: activePageIndex == 0 ? Colors.white : primaryColor,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Lecture Details",
                      style: TextStyle(
                          color: activePageIndex == 0
                              ? Colors.white
                              : primaryColor),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(14.0)),
              onTap: () {
                setState(() {
                  activePageIndex = 1;
                  isVideoLectures = false;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (activePageIndex == 1)
                    ? BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14.0)),
                      )
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment,
                      color: activePageIndex == 1 ? Colors.white : primaryColor,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Teacher Notes",
                      style: TextStyle(
                          color: activePageIndex == 1
                              ? Colors.white
                              : primaryColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _assignments() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Assignments",
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              if (index == 2) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AssignmentsPage()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "View More",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubmitAssignmentPage()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 125.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 125.6,
                        width: 115.2,
                        child: CustomPaint(
                          painter: LeftElement(
                              color: index % 2 == 0
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.pink.withOpacity(0.2)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Due:",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold)),
                                Text("09:00 PM",
                                    style: TextStyle(fontSize: 18.0)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 125.6,
                        width: 200.0,
                        //padding: const EdgeInsets.all(10.0),
                        // decoration: BoxDecoration(
                        //     //color: Colors.pink.withOpacity(0.2),
                        //     color: index % 2 == 0
                        //         ? Colors.pink.withOpacity(0.1)
                        //         : Colors.blue.withOpacity(0.1),
                        //     borderRadius: const BorderRadius.only(
                        //         topRight: Radius.circular(12),
                        //         bottomRight: Radius.circular(12.0))),
                        child: CustomPaint(
                          painter: RightElement(
                              color: index % 2 == 0
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.pink.withOpacity(0.2)),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Python Assignment ${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: w * 0.02,
                                    ),
                                    const Text(
                                      "30th May 2022",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.chalkboardTeacher,
                                      color: primaryColor,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: w * 0.02,
                                    ),
                                    const Text(
                                      "Vipeen Jaiswal",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }

  _videoLectures() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Curriculum",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.orange.shade200,
                  ),
                  SizedBox(
                    width: w * 0.01,
                  ),
                  Text(
                    widget.courseDuration,
                    style: const TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: h * 0.02,
        ),
        Container(
          child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: courseDetails.length > 5 ? 5 : courseDetails.length,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllVideoLecturesPage(
                                    videoLectures: courseDetails,
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "View More",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: primaryColor,
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ExpandableNotifier(
                    child: ScrollOnExpand(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0))),
                    child: Column(
                      children: <Widget>[
                        ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToExpand: true,
                            tapBodyToCollapse: true,
                            hasIcon: false,
                          ),
                          header: Container(
                            // color: Colors.indigoAccent,
                            margin: const EdgeInsets.all(5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Section ${index + 1} - ${courseDetails[index]['module_name']}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  courseDetails[index]['details'].isEmpty
                                      ? Container()
                                      : ExpandableIcon(
                                          theme: const ExpandableThemeData(
                                            expandIcon: Icons.add,
                                            collapseIcon: Icons.remove,
                                            iconColor: Colors.black,
                                            iconSize: 22.0,
                                            //iconRotationAngle: math.pi / 2,
                                            iconPadding:
                                                EdgeInsets.only(right: 5),
                                            hasIcon: false,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          collapsed: Container(),
                          expanded: buildList(courseDetails[index]['details']),
                        ),
                      ],
                    ),
                  ),
                ));
              }),
        )
      ],
    );
  }

  buildItem(var i, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VideoLecturePaidPage()));
      },
      child: Card(
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${index + 1}. ${i['description']}",
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '57 mins - 30th Jan 2022',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  )
                ],
              ),
              Icon(
                Icons.play_circle,
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  buildList(List videoLectures) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < videoLectures.length; i++)
            buildItem(videoLectures[i], i),
        ],
      ),
    );
  }
}

/*

return Container(
                  padding: const EdgeInsets.all(10.0),
                  width: w * 0.4,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.assignment,
                            color: Colors.green.shade300,
                          ),
                          Text(
                            "Introduction",
                            style: TextStyle(
                                color: Colors.green.shade300,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        "What is Django?",
                        style: TextStyle(
                            color: primaryColor.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      const Text(
                        "30 mins",
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle,
                            color: Colors.orange.shade300,
                            size: 40,
                          ),
                          Text(
                            "Start",
                            style: TextStyle(
                                color: Colors.orange.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          )
                        ],
                      )
                    ],
                  ),
                );
 */
