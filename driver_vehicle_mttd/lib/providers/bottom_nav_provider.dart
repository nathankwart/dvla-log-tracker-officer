import 'package:flutter/material.dart';

class BottomNavigationProvider with ChangeNotifier {
  int screenIndex = 0;

  PageController? pageController = PageController();

  void onPageViewChanged(int index) {
    screenIndex = index;
    notifyListeners();
  }

  void onBottonNavChanged(int index) {
    if (screenIndex != index) {
      onPageViewChanged(index);
      pageController?.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void goToScreenIndex(int index) {
    Future.delayed(Duration.zero, () {
      onBottonNavChanged(index);
    });
  }

  bool isHomeScreenSelected() {
    return screenIndex == 0;
  }

  void reset() {
    screenIndex = 0;
    pageController = PageController(initialPage: 0);
    notifyListeners();
  }
}
