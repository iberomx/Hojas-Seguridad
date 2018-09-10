#!/bin/bash

# @author Josue Mosiah Contreras Rocha
# @date 9/Septiembre/2018
# @brief Script para sincronizar carpeta compartida usando git 

# Buscar cambios en servidor
git pull --quiet

# Verificar si es necesario hacer push
verify=$(git shortlog origin/master..master | wc -l)

if (($verify != 0)); then
  git push --quiet origin master
fi

# Verificar cambios locales
modified=$(git status -s | wc -l)

if (($modified == 0)); then
  exit
fi

# Verificar si no hay locks para commit
if [[ -f .git/index.lock ]]; then
  rm -rf .git/index.lock
fi

# Guardar cambios locales
git add -A & git commit --allow-empty -m "--"

# Enviar cambios al servidor
if (($? == 0)); then
  git push --quiet origin master
else
  . Actualizar.sh
fi
