import 'dart:ui';

class App {
  bool authState;
  bool onboardSkip;
  bool pinState;
  bool enableFingerPrint;
  bool enableNotification;
  bool enableShakeToHideBalance;
  String themeMode = 'light';
  bool autoTheme = false;
  App({
    required this.onboardSkip,
    required this.authState,
    required this.pinState,
    required this.themeMode,
    required this.enableFingerPrint,
    required this.enableNotification,
    required this.enableShakeToHideBalance,
    required this.autoTheme,
  });

  App copyWith({
    bool? authState,
    bool? onboardSkip,
    bool? pinState,
    bool? enableFingerPrint,
    bool? enableNotification,
    bool? enableShakeToHideBalance,
    String? themeMode,
    Color? primaryColor,
    bool? autoTheme,
  }) {
    return App(
      onboardSkip: onboardSkip ?? this.onboardSkip,
      authState: authState ?? this.authState,
      pinState: pinState ?? this.pinState,
      enableFingerPrint: enableFingerPrint ?? this.enableFingerPrint,
      enableNotification: enableNotification ?? this.enableNotification,
      enableShakeToHideBalance:
          enableShakeToHideBalance ?? this.enableShakeToHideBalance,
      themeMode: themeMode ?? this.themeMode,
      autoTheme: autoTheme ?? this.autoTheme,
    );
  }

  @override
  String toString() {
    return 'App{authState: $authState, themeMode: $themeMode, enableNotification: $enableNotification,enableFingerPrint: $enableFingerPrint,}';
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      authState: false,
      onboardSkip: json['onboardSkip'] as bool,
      pinState: json['pinState'] as bool,
      enableNotification: json['enableNotification'] as bool,
      enableFingerPrint: json['enableFingerPrint'] as bool,
      enableShakeToHideBalance: json['enableShakeToHideBalance'] as bool,
      themeMode: json['themeMode'] as String,
      autoTheme: json['autoTheme'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authState': authState,
      'onboardSkip': onboardSkip,
      'pinState': pinState,
      'themeMode': themeMode,
      'enableNotification': enableNotification,
      'enableFingerPrint': enableFingerPrint,
      'enableShakeToHideBalance': enableShakeToHideBalance,
      'autoTheme': autoTheme,
    };
  }
}
