{
  lib,
  maven,
  jdk25_headless,
  makeWrapper,
  fetchFromGitHub,
}:

let

  version = "6.3.0";
in
maven.buildMavenPackage {
  pname = "jplag";
  inherit version;

  src = fetchFromGitHub {
    owner = "jplag";
    repo = "jplag";
    tag = "v${version}";
    hash = "sha256-H3qRl1ZU+FXgOR55WFh9/ynqcXKpxpROUIxDYLAfQoA";
  };

  mvnHash = "sha256-s74LXr2WLEB5+VlPQf2/5e6GET/fdUlvf2WC2kmwqoA=";

  nativeBuildInputs = [ makeWrapper ];

  mvnJdk = jdk25_headless;

  mvnParameters = ''
    -Dmaven.javadoc.skip=true
  '';

  postBuild = ''
    mvn assambly:single
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/jplag
    install -Dm644 cli/target/cli-${version}.jar $out/share/java

    makeWrapper ${jdk25_headless}/bin/java $out/bin/jplag \
      --add-flags "-jar $out/share/java/cli-${version}.jar"
  '';
  meta =
    let
      releasePage = "https://github.com/jplag/JPlag/releases/tag/v${version}";
    in
    {
      description = "State-of-the-Art Source Code Plagiarism & Collusion Detection. Check for plagiarism in a set of programs";
      longDescription = "JPlag finds pairwise similarities among a set of multiple programs. It can reliably detect software plagiarism and collusion in software development, even when obfuscated. All similarities are calculated locally; no source code or plagiarism results are ever uploaded online. JPlag supports a large number of languages.";
      homepage = "https://jplag.de";
      downloadPage = releasePage;
      changelog = releasePage;
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        TureBenrtin
      ];
    };

}
