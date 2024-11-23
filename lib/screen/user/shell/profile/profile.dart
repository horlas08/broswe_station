import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/screen/user/shell/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helper/helper.dart';

const String url = 'https/browsestations.com';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffordBg,
      body: Column(
        children: [
          const ProfileHeader(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const PageScrollPhysics(),
              primary: true,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListCard(
                    svgPath: "assets/svg/bank-fill.svg",
                    isSvg: true,
                    name: "My Bank Account",
                    desc: "Tap here to review your bank details",
                    onTap: () {
                      context.push("/deposit");
                    },
                  ),
                  ListCard(
                    icon: Ionicons.arrow_redo,
                    name: "Upgrade Account",
                    desc: "Upgrade and enjoy seamless discount",
                    onTap: () {
                      context.pushNamed("agent");
                    },
                  ),
                  ListCard(
                    icon: Ionicons.information_circle,
                    name: "Enroll Kyc",
                    desc: "Move fund easily by complete your kyc ",
                    onTap: () {
                      context.pushNamed("kyc");
                    },
                  ),
                  ListCard(
                    svgPath: "assets/svg/settings.svg",
                    isSvg: true,
                    name: "User Preference",
                    desc: "protect Your account from intruder",
                    onTap: () async {
                      context.go('/preference');
                    },
                  ),
                  ListCard(
                    svgPath: "assets/svg/shield.svg",
                    isSvg: true,
                    name: "Privacy & Policy",
                    desc: "protect Your account from intruder",
                    onTap: () async {
                      try {
                        final Uri _url = Uri.parse('$url/privacy-policy');
                        await launchUrl(_url);
                      } catch (error) {
                        if (context.mounted) {
                          showToast(context,
                              title: "error", desc: error.toString());
                        }
                      }
                    },
                  ),
                  ListCard(
                    svgPath: "assets/svg/document.svg",
                    isSvg: true,
                    name: "Terms & Conditions",
                    desc: "About out contract with you",
                    onTap: () async {
                      try {
                        final Uri _url = Uri.parse('$url/terms-condition');
                        await launchUrl(_url);
                      } catch (error) {
                        if (context.mounted) {
                          showToast(context,
                              title: "error", desc: error.toString());
                        }
                      }
                    },
                  ),
                  ListCard(
                    icon: Ionicons.chatbubble,
                    name: "Chat with us",
                    desc: "Chat with one of our support",
                    onTap: () async {
                      try {
                        final Uri _url = Uri.parse('$url/contact');
                        await launchUrl(_url);
                      } catch (error) {
                        if (context.mounted) {
                          showToast(context,
                              title: "error", desc: error.toString());
                        }
                      }
                    },
                  ),
                  ListCard(
                    svgPath: "assets/svg/logout.svg",
                    isSvg: true,
                    name: "Sign Out",
                    desc: "Chat with one of our support",
                    onTap: () {
                      handleLogout().then(
                        (value) {
                          if (context.mounted) context.go('/');
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
