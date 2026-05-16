{ pkgs, ... }:
let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "36" ];
    buildToolsVersions = [ "36.0.0" ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "x86_64" ];
    includeNDK = false;
    includeSources = false;
  };
  androidSdk = androidComposition.androidsdk;
  jdk = pkgs.jdk17;
in
{
  environment.systemPackages = with pkgs; [
    flutter
    android-studio
    androidSdk
    android-tools
    jdk
  ];

  home-manager.users.mike.programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    dart-code.dart-code
    dart-code.flutter
  ];

  users.users.mike.extraGroups = [ "kvm" ];

  environment.variables = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    JAVA_HOME = "${jdk}/lib/openjdk";
  };
}
