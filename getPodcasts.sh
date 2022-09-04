#! /bin/bash

echo "Entrer l'url du podcast Radio France"
read -r -p ">>>" URL
regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

while true # perform a regular expression match of the $URL to its left regular expression
do
  if [[ ! $URL =~ $regex ]]; then 
    echo "Lien non valide, entrez à nouveau le lien : "
    read URL
  else break 1
  fi
done

content=$(wget $URL -q -O - )


download=$(echo $content | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep mp3 | head -1)

echo "Url de téléchargement : $download"

wget $download

filename=$(echo ${download##*/})

echo $filename

ANSWER=""
while [ "$ANSWER" == ""  ]
do
  echo "Voulez-vous renommer le fichier ? (O/N)"
  read -r -p ">>>" ANSWER
  IFS=''
 case $ANSWER in
    O|o)
      echo "Entrez le nom du fichier (sans extension)"
      ext=$(echo "${filename##*.}")
      read -r -p ">>>" NAME
      var=$(echo $NAME)
      mv $filename $var.$ext
      echo "Podcast $var.$ext à bien été enregistré"
      break
    ;;
    N|n)
      echo "Podcast enregistré sous le nom : $filename"
    ;;
    *)
      echo "Réponse non valide"
      ANSWER=""
    ;;
 esac
done
