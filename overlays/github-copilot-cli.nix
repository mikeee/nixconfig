final: prev:
let
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
    buildInputs = previousAttrs.buildInputs ++ [
      final.webkitgtk_4_1
      libxdo3
    ];

    autoPatchelfIgnoreMissingDeps = previousAttrs.autoPatchelfIgnoreMissingDeps ++ [
      "libc.musl-x86_64.so.1"
    ];
  });
}
