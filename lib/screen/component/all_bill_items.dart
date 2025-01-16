import 'package:browse_station/core/config/color.constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../core/config/font.constant.dart';
import 'dashboard/all_services.dart';

class AllBillItems extends HookWidget {
  final String name;
  final String desc;
  final IconData icon;
  final IconData? arrow;
  final VoidCallback onTap;
  const AllBillItems(
      {super.key,
      required this.name,
      required this.icon,
      this.arrow,
      required this.onTap,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    final response = useState([]);

    useEffect(() {
      getLabel(context).then(
        (value) {
          response.value = value.data['data'];
        },
      );
      return null;
    }, []);
    final label = response.value.firstWhere(
      (element) {
        return element['title']?.toLowerCase() == name.toLowerCase();
      },
      orElse: () {
        return {};
      },
    );
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.primaryColor,
              size: 35,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.primaryColor,
                        fontFamily: AppFont.segoui,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    if (label.isNotEmpty)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            // bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                        ),
                        width: 25,
                        height: 12,
                        child: Center(
                          child: Text(
                            label['details'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                        ),
                      )
                  ],
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.greyColor,
                    fontFamily: AppFont.segoui,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              arrow ?? Icons.arrow_forward_ios_rounded,
            )
          ],
        ),
      ),
    );
  }
}
