import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:trafindo/auth/auth_screen/login_screen.dart';
import 'package:trafindo/walkthrough_image.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({Key? key}) : super(key: key);

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  List<String> imgPage = <String>[
    walkThroughImage1,
    walkThroughImage2,
    walkThroughImage3,
    walkThroughImage4,
    walkThroughImage5,
  ];

  int position = 0;

  PageController? pageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    pageController =
        PageController(initialPage: position, viewportFraction: 0.75);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            70.height,
            SizedBox(
              height: context.height() * 0.5,
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: imgPage.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: 500.milliseconds,
                    height: context.height() * 0.45,
                    margin: const EdgeInsets.only(left: 16, right: 8),
                    child: Image.asset(
                      imgPage[index],
                      fit: BoxFit.cover,
                      width: context.width(),
                    ).cornerRadiusWithClipRRect(16),
                  );
                },
                onPageChanged: (value) {
                  setState(() {
                    position = value;
                  });
                },
              ),
            ),
            20.height,
            DotIndicator(
              pageController: pageController!,
              pages: imgPage,
              indicatorColor: Colors.red,
            ),
            16.height,
            Text(
              'Welcome to Trafindo',
              style: boldTextStyle(size: 20),
            ).paddingOnly(left: 16, right: 16),
            16.height,
            Text(
              'Register your company and discover comprehensive information about your transformers!',
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ).paddingOnly(left: 16, right: 16),
          ],
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                width: (context.width() - (3 * 16)) * 0.5,
                height: 60,
                text: 'Skip',
                textStyle: boldTextStyle(),
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                onTap: () {
                  const LoginScreen().launch(context);
                },
                color: grey.withOpacity(0.2),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
              16.width,
              AppButton(
                width: (context.width() - (3 * 16)) * 0.5,
                text: position < 4 ? 'Next' : 'Log in',
                height: 60,
                elevation: 0,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.red,
                textStyle: boldTextStyle(color: white),
                onTap: () {
                  setState(() {
                    if (position < 4) {
                      pageController!.animateToPage(
                        position + 1,
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.easeIn,
                      );
                    } else if (position == 4) {
                      const LoginScreen().launch(
                        context,
                        isNewTask: true,
                      );
                    }
                  });
                },
              )
            ],
          ),
        )
      ]),
    );
  }
}
