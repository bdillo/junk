{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs,
}:
buildNpmPackage {
  pname = "visual-bundle";
  version = "0.1.0";
  src = ./.;
  npmDepsHash = "sha256-zqycoE43rwW9U8wSXj3tKqIoe858FtV+hMZnd28/C1A=";
  dontNpmBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/visual-bundle" --prefix PATH : ${lib.makeBinPath [ nodejs ]}
  '';
}
