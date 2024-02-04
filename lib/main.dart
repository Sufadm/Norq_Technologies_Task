import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:norq_technologies/controller/paswword_visibility.dart';
import 'package:norq_technologies/model/hive_model.dart';
import 'package:norq_technologies/controller/auth_provider.dart';
import 'package:norq_technologies/controller/auth_service.dart';
import 'package:norq_technologies/controller/quantity.dart';
import 'package:norq_technologies/firebase_options.dart';
import 'package:norq_technologies/model/user_model.dart';
import 'package:norq_technologies/view/presentation/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(ProductModelsAdapter().typeId)) {
    Hive.registerAdapter(ProductModelsAdapter());
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuantityProvider(),
        ),
        ChangeNotifierProvider(create: (context) {
          return PasswordVisibilityProvider();
        })
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().userlog,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
