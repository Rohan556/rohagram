import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rohagram/providers/user_provider.dart';
import 'package:rohagram/responsive/mobile_screen_layout.dart';
import 'package:rohagram/responsive/responsive_layout_screen.dart';
import 'package:rohagram/responsive/web_screen_layout.dart';
import 'package:rohagram/screens/login_screen.dart';
import 'package:rohagram/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyB9RAteT_Tf6c4V0Uklmog0lvLBUWf25Nw",
            appId: "1:427710575236:web:c5b30451eed20cf2c688d1",
            messagingSenderId: "427710575236",
            projectId: "rostagram-5f39c",
            storageBucket: "rostagram-5f39c.appspot.com"));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        title: "Instagram clone",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: const Scaffold(
        //   body: ResponsiveLayout(
        //       mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreen()),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            print(snapshot.hasData);
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreen());
              }else if(snapshot.hasError){
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
