# http://linuxfr.org/news/utiliser-colout-pour-colorier-tout-ce-qu-affiche-gdb
# Créer le pipe de communication.
shell test -e ~/tmp/coloutPipe && rm ~/tmp/coloutPipe
shell mkfifo ~/tmp/coloutPipe

# Activer la redirection (à appeler APRÈS votre commande)...
define logging_on
  set logging redirect on.
  set logging on ~/tmp/coloutPipe
end
# la désactiver.
define logging_off
  set logging off
  set logging redirect off
  # Voilà la partie foireuse du hack : pour éviter que le prompt ne s'affiche avant la sortie, il faut le faire attendre...
  shell sleep 0.4s
end

# Premier exemple : coloration syntaxique complète du code source.
define hook-list
    shell cat ~/tmp/coloutPipe | colout --all --source Cpp &
    logging_on
end
define hookpost-list
    logging_off
end

# Deuxième exemple : coloration de la pile.
define hook-backtrace
    # Regexp pour [path]file[.ext]: (.*/)?(?:$|(.+?)(?:(\.[^.]*)|))
    shell cat ~/tmp/coloutPipe | colout "^(#)([0-9]+)\s+(0x\S+ )*(in )*(\S+) (\(.*\)) at (.*/)?(?:$|(.+?)(?:(\.[^.]*)|)):([0-9]+)" red,red,blue,none,green,cpp,none,white,white,yellow normal,bold,normal,normal,bold,normal,normal,bold,bold,bold &
    logging_on
end
define hookpost-backtrace
    logging_off
end
