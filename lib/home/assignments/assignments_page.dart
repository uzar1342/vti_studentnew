// import 'package:flutter/foundation.dart';s
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/home/assignments/submit_assignment_page.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({Key? key}) : super(key: key);

  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  bool showSearch = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
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
                                hintStyle:
                                    const TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18.0)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
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
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black87,
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        "My Assignments",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0),
                      ),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsPage()));
                            },
                            icon: Icon(
                              Icons.notifications,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            SizedBox(
              height: h * 0.01,
            ),
            const Text(
              "Below are all the Assignments assigned to you.",
              style:
                  TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SubmitAssignmentPage()));
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons
                                                  .chalkboardTeacher,
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
                    }),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class LeftElement extends CustomPainter {
  final Color color;
  LeftElement({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      //..shader = gradient.createShader(colorBounds);
      ..color = color;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);

    path.lineTo(size.height - 20, size.width + 10);
    path.lineTo(size.height, size.width / 1.8);
    path.lineTo(size.width - 20, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RightElement extends CustomPainter {
  final Color color;
  RightElement({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3
      //..shader = gradient.createShader(colorBounds);
      ..color = color;

    Path path = Path();
    path.moveTo(-13, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0 - 3, size.height);
    path.lineTo(size.height - 108, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
