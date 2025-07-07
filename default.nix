{
  emsdk-src,
  stdenvNoCC,
  python3,
}:
stdenvNoCC.mkDerivation {
  name = "emsdk";
  src = emsdk-src;

  nativeBuildInputs = [
    python3
  ];

  buildPhase = ''
    unset SSL_CERT_FILE
    unset NIX_SSL_CERT_FILE
    ./emsdk install latest
  '';

  installPhase = ''
    mkdir -p $out/share/emsdk
    mv * $out/share/emsdk
  '';

  dontPatchShebangs = true;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-1SbOyiHItUIIVnFmpfNQgJR7FSwi6cuJZ9CVmXdnCFA=";
  # outputHash = lib.fakeHash;
}
