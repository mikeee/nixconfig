final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.0.65";
    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}.tgz";
      hash = "sha256-jn4lN6LZsqjSUdzvmqREnOYJJQFcRc2cpXaKEw5lytU=";
    };
    autoPatchelfIgnoreMissingDeps = previousAttrs.autoPatchelfIgnoreMissingDeps ++ [
      "libc.musl-x86_64.so.1"
    ];
    doInstallCheck = false;
  });
}
