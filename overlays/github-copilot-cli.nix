final: prev:
let
  inherit (final) lib stdenv;
  version = "1.0.82";

  # The universal @github/copilot package is now just a loader stub; the real
  # SEA binary ships in the per-platform package, which we wrap directly.
  platform = {
    x86_64-linux = {
      name = "linux-x64";
      hash = "sha256-I4t5YP7IL6l9xdju4BFR9N57WGA8yxhpvEDMmGcBQK0=";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha256-+ufJ0BX10c+5829ZX5shn5WaKTkGbRfuu9mqHWDQPIU=";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "github-copilot-cli overlay: unsupported system ${stdenv.hostPlatform.system}");
  # Copilot's webview binary still links against libxdo.so.3; current xdotool provides SONAME 4.
  libxdo3 = final.xdotool.overrideAttrs (_: rec {
    version = "3.20211022.1";
    src = final.fetchFromGitHub {
      owner = "jordansissel";
      repo = "xdotool";
      rev = "v${version}";
      hash = "sha256-XFiaiHHtUSNFw+xhUR29+2RUHOa+Eyj1HHfjCUjwd9k=";
    };
  });
in
{
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (finalAttrs: previousAttrs: {
    inherit version;

    src = final.fetchurl {
      url = "https://registry.npmjs.org/@github/copilot-${platform.name}/-/copilot-${platform.name}-${version}.tgz";
      inherit (platform) hash;
    };

    buildInputs = previousAttrs.buildInputs ++ [
      final.webkitgtk_4_1
      libxdo3
    ];

    autoPatchelfIgnoreMissingDeps = previousAttrs.autoPatchelfIgnoreMissingDeps ++ [
      "libc.musl-x86_64.so.1"
    ];

    postInstall = ''
      makeWrapper "$out/lib/github-copilot-cli/copilot" "$out/bin/copilot" \
        --add-flag --no-auto-update \
        --set-default NODE_NO_WARNINGS 1 \
        --set-default SSL_CERT_DIR ${final.cacert}/etc/ssl/certs \
        --prefix PATH : "${lib.makeBinPath [ final.bash ]}"
    '';

    doInstallCheck = false;
  });
}
