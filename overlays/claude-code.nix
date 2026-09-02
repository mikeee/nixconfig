final: prev:
let
  version = "2.1.252";
  platformKey = "${final.stdenv.hostPlatform.node.platform}-${final.stdenv.hostPlatform.node.arch}";
  platformHashes = {
    "darwin-arm64" = "sha256-tmHGoJT8wyZWv3wAccW0W/kAs01PChqz14/Vmuuiwsc=";
    "darwin-x64" = "sha256-y9Q4kyKdOXugn1pdceObRYMrK4a2Gj6aMrt56bSQGHg=";
    "linux-arm64" = "sha256-bAsy6qk2lUoPTUrSWV+EFq8ojZs8uvGePN2aldfIhT4=";
    "linux-x64" = "sha256-pxWkUQXlk/yYCNA113eB+ISAuYl5danfQYN/DFkb1LM=";
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
