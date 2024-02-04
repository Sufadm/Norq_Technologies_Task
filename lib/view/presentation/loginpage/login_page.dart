import 'package:flutter/material.dart';
import 'package:norq_technologies/controller/auth_provider.dart';
import 'package:norq_technologies/controller/auth_service.dart';
import 'package:norq_technologies/controller/paswword_visibility.dart';
import 'package:norq_technologies/view/presentation/bottom_nav.dart';
import 'package:norq_technologies/view/presentation/loginpage/registration_page.dart';
import 'package:norq_technologies/view/widgets/custom_button.dart';
import 'package:norq_technologies/view/widgets/text_form_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final AuthService _auth = AuthService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final passwordVisibilityProvider =
        Provider.of<PasswordVisibilityProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.network(
                    "https://startups.startupmission.in/storage/uploads/DIPP132641/logo-64c4b5ab914bd-norq-logojpg.jpg"),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Email',
                ),
                //?textformfield widget---------------------------------------
                TextFormFieldWidget(
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter Email' : null,
                  onChanged: (value) =>
                      Provider.of<LoginModel>(context, listen: false)
                          .updateEmail(value),
                  hintText: 'Enter your Email',
                  icon: Icons.email,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Password',
                ),
                TextFormFieldWidget(
                  obscureText: passwordVisibilityProvider.isObscure,
                  validator: (value) =>
                      value!.length < 3 ? 'Please enter a password' : null,
                  onChanged: (value) =>
                      Provider.of<LoginModel>(context, listen: false)
                          .updatePassword(value),
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisibilityProvider.isObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      passwordVisibilityProvider.toggleVisibility();
                    },
                  ),
                  icon: Icons.lock,
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<LoginModel>(
                  builder: (context, loginModel, _) => loginModel.loading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomElevatedButtons(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              FocusScopeNode currentfocus =
                                  FocusScope.of(context);
                              if (!currentfocus.hasPrimaryFocus) {
                                currentfocus.unfocus();
                              }
                              loginModel.loading = true;
                              try {
                                dynamic result =
                                    await _auth.signEmailAndPassword(
                                  loginModel.email,
                                  loginModel.password,
                                );
                                if (result == null) {
                                  loginModel.setError(
                                    'Email and password combination not found. Please register.',
                                  );
                                  Future.delayed(const Duration(seconds: 5),
                                      () {
                                    loginModel.setError('');
                                  });
                                  loginModel.loading = false;
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyNavigationBar()),
                                  );
                                  loginModel.loading = false;
                                }
                              } catch (error) {
                                loginModel.setError(error.toString());
                              }
                            }
                          },
                          text: 'Login',
                        ),
                ),
                Consumer<LoginModel>(
                  builder: (context, loginModel, _) => Visibility(
                    visible: loginModel.error.isNotEmpty,
                    child: Text(
                      loginModel.error,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 280, bottom: 25),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
