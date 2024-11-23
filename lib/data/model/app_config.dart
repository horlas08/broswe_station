import 'dart:ui';

class AppConfig {
  bool authState;
  bool pinState;
  bool enableFingerPrint;
  bool enableNotification;
  bool enableShakeToHideBalance;
  String themeMode = 'light';
  bool autoTheme = false;
  AppConfig({
    required this.authState,
    required this.pinState,
    required this.themeMode,
    required this.enableFingerPrint,
    required this.enableNotification,
    required this.enableShakeToHideBalance,
    required this.autoTheme,
  });

  AppConfig copyWith({
    bool? authState,
    bool? pinState,
    bool? enableFingerPrint,
    bool? enableNotification,
    bool? enableShakeToHideBalance,
    String? themeMode,
    Color? primaryColor,
    bool? autoTheme,
  }) {
    return AppConfig(
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

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      authState: false,
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
      'pinState': pinState,
      'themeMode': themeMode,
      'enableNotification': enableNotification,
      'enableFingerPrint': enableFingerPrint,
      'enableShakeToHideBalance': enableShakeToHideBalance,
      'autoTheme': autoTheme,
    };
  }
}
