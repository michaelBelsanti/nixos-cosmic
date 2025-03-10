{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "gui-scale-applet";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "9251253d6332820d267bf9d825e6af522ae63eb7";
    hash = "sha256-1zCANfgWgDkSTvpvgxzve/ErGel2WF1RxIhv/EdIxxo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2yfeZKsakAeAtNcK8v7hqwMBm7o7HhiNU5mgPevhNvo=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  postInstall = ''
    # mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    # cp data/*.desktop $out/share/applications/
    rm $out/share/icons/hicolor/scalable/status
    mkdir -p $out/share/icons/hicolor/scalable/status
    cp data/icons/scalable/apps/tailscale-icon.png $out/share/icons/hicolor/scalable/status/
  '';

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    description = "Tailscale for cosmic";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
