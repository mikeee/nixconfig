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
in
{
  environment.systemPackages = with pkgs; [
    flutter
    android-studio
    androidSdk
    android-tools
  ];

  users.users.mike.extraGroups = [ "kvm" ];

  environment.variables = {
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  };
}
