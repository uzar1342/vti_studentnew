import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'configs/globals.dart';
class TodayBatch extends StatefulWidget {
  TodayBatch({Key? key,required this.day}) : super(key: key);
  String day;
  @override
  _TodayBatchState createState() => _TodayBatchState();
}

class _TodayBatchState extends State<TodayBatch> {
  bool isLoading = true;
  bool showSearch = false;
  var studentCourseList ;
  final TextEditingController _searchController = TextEditingController();
  Future<dynamic> fetchCourseList()  async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'student_id ':userId,
      "batch": widget.day
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/showStudentBatches', data:formData);
    if (response.statusCode == 200) {
      setState(() {
        studentCourseList=response.data;
        isLoading = false;
      });
      print(studentCourseList);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello,",
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 18.0),
                          ),

                          Container(
                            width: w,
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 17.0),
                              text: TextSpan(
                                  style:  const TextStyle(
                                      color: Colors.black87,
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 20
                                  ),
                                  text: "employee_name"),
                            ),
                          )


                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
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
                      ),
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
                    Text(
                      "My "+widget.day+"'s Batch",
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                studentCourseList["data"]!=null?Container(
                  child: studentCourseList["data"].isEmpty
                      ? Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "asset/images/no_data.png",
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
                      : studentCourseList["data"].length>0?ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: studentCourseList["data"].length,
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (studentCourseList["data"][index]['faculty_name']
                            .toString()
                            .toLowerCase()
                            .contains(
                            _searchController.text.toLowerCase())) {
                          return widget.day!="allday"?InkWell(
                            onTap: () {

                            },
                            child: Container(
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
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "asset/images/python_logo.png",
                                                height: 50,
                                                width: 50,
                                              ),
                                              SizedBox(
                                                width: w * 0.02,
                                              ),
                                              Container(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  strutStyle: StrutStyle(fontSize: 17.0),
                                                  text: TextSpan(
                                                      style:  const TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18
                                                      ),
                                                      text: studentCourseList["data"][index]['batch_sub_course']),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Container(
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
                                                  "Ofline",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      ),

                                      const Divider(),

                                      // Row(
                                      //   children: [
                                      //     const Text(
                                      //       "Chapter : ",
                                      //       style: TextStyle(
                                      //           color: Colors.black54,
                                      //           fontSize: 13.0,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //     Text(
                                      //       "Learning the basic",
                                      //       style: TextStyle(
                                      //           color: primaryColor,
                                      //           fontSize: 15.0,
                                      //           fontWeight: FontWeight.bold),
                                      //     )
                                      //   ],
                                      // ),
                                      // const Divider(),

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
                                                studentCourseList["data"][index]['faculty_name'],
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
                                                "${studentCourseList["data"][index]['date']}",
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
                                              Text(studentCourseList["data"][index]['timing_from'],
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
                                              Text(studentCourseList["data"][index]['timing_to'],
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
                            ),
                          ):InkWell(
                            onTap: () {

                            },
                            child: Container(
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
                                                "asset/images/python_logo.png",
                                                height: 50,
                                                width: 50,
                                              ),
                                              SizedBox(
                                                width: w * 0.02,
                                              ),
                                              Container(
                                                width: 200,
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  strutStyle: StrutStyle(fontSize: 17.0),
                                                  text: TextSpan(
                                                      style:  const TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18
                                                      ),
                                                      text: studentCourseList["data"][index]['batch_sub_course']),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Container(
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
                                                  "Ofline",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      ),

                                      const Divider(),

                                      // Row(
                                      //   children: [
                                      //     const Text(
                                      //       "Chapter : ",
                                      //       style: TextStyle(
                                      //           color: Colors.black54,
                                      //           fontSize: 13.0,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //     Text(
                                      //       "Learning the basic",
                                      //       style: TextStyle(
                                      //           color: primaryColor,
                                      //           fontSize: 15.0,
                                      //           fontWeight: FontWeight.bold),
                                      //     )
                                      //   ],
                                      // ),
                                      // const Divider(),

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
                                                studentCourseList["data"][index]['faculty_name'],
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
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: studentCourseList["data"][index]['days_time'].length,
                                        itemBuilder: (BuildContext context, int index1) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.date_range,
                                                      color: Colors.purple.shade200,
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.02,
                                                    ),
                                                    Text(
                                                      "${studentCourseList["data"][index]['days_time'][index1]}",
                                                      style: const TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ); },

                                      ),


                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }):Center(child: Image.asset("assets/no_data.png")),
                ):Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "asset/images/no_data.png",
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
