import 'package:flutter/material.dart';
import 'package:next_gen_metro/views/admin_dashboard.dart';
import 'package:next_gen_metro/views/home_page.dart';
import 'package:next_gen_metro/views/login_page.dart';
import 'package:next_gen_metro/views/nfc_scan_page.dart';
import 'package:next_gen_metro/views/onboarding_page.dart';
import 'package:next_gen_metro/views/profile_page.dart';
import 'package:next_gen_metro/views/route_info_page.dart';
import 'package:next_gen_metro/views/sign_up_page.dart';
import 'package:next_gen_metro/views/start_page.dart';
import 'package:next_gen_metro/views/topup_page.dart';
import 'package:next_gen_metro/views/history_page.dart';
import 'package:next_gen_metro/views/admin_login.dart';
import 'package:next_gen_metro/views/admin_dashboard.dart';

class Routes {
  static String startPage = 'StartPageRoute';
  static String onboardingPage = 'OnboardingPageRoute';
  static String loginPage = 'LoginPageRoute';
  static String signUpPage = 'SignupPageRoute';
  static String homePage = 'HomePageRoute';
  static String nfcScanPage = 'NfcScanPageRoute';
  static String profilePage = 'ProfilePageRoute';
  static String routeInfoPage = 'RouteInfoPageRoute';
  static String topupPage = 'TopupPageRoute';
  static String historyPage = 'HistoryPageRoute';
  static String adminLoginPage = 'AdminLoginPageRoute';
  static String adminDashboard = 'AdminDashboardRoute';

  static Map<String, Widget Function(BuildContext)> generateRoutes() {
    return {
      onboardingPage: (_) => const OnboardingPage(),
      startPage: (_) => const StartPage(),
      adminLoginPage: (_) => const AdminLoginPage(),
      loginPage: (_) => const LoginPage(),
      signUpPage: (_) => const SignUpPage(),
      homePage: (_) => const HomePage(),
      adminDashboard: (_) => const AdminDashboard(),
      nfcScanPage: (_) => const NfcScanPage(),
      profilePage: (_) => const ProfilePage(),
      routeInfoPage: (_) => const RouteInfoPage(),
      topupPage: (_) => const TopupPage(),
      historyPage: (_) => const HistoryPage(),
    };
  }
}
