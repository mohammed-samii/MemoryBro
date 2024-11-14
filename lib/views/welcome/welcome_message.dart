import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WELCOME TO MOVIE WATCHLIST',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth < 600 ? 20 : 28, // Smaller font for mobile
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // Responsive horizontal padding
                child: const Text(
                  'This is just a one-time occurrence. In the next few screens, you will learn all about how to use this movie watchlist to enjoy your binge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kIsWeb ? screenWidth * 0.4 : 100, // Adjust padding based on platform
                ),                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(96, 0, 219, 86),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/create-user');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          fontSize: screenWidth < 600 ? 14 : 18, // Responsive font for button text
                        ),
                      ),
                      const Icon(Icons.arrow_right_alt_rounded, size: 22),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
