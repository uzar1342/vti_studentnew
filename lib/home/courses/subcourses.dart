import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../../configs/globals.dart';
import 'Module.dart';
import 'courses_details_page.dart';




class SubCoursesPage extends StatefulWidget {
   SubCoursesPage({Key? key,required this.id}) : super(key: key);
  String id;
  @override
  _SubCoursesPageState createState() => _SubCoursesPageState();
}
class _SubCoursesPageState extends State<SubCoursesPage> {
  bool isLoading = true;
  bool showSearch = false;

  var studentCourseList ;
  final TextEditingController _searchController = TextEditingController();
  Future<dynamic> fetchCourseList()  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'course_id': widget.id
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/showSubCourse', data:formData);
    if (response.statusCode == 200) {
      setState(() {
        studentCourseList=response.data;
        isLoading = false;
      });
      print(response.data);
    } else {
      print(response.statusCode);
      final snackBar = SnackBar(
        content: const Text('Please try again later'),
        backgroundColor: (primaryColor),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });

    }
  }




  @override
  void initState() {
    fetchCourseList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          bottom: false,
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
                  ),
                  // CircularProgressIndicator(
                  //   color: primaryColor,
                  // ),
                  // SizedBox(
                  //   height: 10.0,
                  // ),
                  // Text("Loading...")
                ],
              ),
            )
                : Column(
              children: [
                showSearch
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: w * 0.7,
                      child: Card(
                        //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(12))),
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.orange.shade200,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black38,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              ),
                              hintText: "Search",
                              hintStyle: const TextStyle(
                                  color: Colors.black26),
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(18.0)),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 16.0)),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            showSearch = false;
                            _searchController.clear();
                          });
                        },
                        child: Text("Close",
                            style: TextStyle(
                              color: Colors.black54,
                              decoration: TextDecoration.underline,
                            ))),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hello,",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 18.0),
                        ),
                        Text(
                          userFirstName,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0),
                        )
                      ],
                    ),
                    // Container(
                    //   height: h * 0.06,
                    //   width: h * 0.06,
                    //   decoration: const BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage("assets/images/person.jpg"),
                    //           fit: BoxFit.cover),
                    //       borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    // ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                showSearch = true;
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              color: primaryColor,
                            )),
                        IconButton(
                            onPressed: () {

                            },
                            icon: Icon(
                              Icons.notifications,
                              color: primaryColor,
                              size: 25,
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),

                SizedBox(
                  height: h * 0.03,
                ),
                Row(
                  children: [
                    const Text(
                      "My Enrolled SubCourses",
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: primaryColor,
                      size: 30.0,
                    )
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                studentCourseList["data"].isEmpty
                    ? Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/no_data.png",
                        height: 300,
                        width: 300,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "No Courses Found",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.00),
                      )
                    ],
                  ),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: studentCourseList["data"].length,
                    //physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (studentCourseList["data"][index]['sub_course_name']
                          .toString()
                          .toLowerCase()
                          .contains(
                          _searchController.text.toLowerCase())) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Module(
                                          id: studentCourseList["data"][index]["sub_course_id"].toString(),
                                        )));
                              },
                              child: Container(
                                height: h * 0.1,
                                width: w,
                                decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Colors.pink.withOpacity(0.1)
                                        : Colors.blue.withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0),
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [

                                            Flexible(
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                strutStyle: StrutStyle(fontSize: 12.0),
                                                text: TextSpan(
                                                    style:  const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    text: studentCourseList["data"][index]
                                                    ['sub_course_name']),
                                              ),
                                            )
                                            ,
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.teal.shade200,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),  InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>

                                CourseDetailsPage(
                                  courseId:
                                  studentCourseList["data"][0]
                                  ['course_id']
                                      .toString(),
                                  courseName:
                                  studentCourseList["data"][0]
                                  ['course_name'].toString(),
                                  courseDuration:
                                  studentCourseList["data"][0]
                                  ['course_duration'].toString(),
                                )

                        ));

                  },
                  child: Container(
                    height: h * 0.1,
                    width: w,
                    decoration: BoxDecoration(
                        color: 1 % 2 == 0
                            ? Colors.pink.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12.0))),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle: const StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                        style:  const TextStyle(
                                          color: Colors.black87,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                        text: studentCourseList["data"][0]
                                        ['sub_course_name']),
                                  ),
                                )
                                ,
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.teal.shade200,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  buildItem(var i, int index) {
    return InkWell(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const VideoDetailsPage()));
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
                    "${index + 1}. ${i['sub_course_name']}",
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
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

  buildList(List subcourse) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < subcourse.length; i++)
            buildItem(subcourse[i], i),
        ],
      ),
    );
  }
}
