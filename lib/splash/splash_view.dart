import 'package:flutter/material.dart';
import 'package:smart_helmet/home/home_screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (contex) => HomeScreen()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Smart Helmet",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              height: 200,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.asset(
                'assets/icon.png',
                alignment: Alignment.center,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
                "Building with Safety, Powered by Innovation\nThe Smart Helmet You Can Trust!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.amberAccent)),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              color: Colors.amberAccent,
            )
          ],
        ),
      ),
    );
  }
}
