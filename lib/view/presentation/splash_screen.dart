import 'package:flutter/material.dart';
import 'package:norq_technologies/model/user_model.dart';
import 'package:norq_technologies/view/presentation/home_page.dart';
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
    await Future.delayed(const Duration(milliseconds: 1600));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Check();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
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
      return const HomePage();
    }
  }
}
