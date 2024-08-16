#!/bin/bash

#   BitstreamVeraSansMono
#   CodeNewRoman
#   DroidSansMono
#   FiraCode
#   FiraMono
#   Go-Mono
#   Hack
#   Hermit
#   Meslo
#   Noto
#   Overpass
#   ProggyClean
#   RobotoMono
#   SourceCodePro
#   SpaceMono
#   Ubuntu
#   UbuntuMono
declare -a fonts=(
  JetBrainsMono
)

version='2.1.0'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
  mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
  zip_file="${font}.zip"
  download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
  echo "Downloading $download_url"
  wget "$download_url"
  unzip "$zip_file" -d "$fonts_dir"
  rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
