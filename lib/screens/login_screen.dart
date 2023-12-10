import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rohagram/Widget/text_field.dart';
import 'package:rohagram/resources/auth_methods.dart';
import 'package:rohagram/responsive/mobile_screen_layout.dart';
import 'package:rohagram/responsive/responsive_layout_screen.dart';
import 'package:rohagram/responsive/web_screen_layout.dart';
import 'package:rohagram/screens/signup_screen.dart';
import 'package:rohagram/utils/colors.dart';
import 'package:rohagram/utils/global_variable.dart';
import 'package:rohagram/utils/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  handleLogin() async {
    setState(() {
      isLoading = true;
    });

    final result = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (result != 'success') {
      if (!context.mounted) return;
     Navigator.of(context).pushNamedAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const ResponsiveLayout(mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreen())) as String,
       (route) => false);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize ? EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width) / 3) : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  hintText: "Enter your email"),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                textInputType: TextInputType.visiblePassword,
                textEditingController: _passwordController,
                hintText: "Enter your password",
                isPass: true,
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: handleLogin,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?  "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigation().navigateTo(const SignupScreen(), context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
