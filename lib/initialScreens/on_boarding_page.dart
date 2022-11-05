import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:vti_student/authentication/login_page.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  bool isLoading = true;

  List<dynamic> onBoardingPages = [];

  fetchOnboardingData() async {
    final url = Uri.parse(Urls().onboardingUrl);

    Response response =
        await post(url, headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      setState(() {
        onBoardingPages = jsonDecode(response.body);

        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchOnboardingData();
    super.initState();
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return CachedNetworkImage(
      imageUrl: assetName,
      width: width,
      placeholder: (context, url) => SpinKitChasingDots(
        color: primaryColor,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return isLoading
        ? Scaffold(
            body: Center(
              child: SpinKitFadingCube(
                color: primaryColor,
              ),
            ),
          )
        : IntroductionScreen(
            key: introKey,

            pages: [
              PageViewModel(
                title: onBoardingPages[0]['title'],
                body: onBoardingPages[0]['sub_title'],
                image: _buildImage(onBoardingPages[0]['image']),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: onBoardingPages[1]['title'],
                body: onBoardingPages[1]['sub_title'],
                image: _buildImage(onBoardingPages[1]['image']),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: onBoardingPages[2]['title'],
                body: onBoardingPages[2]['sub_title'],
                image: _buildImage(onBoardingPages[2]['image']),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            //onSkip: () => _on IntroEnd(context), // You can override onSkip callback
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            //rtl: true, // Display as right-to-left
            skip: Text('Skip',
                style: TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold)),
            next: Icon(
              Icons.arrow_forward,
              color: primaryColor,
            ),
            done: Container(
              height: 40,
              width: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: const Center(
                child: Text("Let's Go!",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: DotsDecorator(
              size: const Size(10.0, 10.0),
              color: const Color(0xFFBDBDBD),
              activeSize: const Size(22.0, 10.0),
              activeColor: primaryColor,
              activeShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          );
  }
}
