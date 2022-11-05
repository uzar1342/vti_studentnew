import 'package:flutter/material.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(15.0),
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
                  const Text(
                    "Feedback",
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
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
                    ),
                  ),
                ],
              ),
              Image.asset("assets/images/feedback.png"),
              Text(
                "Your feedback is valuable to us !",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                height: 60,
                width: w * 0.75,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.0),
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Category",
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade400,
                      )
                    ]),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                width: w * 0.75,
                child: TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      labelText: 'Feedback',
                      labelStyle: TextStyle(color: primaryColor),
                      suffixIcon: const Icon(
                        Icons.feedback_rounded,
                        color: Colors.black45,
                      )),
                ),
              ),
              SizedBox(
                height: h * 0.03,
              ),
              Container(
                height: 60,
                width: w * 0.75,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(14.0))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                ]),
              )
            ],
          ),
        ),
      )),
    );
  }
}
