import 'dart:convert';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:vti_student/home/video_lectures/single_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';

class VideoDetailsPage extends StatefulWidget {
  final String videoId;
  const VideoDetailsPage({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  @override
  _VideoDetailsPageState createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  bool isLoading = true;
  // late YoutubePlayerController _videoController;

  bool isVideoInitialised = false;

  List<dynamic> courseDetails = [];

  fetchCourseDetails() async {
    final url = Uri.parse(Urls().demoCourseDetailsUrl);

    var body = json.encode([
      {
        'video_id': widget.videoId,
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
        //initialiseVideo();
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
    }
  }

//   initialiseVideo() async {
//     print("VIDEO URL: ${courseDetails[0]['video_url']}");
//     _videoController = YoutubePlayerController(
//       initialVideoId: courseDetails[0]['video_url'],
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         loop: false,
//         enableCaption: true,
//         hideControls: false,

// //        useHybridComposition: true,

//         // showControls: true,
//         // playsInline: true,
//         // showFullscreenButton: true,
//         // strictRelatedVideos: true,
//       ),
//     );
//   }

  @override
  void initState() {
    fetchCourseDetails();

    super.initState();
  }

  @override
  void dispose() {
    //_videoController.dispose();
    super.dispose();
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
                    children: [
                      SizedBox(
                        height: h * 0.4,
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
                      ],
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleVideo(
                                    videoId: courseDetails[0]['video_url'])));
                      },
                      child: Container(
                        height: h * 0.25,
                        width: w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                          image: DecorationImage(
                              image:
                                  NetworkImage(courseDetails[0]['thumbnail']),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          height: h * 0.25,
                          width: w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0)),
                              color: Colors.black54),
                          child: Center(
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Text(
                      courseDetails[0]['title'],
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    Text(
                      courseDetails[0]['description'],
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Instructed by ",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        InkWell(
                          onTap: () {
                            Fluttertoast.showToast(msg: "Future update");
                          },
                          child: Text(
                            courseDetails[0]['faculty_name'],
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15.0),
                          ),
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
                        Text(
                          'Last updated ${courseDetails[0]['date']}',
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
                        Text(
                          courseDetails[0]['language'],
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
                        Icon(
                          Icons.remove_red_eye,
                          color: primaryColor,
                          size: 20.0,
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          '${courseDetails[0]['views']} views',
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
                          FontAwesomeIcons.clock,
                          color: primaryColor,
                          size: 20.0,
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          courseDetails[0]['duration'],
                          style: TextStyle(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    const Text(
                      "What you'll learn",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    ListView.builder(
                        itemCount: courseDetails[0]['you_learn'].length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            title: Text(
                              courseDetails[0]['you_learn'][index],
                            ),
                          );
                        }),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Text(
                      "Since you like ${courseDetails[0]['cat_technology']}",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                    Container(
                      height: h * 0.25,
                      child: ListView.builder(
                          itemCount: courseDetails[0]['recommendation'].length,
                          scrollDirection: Axis.horizontal,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoDetailsPage(
                                            videoId: courseDetails[0]
                                                        ['recommendation']
                                                    [index]['video_id']
                                                .toString())));
                              },
                              child: Container(
                                height: h * 0.15,
                                width: w * 0.6,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.0),
                                    ),
                                  ),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: h * 0.15,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0)),
                                            // image: DecorationImage(
                                            //     image: NetworkImage(
                                            //         courseDetails[0]
                                            //                 ['recommendation']
                                            //             [index]['thumbnail']),
                                            //     fit: BoxFit.cover),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(14.0),
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: courseDetails[0]
                                                      ['recommendation'][index]
                                                  ['thumbnail'],
                                              placeholder: (context, url) =>
                                                  SpinKitChasingDots(
                                                color: primaryColor,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                courseDetails[0]
                                                        ['recommendation']
                                                    [index]['title'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0),
                                              ),
                                              SizedBox(
                                                height: h * 0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                      ),
                                                      Text(
                                                        courseDetails[0][
                                                                'recommendation']
                                                            [index]['ratings'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      color: Colors.green,
                                                    ),
                                                    child: Text(
                                                      courseDetails[0]
                                                              ['recommendation']
                                                          [index]['tag'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13.0),
                                                    ),
                                                  )
                                                ],
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
                          }),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Center(
                      child: Container(
                        height: 60,
                        width: w * 0.9,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(14.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.engineering_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: w * 0.01,
                            ),
                            Text("Enroll Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    // Container(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         "Instructor",
                    //         style: TextStyle(
                    //             color: Colors.black87,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 20.0),
                    //       ),
                    //       SizedBox(
                    //         height: h * 0.01,
                    //       ),
                    //       Text(
                    //         "Nishank Sidhpura",
                    //         style: TextStyle(
                    //             color: primaryColor,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18.0),
                    //       ),
                    //       const Text(
                    //         "Flutter Developer & Teacher",
                    //         style: TextStyle(
                    //             color: Colors.black54, fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: h * 0.01,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             height: h * 0.09,
                    //             width: h * 0.09,
                    //             decoration: BoxDecoration(
                    //                 color: primaryColor,
                    //                 shape: BoxShape.circle,
                    //                 image: const DecorationImage(
                    //                     image: AssetImage("assets/images/person.jpg"),
                    //                     fit: BoxFit.cover)),
                    //           ),
                    //           SizedBox(
                    //             width: w * 0.1,
                    //           ),
                    //           Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: const [
                    //               Text(
                    //                 "4.7 Rating",
                    //                 style: TextStyle(
                    //                     color: Colors.black87,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16.0),
                    //               ),
                    //               Text(
                    //                 "400 Reviews",
                    //                 style: TextStyle(
                    //                     color: Colors.black87,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16.0),
                    //               ),
                    //               Text(
                    //                 "1025 Students",
                    //                 style: TextStyle(
                    //                     color: Colors.black87,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16.0),
                    //               ),
                    //               Text(
                    //                 "5 Courses",
                    //                 style: TextStyle(
                    //                     color: Colors.black87,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 16.0),
                    //               ),
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: h * 0.02,
                    //       ),
                    //       const Text(
                    //         "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                    //         style: TextStyle(color: Colors.black54),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   height: 60,
                    //   decoration: BoxDecoration(
                    //       color: primaryColor,
                    //       borderRadius: BorderRadius.all(Radius.circular(14.0))),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(
                    //         Icons.play_circle,
                    //         color: Colors.white,
                    //         size: 35,
                    //       ),
                    //       SizedBox(
                    //         width: 5.0,
                    //       ),
                    //       Text(
                    //         "Play Video",
                    //         style: TextStyle(
                    //             color: Colors.white, fontWeight: FontWeight.bold),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
        ),
      )),
    );
  }
}
