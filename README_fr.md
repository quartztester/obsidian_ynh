# Obsidian pour YunoHost

[![Installer Obsidian avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=obsidian)

*[Read this readme in english.](./README.md)*

> Obsidian est une application de prise de notes Markdown : les notes restent des
> fichiers simples dans un coffre qui vous appartient, reliées par des `[[liens wiki]]`
> et enrichies par des greffons et des thèmes communautaires.

Ce paquet exécute l'application de bureau Obsidian sur le serveur et diffuse la
session dans votre navigateur : le coffre est accessible depuis n'importe quel
appareil, sans y installer Obsidian.

## Fonctionnalités

- Notes en fichiers Markdown simples, conservées dans `/home/yunohost.app/obsidian/vault`
- Liens wiki, vue graphe, greffons et thèmes communautaires
- Session navigateur derrière le portail YunoHost — aucun mot de passe séparé à gérer
- Presse-papiers synchronisé dans les deux sens et dépôt de fichiers par glisser-déposer
- La taille du bureau suit la fenêtre du navigateur ; la taille configurée n'est que le point de départ
- Encodage vidéo matériel quand le serveur expose un GPU

## Captures d'écran

![Obsidian dans le navigateur](./doc/screenshots/obsidian.png)

## Installation

```bash
yunohost app install obsidian
```

Le formulaire demande le domaine, un sous-chemin facultatif, la taille de départ du
bureau et qui peut y accéder. Un coffre est une donnée personnelle : restreignez la
permission à un groupe si les notes ne sont pas destinées à tous les comptes du serveur.

## Documentation

- [Notes pour l'administration](./doc/ADMIN_fr.md)
- Amont : <https://obsidian.md/>

## Licence

L'empaquetage est en GPL-3.0. Obsidian lui-même est un logiciel propriétaire
distribué par Dynalist Inc. ; ce paquet se contente de télécharger la version
officielle amont.
