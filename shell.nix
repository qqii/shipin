{ pkgs ? import <nixpkgs> {} }:

let
  concat_mp4 = pkgs.writeShellScriptBin "concat_mp4" ''
    printf "file '%s'\n" *.mp4 > mylist.txt
    ${pkgs.ffmpeg}/bin/ffmpeg  -f concat -safe 0 -i mylist.txt -c copy output.mp4
  '';
  autorotate_mp4 = pkgs.writeShellScriptBin "autorotate_mp4" ''
    # apply rotation metadata
    mkdir autorotated
    for file in *.mp4; do
      ${pkgs.ffmpeg}/bin/ffmpeg -i "$file" -c:a copy "autorotated/$file";
    done
  '';
in pkgs.mkShell {
  buildInputs = with pkgs; [ 
    mpv
    autorotate_mp4
    concat_mp4
  ];
}