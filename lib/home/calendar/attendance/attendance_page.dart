import 'package:flutter/material.dart';
import 'package:vti_student/configs/globals.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15.0),
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
                  "My Attendance",
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
              height: h * 0.01,
            ),
            const Text(
              "Below consists the list of the lectures you were present.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(14.0),
                    ),
                    color: index % 2 == 0
                        ? Colors.green.withOpacity(0.2)
                        : Colors.amber.withOpacity(0.2),
                  ),
                  height: h * 0.09,
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 35,
                          color: primaryColor,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "18th",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0),
                          ),
                          Text(
                            "APR",
                            style: TextStyle(color: Colors.black38),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        height: h * 0.05,
                        width: w * 0.008,
                        color: primaryColor,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: const Text(
                          "Java Introduction & Basic programming examples",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ))
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      )),
    );
  }
}


/* 

return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  height: h * 0.1,
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0))),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "18th",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("APRIL"),
                            ],
                          ),
                          VerticalDivider(
                            thickness: 1.0,
                          ),
                          Container(
                              width: w * 0.6,
                              child: Text(
                                "Java Introduction & Basic programming examples",
                              ))
                        ],
                      ),
                    ),
                  ),
                );

*/