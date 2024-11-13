import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; 
  final ValueChanged<int> onTap; 

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(41, 41, 41, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: const Color.fromARGB(0, 0, 0, 0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home, size: 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.faceSmileBeam, size: 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.squarePlus, size: 24),
              label: '',
            ),
            BottomNavigationBarItem(            
              icon: Icon(FontAwesomeIcons.circleUser, size: 24),
              label: '',
            ),
          ],
          onTap: onTap,
          showSelectedLabels: true,
          selectedItemColor: const Color.fromARGB(206, 114, 40, 211),
          unselectedItemColor: const Color.fromARGB(255, 172, 171, 171),
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
        ),
      ),
    );
  }
}
