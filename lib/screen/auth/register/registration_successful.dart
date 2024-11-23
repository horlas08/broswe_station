import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationSuccessful extends StatelessWidget {
  const RegistrationSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/gif/success.gif',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Account Created And Verify Successfully",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // WidgetSpan(
                    //   child: Image.asset(
                    //     'assets/images/ice-cream.png',
                    //     height: 40,
                    //   ),
                    // )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/user');
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    const Size.fromHeight(65),
                  ),
                ),
                child: const Text(
                  "Ok \u{1F919} Lets Go ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
