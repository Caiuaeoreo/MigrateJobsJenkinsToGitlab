#!/bin/bash

output_directory="migraçãoGitLab"

# Definir IFS para quebrar linhas em vez de espaços
IFS=$'\n'

for directory in */; do
  config_file="${directory}config.xml"

  if [ -f "$config_file" ]; then
    repos=$(sed 's/<defaultValue>/<defaultValue>\n/g' "$config_file" | sed 's/<\/defaultValue>/\n<\/defaultValue>/g' | sed '/<\/defaultValue>/,$d' | awk '/\<defaultValue/{f=1;next} f' | sed '/^$/d')

    echo "$repos"

    if [ -n "$repos" ]; then

    # Remover a barra final do nome do diretório
    directory=$(echo "$directory" | sed 's/\/$//')

    template="---\napp_name: '$directory'\nrepo_list:"

    while IFS= read -r repo; do
    template+="\n - '$repo'"
    done <<< "$repos"

    # Extrair o número do diretório, se existir
    number=$(echo "$directory" | grep -oE '^[0-9]+')

      if [ -z "$number" ]; then
        filename="${directory}.yaml"
      else
        filename="$number.yaml"
      fi

    echo -e "$template\n" > "${output_directory}/${filename}"
    fi
  fi
done
