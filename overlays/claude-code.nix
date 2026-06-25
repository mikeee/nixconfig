final: prev:
let
  version = "2.1.191";
  platformKey = "${final.stdenv.hostPlatform.node.platform}-${final.stdenv.hostPlatform.node.arch}";
  platformHashes = {
    "darwin-arm64" = "sha256-mf37VSpSYOZJrt0GwCTQpBBbCc7+wL9n1VjgF+5mxAA=";
    "darwin-x64" = "sha256-boOq1fxP1Fn9dFOc2gbSJ5EF6sK+/GA9L7pklJdMsqQ=";
    "linux-arm64" = "sha256-GjGny8/XhPjAc7/IoKFYP7bpPmDvcLdtf89mP/7YlJs=";
    "linux-x64" = "sha256-EDjbqIvfG4CUHcPjg+k7CIMlsASXMprFDaRgyHhtW+4=";
  };
in {
  claude-code = prev.claude-code.overrideAttrs {
    inherit version;
    src = final.fetchurl {
      url = "https://downloads.claude.ai/claude-code-releases/${version}/${platformKey}/claude";
      hash = platformHashes.${platformKey}
        or (throw "Unsupported claude-code platform: ${platformKey}");
    };
  };
}
