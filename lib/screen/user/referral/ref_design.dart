import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefDesign extends StatelessWidget {
  const RefDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Refer Your Friends & Earn"),
              Spacer(),
              TextButton(
                onPressed: () {
                  context.push('/referral');
                },
                child: Text("Learn More"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
