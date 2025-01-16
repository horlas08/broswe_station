import 'package:browse_station/core/config/color.constant.dart';
import 'package:browse_station/core/service/http.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../core/state/bloc/repo/app/app_bloc.dart';

final cacheStore = MemCacheStore();
final cacheOptions = CacheOptions(
  policy: CachePolicy.noCache,
  store: cacheStore, // Do not cache this request
);

Future<Response<dynamic>> getLabel(BuildContext context) async {
  final res = await dio.get(
    '/services/get-labels',
    options: Options(
      headers: {
        'Authorization': "Bearer ${context.read<AppBloc>().state.user?.apiKey}"
      },
      extra: cacheOptions.toExtra(),
    ),
  );

  return res;
}

class AllServices extends HookWidget {
  const AllServices({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allServices = [
      {
        "icon": Ionicons.phone_portrait_outline,
        "name": "Airtime",
        "desc": 'Buy airtime for all Network',
        "route": "/airtime"
      },
      {
        "icon": Ionicons.phone_portrait,
        "name": "Data",
        "desc": 'Buy cheap data bundle',
        "route": "/data"
      },
      {
        "icon": Ionicons.tv,
        "name": "Tv",
        "desc": 'Pay for cable tv subscription',
        "route": "/cable"
      },
      {
        "icon": Ionicons.flash_outline,
        "name": "Power",
        "desc": 'Top up prepaid electricity meter',
        "route": "/electricity"
      },
      {
        "icon": Ionicons.gift_outline,
        "name": "Gift Card",
        "route": "/gift-card"
      },
      {
        "icon": Ionicons.extension_puzzle_outline,
        "name": "E-SIM",
        "route": "/esim"
      },
      {"icon": Ionicons.basketball, "name": "Betting", "route": "/betting"},
      {
        "icon": Ionicons.ellipsis_horizontal,
        "name": "More",
        "route": "/all/bill"
      }
    ];
    final response = useState([]);
    useEffect(() {
      if (response.value.isEmpty) {
        getLabel(context).then(
          (value) {
            response.value = value.data['data'];
          },
        );
      }

      return null;
    }, []);

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Center(
        child: Wrap(
          spacing: 30.0, // gap between adjacent chips
          runSpacing: 14.0,
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.down,
          runAlignment: WrapAlignment.spaceBetween,
          children: [
            ...allServices.map(
              (item) {
                // final search = response.where((element) {
                //   return element['field'] == element['name'];
                // },);
                final label = response.value.firstWhere(
                  (element) {
                    print(item['name'].toLowerCase());
                    return element['title']?.toLowerCase() ==
                        item['name'].toLowerCase();
                  },
                  orElse: () {
                    return {};
                  },
                );
                print(label);
                if (label.isNotEmpty) {
                  print(label);
                }
                return TouchableOpacity(
                  onTap: () {
                    context.go(item['route']);
                  },
                  child: Stack(
                    children: [
                      if (label.isNotEmpty)
                        Positioned(
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                // bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                            ),
                            width: 23,
                            height: 13,
                            child: Center(
                              child: Text(
                                label['details']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Icon(
                                item['icon'],
                                size: 30,
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Text(item['name']),
                        ],
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
