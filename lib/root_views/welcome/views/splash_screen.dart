import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist/services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      bool userExits =  userService.isUserExists();
      if (userExits) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/logo/logo.png'),
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 15,
              ),
              AnimatedTextKit(
                  totalRepeatCount: 1,
                  pause: const Duration(seconds: 2),
                  animatedTexts: [
                    FadeAnimatedText('App is starting..',
                        duration: const Duration(milliseconds: 3000),
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  ])
            ],
          ),
        ),
      ),
    ));
  }
}
