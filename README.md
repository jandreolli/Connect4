# MIPS Assembly Project - Connect 4 Game (Jeu Puissance 4)

Projet en assembleur MIPS réalisé dans le cadre de l'UE "Architecture des ordinateurs" pour la L2S3 Informatique à l'UFR Mathématique et Informatique Strasbourg.

## Pour commencer

### Pré-requis

- Le simulateur ``Mars4_5.jar`` disponible ici http://courses.missouristate.edu/kenvollmar/mars/


### Démarrage

- Pour lancer l'émulateur MARS, taper cette commande dans le terminal:

```
java -jar Mars4_5.jar
```

- Charger le fichier ``Puissance_4.asm``, l'assembler puis aller dans l'onglet **Tools** pour lancer **Bitmap Display**.

- Dans la fenêtre **Bitmap Display**, sélectionner:
	+ **8** pour **Unit Width in Pixels** et **Unit Height in Pixels**
	+ **512** pour **Display Width in Pixels** et **Display Height in Pixels** 
	+ **0x10040000(heap)** pour **Base adress for display**

- Finalement, cliquer sur le widget **Connect to MIPS** et lancer l'exécution du programme.

![readmepuissance4_1](https://user-images.githubusercontent.com/95167842/170264451-ef9fc364-4e04-4d0a-8d78-ce0e13482d51.png)

## Pour jouer à Puissance 4

### Principe du jeu 

- Puissance 4 se joue à deux, pour gagner il faut réussir à placer 4 jetons de sa couleur dans le tableau soit de manière:
	+ **horizontale** 
	+ **verticale** 
	+ **diagonale** _(avant ou arrière)_

### Déroulement du programme

- Lorsque vous lancez le programme, la console demande à chaque joueur d'entrer une couleur pour son jeton, parmi:
	+ **1** : _Rouge_ 
	+ **2** : _Jaune_
	+ **3** : _Violet_
	+ **4** : _Vert_
	+ **5** : _Rose_
	+ **6** : _Bleu_
	
**NB** : Vous ne pouvez pas choisir la même couleur de jeton que votre adversaire.

- Ensuite à tour de rôle, chaque joueur entre le numéro de la colonne _(entre 1 et 7 inclus)_ où il souhaite positionner son jeton.

- Une fois le jeton placé, on regarde si: 
	+ **le joueur a gagné** &#8594; le dernier jeton placé par le joueur a permis d'aligner 4 jetons d'affilés 
	+ **le tableau est entièrement rempli** &#8594; il y a égalité
	+ **le jeu continu** &#8594; le jeton placé n'a pas permis au joueur de gagner


### Fin du jeu 

- À la fin du jeu, le gagnant est affiché sur la console et le programme propose de relancer une nouvelle partie.


## Auteurs

* **Justine Andreolli**  _alias_ [@jandreolli](https://github.com/jandreolli)
* **Ambre Lis**  _alias_ [@ambrelis](https://github.com/ambrelis)






