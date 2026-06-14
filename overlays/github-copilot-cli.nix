final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.0.62";
    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}.tgz";
      hash = "sha256-YADhvEnBR89CnyMK1b/Q39mAn03iuGbG70C+umfd+fI=";
    };
    autoPatchelfIgnoreMissingDeps = previousAttrs.autoPatchelfIgnoreMissingDeps ++ [
      "libc.musl-x86_64.so.1"
    ];
    doInstallCheck = false;
  });
}
