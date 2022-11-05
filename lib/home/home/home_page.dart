import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/shared_prefs_keys.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/blog/blog_list_page.dart';
import 'package:vti_student/home/blog/blog_webview_page.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';
import 'package:vti_student/home/reviews/web_view_reviews.dart';
import 'package:vti_student/home/video_lectures/video_details_page.dart';
import 'package:vti_student/home/video_lectures/video_lectures_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  bool isVideoInitialised = false;

  bool showTestimonialVideo = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _flexibleUpdateAvailable = false;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  late VideoPlayerController _reviewVideoPlayerController;
  late ChewieController _reviewChewieController;

  List<dynamic> blogCategories = [];
  List<dynamic> testimonials = [];
  List<dynamic> blogs = [];

  List<dynamic> demoVideos = [];



  fetchTestimonials() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().testimonialsUrl);

    Response response = await post(
      url,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        testimonials = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  fetchBlogPosts() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().blogUrl);

    Response response = await post(
      url,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        blogs = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  fetchBlogCategories() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().blogCategoryUrl);

    Response response =
        await post(url, headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      setState(() {
        blogCategories = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  fetchDemoVideos() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().demoVideoListUrl);

    Response response = await post(
      url,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        demoVideos = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  initialiseVideoPlayer() async {
    print(graphicsList[0]["url"]);
    _videoPlayerController =
        VideoPlayerController.network("https://virashtechnologies.com/vti-22/img/videos/intro-1.mp4");
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
    );
    setState(() {
      isVideoInitialised = true;
    });
  }

  initaliseReviewVideoPlayer(String url) async {
    if (_videoPlayerController.value.isPlaying) {
      _chewieController.videoPlayerController.pause();
    }

    _reviewVideoPlayerController = VideoPlayerController.network(url);
    _reviewChewieController = ChewieController(
      videoPlayerController: _reviewVideoPlayerController,
      autoPlay: false,
      allowFullScreen: true,
      showControlsOnInitialize: true,
      aspectRatio: 1.77,
      placeholder: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCircle(
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Buffering...",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
    setState(() {
      showTestimonialVideo = true;
    });
  }

  fetchImages() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().graphicsUrl);

    Response response = await post(
      url,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      graphicsList = await jsonDecode(response.body);
      setState(() {
        initialiseVideoPlayer();
        isLoading = false;
      });
    }
  }

  postFCMId() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String fcmId = _prefs.getString(fcmIdKey) ?? "";

    final url = Uri.parse(Urls().fcmIdUrl);

    var body = json.encode([
      {
        "mobile_number": userPhone,
        'student_id': userId,
        'fcm_registered_id': fcmId
      }
    ]);

    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);

      if (res[0]['success'] == '1') {
        print(res[0]["message"]);
        setState(() {
          isLoading = false;
        });
      } else {
        print(res[0]["message"]);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  checkForAppVersion() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().appUpdateUrl);

    var body = json.encode([
      {'app_version': '1.0'}
    ]);

    Response response = await post(
      url,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> res = await jsonDecode(response.body);

      if (res[0]['success'] == '1') {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> checkForUpdate() async {

  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    fetchTestimonials();
    fetchDemoVideos();
    fetchBlogPosts();
    fetchBlogCategories();
    fetchImages();
    super.initState();
  }

  pauseVideoControllers() async {
    if (_chewieController.videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _chewieController.pause();
    }
  }

  disposeVideoControllers() async {
    print("INSIDE DISPOSE");
    await _videoPlayerController.dispose();
    _chewieController.dispose();
    if (showTestimonialVideo) {
      _reviewChewieController.dispose();
      _reviewVideoPlayerController.dispose();
    }
  }

  @override
  void dispose() {
    disposeVideoControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Container(
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
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Welcome to,",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      Image.asset(
                                        "assets/images/logo.png",
                                        height: 40,
                                        width: 150,
                                      )
                                      // Text('Virash',
                                      //     style: TextStyle(
                                      //         color: primaryColor,
                                      //         fontSize: 28.0,
                                      //         fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        pauseVideoControllers();
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
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Container(
                              height: h * 0.25,
                              width: w,
                              // decoration: const BoxDecoration(
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(0.0),
                              //   ),
                              //   // image: DecorationImage(
                              //   //   image: AssetImage("assets/images/video_lectures.png"),
                              //   //   fit: BoxFit.cover,
                              //   // ),
                              // ),
                              child: !isVideoInitialised
                                  ? Center(
                                      child: SpinKitChasingDots(
                                        color: primaryColor,
                                      ),
                                    )
                                  : Chewie(
                                      controller: _chewieController,
                                    ),
                            ),
                            SizedBox(
                              height: h * 0.04,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15.0,
                                ),
                                const Text(
                                  "Starter Pack Videos",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: primaryColor,
                                  size: 30,
                                )
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Container(
                              height: h * 0.25,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: demoVideos.length > 5
                                      ? 5
                                      : demoVideos.length,
                                  itemBuilder: (context, index) {
                                    if (index == 4) {
                                      return InkWell(
                                        onTap: () {
                                          pauseVideoControllers();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoLecturesPage(
                                                        categories:
                                                            blogCategories,
                                                      )));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "View All",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return InkWell(
                                      onTap: () {
                                        pauseVideoControllers();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoDetailsPage(
                                                      videoId: demoVideos[index]
                                                              ['video_id']
                                                          .toString(),
                                                    )));
                                      },
                                      child: Container(
                                        height: h * 0.3,
                                        width: w * 0.6,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Card(
                                          elevation: 3.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.0)),
                                          child: Container(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: h * 0.15,
                                                  width: w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(14.0),
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(14.0),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          demoVideos[index]
                                                              ['thumbnail'],
                                                      placeholder: (context,
                                                              url) =>
                                                          SpinKitChasingDots(
                                                        color: primaryColor,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        demoVideos[index]
                                                            ['title'],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                      Text(
                                                        "By Prof. ${demoVideos[index]['faculty_name']}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                  }),
                            ),
                            SizedBox(
                              height: h * 0.04,
                            ),
                            Container(
                              width: w,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              height: h * 0.25,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14.0),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14.0),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: graphicsList.isNotEmpty
                                      ? graphicsList[2]['banner']
                                      : "",
                                  placeholder: (context, url) =>
                                      SpinKitChasingDots(
                                    color: primaryColor,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              height: h * 0.05,
                              child: Center(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    //physics: const NeverScrollableScrollPhysics(),
                                    itemCount: blogCategories.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          pauseVideoControllers();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlogListPage(
                                                        blogCategories:
                                                            blogCategories,
                                                        blogs: blogs,
                                                        categoryId:
                                                            blogCategories[
                                                                    index]['id']
                                                                .toString(),
                                                        categoryName:
                                                            blogCategories[
                                                                    index]
                                                                ['technology'],
                                                      )));
                                        },
                                        child: Container(
                                          // width: w * 0.2,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: 2.0),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20.0))),
                                          child: Center(
                                            child: Text(
                                              blogCategories[index]
                                                  ['technology'],
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15.0,
                                ),
                                const Text(
                                  "Our Blog",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: primaryColor,
                                  size: 30,
                                )
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Container(
                              height: h * 0.35,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      blogs.length > 5 ? 5 : blogs.length,
                                  itemBuilder: (context, index) {
                                    if (index == 4) {
                                      return InkWell(
                                        onTap: () {
                                          pauseVideoControllers();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlogListPage(
                                                        blogCategories:
                                                            blogCategories,
                                                        blogs: blogs,
                                                      )));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "View All",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return InkWell(
                                      onTap: () {
                                        pauseVideoControllers();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlogWebviewPage(
                                                        url: blogs[index]
                                                            ['post_url'])));
                                      },
                                      child: Container(
                                        height: h * 0.35,
                                        width: w * 0.6,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Card(
                                          elevation: 3.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.0)),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: h * 0.15,
                                                  width: w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(14.0),
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(14.0),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: blogs[index]
                                                          ['thumbnail'],
                                                      placeholder: (context,
                                                              url) =>
                                                          SpinKitChasingDots(
                                                        color: primaryColor,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  blogs[index]['title'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.category,
                                                        color: primaryColor),
                                                    SizedBox(
                                                      width: w * 0.02,
                                                    ),
                                                    Text(
                                                      blogs[index]
                                                          ['cat_technology'],
                                                      style: const TextStyle(
                                                          letterSpacing: 1.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.speed,
                                                        color: primaryColor),
                                                    SizedBox(
                                                      width: w * 0.02,
                                                    ),
                                                    Text(
                                                      blogs[index]['cat_level'],
                                                      style: const TextStyle(
                                                          letterSpacing: 1.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.person,
                                                            color:
                                                                primaryColor),
                                                        SizedBox(
                                                          width: w * 0.02,
                                                        ),
                                                        Container(
                                                          width: w * 0.38,
                                                          child: Text(
                                                            blogs[index]
                                                                ['added_by'],
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                letterSpacing:
                                                                    1.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.amber,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              height: h * 0.25,
                              width: w,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14.0),
                                ),
                                // image: DecorationImage(
                                //     image:
                                //         NetworkImage(graphicsList[3]['banner']),
                                //     fit: BoxFit.cover),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14.0),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: graphicsList.isNotEmpty
                                      ? graphicsList[3]['banner']
                                      : '',
                                  placeholder: (context, url) =>
                                      SpinKitChasingDots(
                                    color: primaryColor,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15.0,
                                ),
                                const Text(
                                  "Why Us?",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: primaryColor,
                                  size: 30,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Container(
                              height: h * 0.36,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    if (index == 4) {
                                      return InkWell(
                                        onTap: () {
                                          pauseVideoControllers();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewReviews()));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "View All",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      // height: h * 0.30,
                                      width: w * 0.6,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Card(
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, right: 0.0, top: 0.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: h * 0.13,
                                                width: w,
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              14.0)),
                                                  shape: BoxShape.rectangle,
                                                  // image: DecorationImage(
                                                  //     image: NetworkImage(
                                                  //         testimonials[index]
                                                  //             ['thumbnail']),
                                                  //     fit: BoxFit.cover),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(14.0),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        testimonials[index]
                                                            ['thumbnail'],
                                                    placeholder:
                                                        (context, url) =>
                                                            SpinKitChasingDots(
                                                      color: primaryColor,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10.0,
                                                    right: 10.0),
                                                child: Text(
                                                  '"${testimonials[index]['description']}"',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10.0,
                                                    right: 0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        testimonials[index]
                                                            ['name'],
                                                        style: TextStyle(
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    IconButton(
                                                        onPressed: () {
                                                          initaliseReviewVideoPlayer(
                                                              testimonials[
                                                                      index][
                                                                  'video_url']);
                                                        },
                                                        icon: Icon(
                                                          Icons.play_circle,
                                                          size: 30.0,
                                                          color: Colors.pink,
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                ),
              ),
              showTestimonialVideo
                  ? Center(
                      child: Container(
                        height: h,
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.9),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  showTestimonialVideo = false;
                                });
                                await _reviewVideoPlayerController.dispose();
                                _reviewChewieController.dispose();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.white54,
                                    size: 30,
                                  ),
                                  Text(
                                    "Close",
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    width: w * 0.02,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Container(
                            //   height: 250,
                            //   width: w * 0.8,
                            //   child: Chewie(
                            //     controller: _reviewChewieController,
                            //   ),
                            // ),
                            Container(
                              height: h * 0.3,
                              child: Stack(
                                children: [
                                  Chewie(controller: _reviewChewieController),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }
}
