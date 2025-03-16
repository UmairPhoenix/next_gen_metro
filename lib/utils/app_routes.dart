import 'package:flutter/material.dart';
import 'package:next_gen_metro/views/content_page.dart';
import 'package:next_gen_metro/views/image_start_page.dart';
import 'package:next_gen_metro/views/login_page.dart';
import 'package:next_gen_metro/views/museum_info_page.dart';
import 'package:next_gen_metro/views/museum_welcome_page.dart';
import 'package:next_gen_metro/views/nfc_info_page.dart';
import 'package:next_gen_metro/views/nfc_scan_page.dart';
import 'package:next_gen_metro/views/onboarding_page.dart';
import 'package:next_gen_metro/views/profile_page.dart';
import 'package:next_gen_metro/views/sign_up_page.dart';
import 'package:next_gen_metro/views/start_page.dart';
import 'package:next_gen_metro/views/text_start_page.dart';

class Routes {

  static String startPage = 'StartPageRoute';
  static String onboardingPage = 'OnboardingPageRote';
  static String loginPage = 'LoginPageRoute';
  static String signUpPage = 'SignupPageRoute';
  static String homePage = 'HomePageRoute';
  static String museumWelcomePage = 'MuseumWelcomPageRoute';
  static String museumInfoPage = 'MuseumInfoPageRoute';
  static String nfcScanPage = 'NfcScnaPageRoute';
  static String nfcInfoPage = 'NfcInfoPageRoute';
  static String contentPage = 'ContentPageRoute';
  static String profilePage = 'ProfilePage';
  static String textStartPage = 'TextStartPageRoute';
  static String imageStartPage = 'ImageStartPageRoute';


  static Map<String, Widget Function(BuildContext)> generateRoutes() {
    return {
      onboardingPage: (_) => const OnboardingPage(),
      startPage: (_) => const StartPage(),
      loginPage: (_) => const LoginPage(),
      signUpPage: (_) => const SignUpPage(),
      museumWelcomePage: (_) => const MuseumWelcomePage(),
      museumInfoPage: (_) => const NextGenMetroInfoPage(),
      nfcScanPage: (_) => const NfcScanPage(),
      nfcInfoPage: (_) => const NfcInfoPage(),
      contentPage: (_) => const ContentPage(),
      profilePage: (_) => const ProfilePage(),
      textStartPage: (_) => const TextStartPage(),
      imageStartPage: (_) => const ImageStartPage(),
    };
  }
}
