final: prev:
let
  platformKey = "${final.stdenv.hostPlatform.node.platform}-${final.stdenv.hostPlatform.node.arch}";
  platformHashes = {
    "darwin-arm64" = "sha256-6QNkbYt6MYgqgOzSdWmifYrFezcIdF80lwljLIQRf98=";
    "darwin-x64" = "sha256-kU8jpwu+1dmuVn4+BLhiBu2ZcbNxvJuso/eciIW/3bQ=";
    "linux-arm64" = "sha256-G7nQMkQKdVMvfdTK+8aH8iCq8Wxj66F+GS377C8EvSU=";
    "linux-x64" = "sha256-hJ4AcnegRCqydXDT49bUN4dQeUZZDo3RlH5aObcIH54=";
  };
in {
  claude-code = prev.claude-code.overrideAttrs (finalAttrs: {
    version = "2.1.170";
    src = final.fetchurl {
      url = "https://downloads.claude.ai/claude-code-releases/${finalAttrs.version}/${platformKey}/claude";
      hash = platformHashes.${platformKey}
        or (throw "Unsupported claude-code platform: ${platformKey}");
    };
  });
}
