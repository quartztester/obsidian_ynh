# Notes pour l'administration

## Où vit le coffre

Les coffres sont stockés dans `/home/yunohost.app/obsidian/`. Créez-en un ou
ouvrez-en un depuis le bouton « Open folder as vault » de l'application ; rien
n'est stocké en dehors de ce dossier.

## Une seule session pour tout le monde

Le paquet diffuse une session de bureau unique : tous les utilisateurs autorisés
par la permission de l'application partagent les mêmes fenêtres et le même
coffre. Gardez la permission sur `admins` si ce n'est pas le comportement voulu.

## Deux mots de passe

Le portail YunoHost protège la page. Le client navigateur demande ensuite le mot
de passe VNC, lisible avec :

```bash
yunohost app setting obsidian vnc_password
```

Il se change depuis le panneau de configuration de l'application.

## Accélération GPU

L'option transmet le GPU à la session, ajoute l'utilisateur du service aux
groupes `video` et `render`, installe les pilotes VA-API côté espace utilisateur
et active le décodage matériel d'Electron.

Attention à la limite : le serveur X virtuel embarqué (`Xvnc` de TigerVNC) n'a
pas DRI3, donc le bureau lui-même reste rendu en logiciel. Forcer le rendu
matériel y fait quitter Chromium avec « GPU process isn't usable » et la session
redémarre en boucle ; c'est pourquoi le paquet n'active que le décodage. Le rendu
matériel demanderait un serveur X lié nativement au GPU.

Sous bookworm, les utilisateurs Intel peuvent ajouter le paquet non libre
`intel-media-va-driver`, que le paquet n'installe pas.

## Services et journaux

- `obsidian` — l'affichage virtuel et l'application.
- `obsidian-novnc` — la passerelle navigateur.

Les deux écrivent dans `/var/log/obsidian/obsidian.log`.

## Mise à jour

`yunohost app upgrade obsidian` récupère la version amont épinglée. Les coffres
et les réglages sont conservés ; les fichiers de l'application sont remplacés.
