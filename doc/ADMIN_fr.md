# Notes pour l'administration

## Où vit le coffre

Le coffre est `/home/yunohost.app/obsidian/vault`. Les utilisateurs autorisés sur
l'application peuvent le monter en SFTP pour éditer les notes avec un éditeur local ;
tout ce qu'Obsidian stocke lui-même (réglages, greffons, espaces de travail) se trouve
à côté, dans le même dossier de données.

## Une seule session pour tout le monde

L'application diffuse une session de bureau unique : chaque utilisateur autorisé par
la permission partage la même fenêtre et le même coffre. La permission est ouverte à
tous par défaut — restreignez-la à un groupe si les notes sont privées.

## Pas de connexion dans l'application

Obsidian n'a pas de comptes et le flux n'est pas protégé par mot de passe : le
portail YunoHost (SSO) est la seule porte. N'exposez jamais le port interne.

## Taille de l'écran

Le flux adapte le bureau à la fenêtre du navigateur : le texte est rendu à la taille
de votre fenêtre au lieu d'être mis à l'échelle. La taille choisie à l'installation
(`1920x1080` par défaut) n'est qu'une taille de départ : modifiez-la dans le panneau
de configuration, ou en ligne de commande :

```bash
yunohost app config set obsidian main.display.resolution -v 1600x900
```

La taille est écrite dans le lanceur de session : la modifier redémarre l'application
et ferme la session ouverte dans le navigateur.

## Ajouter des fichiers depuis le navigateur

Glissez des fichiers sur la page : ils sont téléversés dans `vault/attachments/` et
Obsidian les voit aussitôt. Pour en intégrer un dans une note, glissez-le depuis
l'explorateur de fichiers d'Obsidian vers la note, ou réglez le « dossier de pièces
jointes » d'Obsidian sur `attachments` pour que ses propres collages y arrivent. Le
panneau de fichiers du client liste ce dossier et propose les téléchargements.

## Presse-papiers

Le presse-papiers se synchronise dans les deux sens avec le navigateur : copier dans
Obsidian place le texte sur votre presse-papiers, et copier sur votre machine permet
de coller dans la session. Le panneau du presse-papiers propose les interrupteurs par
sens, plus « Seamless » pour la synchronisation automatique ; le navigateur peut
demander une autorisation une fois. Cela nécessite l'adresse HTTPS du portail : un
port en HTTP simple ne peut pas accéder à votre presse-papiers.

## Fermer la fenêtre n'est pas définitif

La session de bureau — affichage, gestionnaire de fenêtres, serveur de diffusion — continue de
tourner quand la fenêtre d'Obsidian est fermée, et l'application est relancée sur place :
le navigateur reste connecté. Pour vraiment arrêter la session — avant une maintenance
par exemple — arrêtez l'application :

```bash
yunohost app stop obsidian
```

## Fenêtres réduites

Un panneau en bas de l'écran liste les fenêtres ouvertes : cliquez sur l'entrée
Obsidian pour restaurer une fenêtre réduite. Alt+Tab ne peut pas fonctionner ici — le
navigateur garde cette combinaison pour votre propre bureau.

## Journaux et service

`journalctl -u obsidian -f` pour la session, ou `/var/log/obsidian/obsidian.log`.
Redémarrer le service recrée l'affichage et le flux. Les problèmes d'encodage, de
bande passante ou de presse-papiers apparaissent en lignes `pixelflux` et `selkies`.

## Mises à jour et sauvegardes

`yunohost app upgrade obsidian` remplace les fichiers de l'application et conserve le
coffre et le profil du bureau. Les sauvegardes incluent le coffre et ce profil. Le
serveur de diffusion (Selkies) est un paquet système épinglé : l'application
l'installe, suit la version de `scripts/_common.sh`, et le retire à la désinstallation.

Obsidian Sync, la boutique de greffons et les thèmes communautaires nécessitent un
accès internet sortant depuis le serveur.
