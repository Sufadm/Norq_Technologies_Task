import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:norq_technologies/model/user_model.dart';
import 'package:norq_technologies/view/presentation/bottom_nav.dart';
import 'package:norq_technologies/view/presentation/loginpage/login_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToHomeScreen();
    super.initState();
  }

  navigateToHomeScreen() async {
    await Future.delayed(const Duration(seconds: 5));

    // await Future.delayed(const Duration(milliseconds: 1600));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Check();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.network(
            "https://lottie.host/1e0d435f-b8bb-425c-879b-5382137825e1/iTAejqQcdm.json"),
      ),
    );
  }
}

class Check extends StatelessWidget {
  const Check({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return const MyNavigationBar();
    }
  }
}
