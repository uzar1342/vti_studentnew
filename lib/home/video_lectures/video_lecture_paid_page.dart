import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vti_student/configs/globals.dart';

class VideoLecturePaidPage extends StatefulWidget {
  const VideoLecturePaidPage({Key? key}) : super(key: key);

  @override
  _VideoLecturePaidPageState createState() => _VideoLecturePaidPageState();
}

class _VideoLecturePaidPageState extends State<VideoLecturePaidPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              height: h * 0.25,
              width: w,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/video_lectures.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            const Text(
              "1. Setup IDE for Flutter in Windows",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            const Divider(),
            Text(
              "My Status",
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(14.0),
                ),
                color: 2 % 2 == 0
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
            ),
            const Divider(),
            SizedBox(
              height: h * 0.02,
            ),
            Row(
              children: [
                const Text(
                  "Lecture by ",
                  style: TextStyle(fontSize: 15.0),
                ),
                Text(
                  "Nishank Sidhpura",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                )
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Row(
              children: [
                Icon(Icons.date_range, color: primaryColor),
                const SizedBox(
                  width: 4.0,
                ),
                const Text(
                  'Lecture Date 10/01/2022',
                  style: TextStyle(),
                )
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 3.0,
                ),
                FaIcon(
                  FontAwesomeIcons.globe,
                  color: primaryColor,
                  size: 20.0,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                const Text(
                  'English',
                  style: TextStyle(),
                )
              ],
            ),
            // SizedBox(
            //   height: h * 0.01,
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 3.0,
            //     ),
            //     Icon(
            //       Icons.remove_red_eye,
            //       color: primaryColor,
            //       size: 20.0,
            //     ),
            //     SizedBox(
            //       width: 6.0,
            //     ),
            //     Text(
            //       '200 views',
            //       style: TextStyle(),
            //     )
            //   ],
            // ),
            SizedBox(
              height: h * 0.01,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 3.0,
                ),
                FaIcon(
                  FontAwesomeIcons.clock,
                  color: primaryColor,
                  size: 20.0,
                ),
                const SizedBox(
                  width: 6.0,
                ),
                const Text(
                  '45 mins',
                  style: TextStyle(),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
