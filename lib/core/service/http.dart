import 'package:browse_station/core/config/app.constant.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dio = Dio(); // With default `Options`.
Future<void> configureDio() async {
  // Set default configs
  dio.options.baseUrl = apiUrl;
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 15);
  dio.options.contentType = Headers.jsonContentType;
  dio.options.headers['User-Agent'] = "PostmanRuntime/7.42.0";
  dio.options.headers = {
    Headers.acceptHeader: Headers.jsonContentType,
    "User-Agent": "PostmanRuntime/7.42.0"
  };

  // internet interceptor
  // dio.interceptors.add(
  //   DioInternetInterceptor(
  //     onDioRequest: (options) {
  //       // options.isOfflineApi = true;
  //       print(options.isOfflineApi);
  //       return options;
  //     },
  //     offlineResponseHandler: (response) {
  //       response.statusCode = 344;
  //       response.statusMessage = 'offline';
  //       response.data = {
  //         'message': 'internet Connection Issue3',
  //       };
  //       // print(response);
  //       // return response;
  //     },
  //     hasConnection: (isConnected) {},
  //     onDioError: (DioException err, ErrorInterceptorHandler handler) {
  //       return DioExceptionHandler(err: err, handler: handler);
  //     },
  //   ),
  // );
  // cache get response
  var cacheDir = await getTemporaryDirectory();

  var cacheStore = HiveCacheStore(
    cacheDir.path,
    hiveBoxName: "appRequestBox",
  );

  var customCacheOptions = CacheOptions(
    store: cacheStore,
    policy: CachePolicy.forceCache,
    priority: CachePriority.normal,
    maxStale: const Duration(minutes: 1),
    hitCacheOnErrorExcept: [401, 404],
    keyBuilder: (request) {
      return request.uri.toString();
    },
    allowPostMethod: false,
  );
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) {
      if (options.uri.toString().contains('transaction')) {
        // final cacheOptions = CacheOptions.fromExtra(options)!;
        options.extra = customCacheOptions
            .copyWith(policy: CachePolicy.forceCache)
            .toExtra();
        return handler.next(options);
      }

      return handler.next(options);
    },
  ));
  dio.interceptors.add(DioCacheInterceptor(options: customCacheOptions));
  // petty log
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (options, args) {
        // don't print requests with uris containing '/posts'
        if (options.path.contains('/posts')) {
          return false;
        }
        // don't print responses with unit8 list data
        return !args.isResponse || !args.hasUint8ListData;
      }));
  dio.interceptors.add(RetryInterceptor(
    dio: dio,
    logPrint: print, // specify log function (optional)
    retries: 1, // retry count (optional)
    retryDelays: const [
      // set delays between retries (optional)
      // Duration(seconds: 1), // wait 1 sec before first retry
      // Duration(seconds: 2), // wait 2 sec before second retry
      // Duration(seconds: 3), // wait 3 sec before third retry
    ],
  ));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // Do something before request is sent.
        // If you want to resolve the request with custom data,
        // you can resolve a `Response` using `handler.resolve(response)`.
        // If you want to reject the request with a error message,
        // you can reject with a `DioException` using `handler.reject(dioError)`.
        print(options.baseUrl);
        // print(options.data);

        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Do something with response data.
        // If you want to reject the request with a error message,
        // you can reject a `DioException` object using `handler.reject(dioError)`.
        // print(response.data);
        // if (response.data == '') {
        //   throw Exception('Internet Issue');
        // }
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Do something with response error.
        // If you want to resolve the request with some custom data,
        // you can resolve a `Response` object using `handler.resolve(response)`.
        print(error.response?.data);
        return handler.next(error);
      },
    ),
  );
}
