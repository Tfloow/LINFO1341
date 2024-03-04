# LINFO1341

[rapport](https://www.overleaf.com/7468676515txmbthrndjmd#b9fe89)

## Capturer les paquets

```
cd P1
sh main.sh
```

Lancer depuis un terminal à part (**Pas VSCode** sinon ça bug). Cela va fermer votre firefox et puis rouvrir avec la page de onedrive.

Faites vos manipulations puis fermer le navigateur. La capture va se terminer toute seule.

Toutes les traces sont dans le dossier [P1/trace/](P1/trace/) et les clés SSL sont dans [P1/](P1/). Tout est numéroté par date de capture. (j'ai essayé de sauvegarder les clés SSL localement mais ça ne voulait pas. C'est lié au permission de tcpdump)

Pour nettoyer toutes les traces on peut faire:

```
sh clean.sh
```