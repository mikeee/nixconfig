final: prev:
let
  inherit (final) lib stdenv;
  version = "1.0.65";

  # The universal @github/copilot package is now just a loader stub; the real
  # SEA binary ships in the per-platform package, which we wrap directly.
  platform = {
    x86_64-linux = {
      name = "linux-x64";
      hash = "sha256-XZAUZRrVHbbz/r5YSVSgoZWz2ZfQ7Y9ZrmdJjWMKdd8=";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha512-dOwdy/YbTXQN/+x2v4ZgiDycdRtWElyHxPuA6ail3yJDt0nagwn8OYAA/diBLPMAJuuBXiOZGvvb9fGRuh7Xgg==";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "github-copilot-cli overlay: unsupported system ${stdenv.hostPlatform.system}");
in
{
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (finalAttrs: previousAttrs: {
    inherit version;

    src = final.fetchurl {
      url = "https://registry.npmjs.org/@github/copilot-${platform.name}/-/copilot-${platform.name}-${version}.tgz";
      inherit (platform) hash;
    };

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
