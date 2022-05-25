###############################################################################
# Auteurs: ANDREOLLI Justine - TD2 TP4
#	   LIS Ambre - TD2 TP3
# 
# Projet Assembleur MIPS Puissance 4 dans le cadre de l'UE "Architecture des Ordinateurs"
# L2S3 - UFR Mathématique Informatique Strasbourg 2022
#
###############################################################################

#  Pojet AO Printemps 2021-2022
#  Date de rendu: 12/13/17 11:00AM

################################################################################################################################# 
##  Ce fichier contient un squelete de code pour le jeu du puissance 4.
##  L'ensemble des fonctions d'affichage est deja en place. L'affichage repose sur l'ecriture de carres de 8x8px.
##  Les fonctions a completer sont les suivantes :
##  
################################################################################################################################# 
.data

Colors:	#  Contient les couleurs
 .word 0x0000FF # [0] Bleu   0x0000FF	Grille
 .word 0xFF0000 # [1] Rouge  0xFF0000	Jeton joueur 1
 .word 0xE5C420 # [2] Jaune  0xE5C420	Jeton joueur 2
 ###################  Ajouté par nous  ################### 
 .word 0x7050c0 # [3] Violet 0x7050c0
 .word 0x6aa84f # [4] Vert   0x6aa84f
 .word 0xf24bbe # [5] Rose   0xf24bbe
 .word 0x81c4ed # [6] Bleu   0x81c4ed
 #########################################################
 .word 0xFFFFFF # [7] Blanc  0xFFFFFF	Fond
 


#  Un cercle est definit par une suite de lignes horizontales.
#  Chaque ligne est definie par un offset suivit d'une longeur (ex : 2, 4, on decale de deux carres et on dessine 4 carres
CircleDef: 
	.word 2, 4, 1, 6, 0, 8, 0, 8, 0, 8, 0, 8, 1, 6, 2, 4

displayStart: .asciiz "Bienvenue dans ce jeu du puissance 4!\nC'est un jeu a deux joueurs.\nLe joueur 1 va commencer.\nEntrez un nombre entre 1 et 7 pour choisir la colonne où jouer.\nUne fois qu'un joeur a joué, attendez que la console demande une nouvelle action pour jouer!\n\nBon Jeu!\n\n"
displayP1: .asciiz "\nTour du joueur 1 : "
displayP2: .asciiz "\nTour du joueur 2 : "
displayP1Win: .asciiz "Le joueur 1 a gagne !\n"
displayP2Win: .asciiz "Le joueur 2 a gagne !\n"
displayInstructions: .asciiz "Choisissez un nombre entre 1 et 7 (inclus)\n"
displayFull: .asciiz "la colonne choisie est pleine. Choisissez en une autre.\n"
displayTie: .asciiz "Il y a egalite !\n"

########################## Ajouté par nous ############
trackJetons:			.word 0:42		#  0 = place disponible; X = place prise par joueur X; Y = place prise par joueur Y
couleurJoueur1:			.word 1		        # couleur choisie par l'utilisateur, par défaut elle sera Rouge
couleurJoueur2:			.word 2		        # couleur choisie par l'utilisateur, par défaut elle sera Jaune
nouvellePartie:			.asciiz "Si vous souhaitez relancer une partie, tapez 1 sinon tapez 2\n"
choixCouleurJoueur1:		.asciiz "Numéro de couleur pour joueur 1: \n"
choixCouleurJoueur2:		.asciiz "Numéro de couleur pour joueur 2: \n"
choixCouleur:      		.asciiz "Tapez le numéro correspondant à la couleur du jeton que vous souhaitez:\n 1:Rouge ; 2:Jaune ; 3:Violet ; 4:Vert ; 5:Rose ; 6:Bleu\n \n"
mauvaiseCouleur:		.asciiz "Veuillez choisir une couleur différente de votre adversaire.\n"
#######################################################

.text

Init:
la $a0, ($sp)
li $v0, 1
syscall

#  Dessine le plateau
jal DrawGameBoard

#  Début du jeu
la $a0, displayStart	
li $v0, 4
syscall

########################## Ajouté par nous ############
# t0 : couleur du joueur 1

		# Propose aux joueurs les différentes couleurs disponibles
		la $a0 choixCouleur
		li $v0 4
		syscall

couleur1: 	# Propose au joueur 1 de choisir une couleur de jeton
		la $a0 choixCouleurJoueur1
		li $v0 4
		syscall

		# Récupère la réponse du joueur 1 
		li $v0 5
		syscall
		
		# Vérifie si la réponse du joueur est valide et stocke sa réponse dans une variable
		bgt $v0 6 couleur1			# si le choix n'est pas compris entre 1 et 6 inclus --> redemande au joueur d'entrer une couleur
		blt $v0 1 couleur1
		sw  $v0 couleurJoueur1			# couleurJoueur1 contient le numéro de la couleur choisie par le joueur

couleur2:	# Propose au joueur 2 de choisir une couleur de jeton
		la $a0 choixCouleurJoueur2
		li $v0 4
		syscall

		# Vérifie si la réponse du joueur est valide et stocke sa réponse dans une variable
		li  $v0 5
		syscall
		
		bgt $v0 6 couleur2			# si le choix n'est pas compris entre 1 et 6 inclus --> redemande au joueur d'entrer une couleur
		blt $v0 1 couleur2
		
		lw  $t0 couleurJoueur1
		beq $v0 $t0 couleurAdversaire		# si le choix est pareil que celui du joueur1 --> va au label couleurAdversaire
		sw  $v0 couleurJoueur2			# sinon stocke la valeur de la couleur dans la variable couleurJoueur2

		j main
		
		# Cas où la couleur choisie par le joueur 2 est la même que celle du joueur 1
couleurAdversaire:
		la $a0 mauvaiseCouleur
		li $v0 4
		syscall
		j couleur2
########################################



################################   Fonction Main ################################  
main:

#  Récupère l'instruction du joueur 1
playerOne:
la $a0, displayP1
li $v0, 4
syscall
li $v0, 5
syscall

#  Place le jeton et contrôle si il y a une erreur
lw $a0, couleurJoueur1					### modification par nous
jal UpdateRecord

#  Dessine le jeton
lw $a0, couleurJoueur1					### modification par nous
jal DrawPlayerChip

#  Test si le joueur 1 a gagner sinon on revient et on passe a la suite (instruction "playerTwo:")
jal WinCheck

#  Recupere l'instruction du joueur 2
playerTwo:
la $a0, displayP2
li $v0, 4
syscall
li $v0, 5
syscall

#  Place le jeton et controle si il y a une erreur
lw $a0, couleurJoueur2					# modifié par nous 
jal UpdateRecord

#  Dessine le jeton
lw $a0, couleurJoueur2					# modifié par nous
jal DrawPlayerChip

#  Test si le joueur 2 a gagner sinon on passe a la suite (instruction "j main")
jal WinCheck

j main	#  Passe au porchain tour
################################   Fin de la fonction Main ################################  



################################   Debut des procedures d'affichage ################################  
##################### Il n'est pas obligatoire de comprendre ce qu'elles font. ##################### 
# Procedure: DrawPlayerChip
# Input: $a0 - Numero du joueur
# Input: $v0 - Position (entre 0 et 41)
DrawPlayerChip:
	
	addiu $sp, $sp, -12
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $v0, 8($sp)
	
	#  place la couleur du jeton en argument
	move $a2, $a0
	
	#  On calcul la position
	li $t0, 7
	div $v0, $t0
	mflo $t0	# Division (Y)
	mfhi $t1	# Reste (X)

	#  Y-Position = 63-[(Y+1)*9+4] = 50-9Y (dans $t0)
	li $t2, 50
	mul $t0, $t0, 9
	mflo $t0
	sub $t0, $t2, $t0 
	
	# X-Position = [X*9]+1 (dans $t1)
	mul $t1, $t1, 9
	addi $t1, $t1, 1
	
	#  Copie les positions dans les registres d'arguments
	move $a0, $t1
	move $a1, $t0
	
	jal DrawCircle
	
	lw $v0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra

# Procedure: DrawGameBoard
# Affiche la grille
DrawGameBoard:
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	
	#  Fond en blanc
	li $a0, 0
	li $a1, 0
	li $a2, 7					# modifé par nous (a2 = 7 car c'est l'index de la couleur blanc)
	li $a3, 64
	jal DrawSquare #  Affiche un carre blanc de 64x64 en position 0,0)
	
	#  Ligne du haut
	li $a0, 0	
	li $a1, 0	
	li $a2, 0	
	li $a3, 64	
	jal DrawHorizontalLine
	li $a1, 1
	jal DrawHorizontalLine
	li $a1, 2	
	jal DrawHorizontalLine
	li $a1, 3	
	jal DrawHorizontalLine
	li $a1, 4	
	jal DrawHorizontalLine
	
	#  Ligne du bas
	li $a0, 0	
	li $a1, 58	
	li $a2, 0	
	li $a3, 64	
	jal DrawHorizontalLine
	li $a1, 59
	jal DrawHorizontalLine
	li $a1, 60	
	jal DrawHorizontalLine
	li $a1, 61	
	jal DrawHorizontalLine
	li $a1, 62	
	jal DrawHorizontalLine
	li $a1, 63	
	jal DrawHorizontalLine


	#  Lignes verticales
	li $a0, 0	
	li $a1, 0	
	li $a2, 0	
	li $a3, 64	
	jal DrawVerticalLine	
	li $a0, 9	# (X = 9)
	jal DrawVerticalLine
	li $a0, 18	# (X = 18)
	jal DrawVerticalLine
	li $a0, 27	# (X = 27)
	jal DrawVerticalLine
	li $a0, 36	# (X = 36)
	jal DrawVerticalLine
	li $a0, 45	# (X = 45)
	jal DrawVerticalLine
	li $a0, 54	# (X = 54)
	jal DrawVerticalLine
	li $a0, 63	# (X = 63)
	jal DrawVerticalLine

	#  Lignes horizontales
	li $a0, 0	
	li $a1, 13	
	li $a2, 0	
	li $a3, 64	
	jal DrawHorizontalLine
	li $a1, 22
	jal DrawHorizontalLine
	li $a1, 31	
	jal DrawHorizontalLine
	li $a1, 40	
	jal DrawHorizontalLine
	li $a1, 49	
	jal DrawHorizontalLine

	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra


# Procedure: DrawCircle
# Input - $a0 = X 
# Input - $a1 = Y
# Input - $a2 = Color (0-5)
# Affiche le Jeton
DrawCircle:
	#  Fait de a place sur la pile
	addiu $sp, $sp, -28 	
	#  Y ajoute les arguments suivants $ra, $s0, $a0, $a2
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	li $s2, 0	#  Initaitllise le compteur et on passe dans la boucle de la fonction
	
CircleLoop:
	la $t1, CircleDef
	#  Utilise le compteur pour recuperer le bon indice dans CircleDef
	addi $t2, $s2, 0	
	mul $t2, $t2, 8		
	add $t2, $t1, $t2	
	lw $t3, ($t2)		
	add $a0, $a0, $t3	
	
	#  On dessine la ligne
	addi $t2, $t2, 4	
	lw $a3, ($t2)		
	sw $a1, 4($sp)		
	sw $a3, 0($sp)		
	sw $s2, 24($sp)		
	jal DrawHorizontalLine
	
	#  On remet en place les arguments
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	lw $s2, 24($sp)
	addi $a1, $a1, 1	#  Incremente Y value
	addi $s2, $s2, 1	#  Incremente le compteur
	bne $s2, 8, CircleLoop	#  On boucle pour ecrire les 8 lignes
	
	
	#  Restaure les valeurs de $ra, $s0, $sp
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 28
	jr $ra
	
# Procedure: DrawSquare
# Input - $a0 = X 
# Input - $a1 = Y
# Input - $a2 = Color (0-5)
# Input - $a3 = W 
# Dessine un carre de taille WxW en position (X, Y)
DrawSquare:
	addiu $sp, $sp, -24 	# Sauvegarde $ra, $s0, $a0, $a2
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	move $s0, $a3		
	
BoxLoop:
	sw $a1, 4($sp)	
	sw $a3, 0($sp)	
	jal DrawHorizontalLine
	
	# Restaure $a0-3
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	addi $a1, $a1, 1	# Incremente Y 
	addi $s0, $s0, -1	# Decremente le nombre de ligne
	bne $zero, $s0, BoxLoop	# Jusqu'a ce que le compteur soit a zero
	
	# Restaure $ra, $s0, $sp
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 24	# Reset $sp
	jr $ra
	
# Procedure: DrawHorizontalLine
# Input - $a0 = X 
# Input - $a1 = Y
# Input - $a2 = Color (0-5)
# Input - $a3 = W
# Dessine une ligne horizontale de longueur W en position (X, Y)
DrawHorizontalLine:
	addiu $sp, $sp, -28 	
	# Sauvegarde $ra, $a1, $a2
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
HorizontalLoop:
	# Sauvegarde $a0, $a3 
	sw $a0, 4($sp)
	sw $a3, 0($sp)
	jal DrawPixel
	# Restaure tout sauf $ra
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1		# Decremente la longueur W
	addi $a0, $a0, 1		# Incremente X 
	bnez $a3, HorizontalLoop	# Boucle tant que W > 0 	
	lw $ra, 16($sp)			# Restaure $ra
	lw $a0, 20($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28		# Restaure $sp
	jr $ra
	
# Procedure: DrawVerticalLine
# Input - $a0 = X 
# Input - $a1 = Y
# Input - $a2 = Color (0-5)
# Input - $a3 = W
# Dessine une ligne verticale de longeur W en position (X, Y)
DrawVerticalLine:
	addiu $sp, $sp, -28
	# Sauvegarde $ra, $a1, $a2
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
VerticalLoop:
	# Save $a0, $a3 (changes with next procedure call)
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	jal DrawPixel
	# Restore all but $ra
	lw $a1, 4($sp)
	lw $a0, 20($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1		# Decremente la longueur W
	addi $a1, $a1, 1		# Incremente Y 
	bnez $a3, VerticalLoop		# Boucle tant que W > 0 	
	lw $ra, 16($sp)			# Restaure $ra
	lw $a1, 12($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28		# Restaure $sp
	jr $ra
	
# Procedure: DrawPixel
# Input - $a0 = X
# Input - $a1 = Y
# Input - $a2 = Color (0-5)
# Dessine un pixel sur la Bitmap en ecrivant au bon endroit sur la memoire (sur le tas/heap) via la fonction GetAddress
DrawPixel:
	addiu $sp, $sp, -8
	# Save $ra, $a2
	sw $ra, 4($sp)
	sw $a2, 0($sp)
	jal GetAddress		# Calcule l'adresse memoire
	lw $a2, 0($sp)		
	sw $v0, 0($sp)		
	jal GetColor		# Recupere la couleur
	lw $v0, 0($sp)		
	sw $v1, ($v0)		# Ecrit la couleur en memoire
	lw $ra, 4($sp)		
	addiu $sp, $sp, 8	
	jr $ra


# Procedure: GetAddress
# Input - $a0 = X
# Input - $a1 = Y
# Output - $v0 = l'adresse memoire exacte où écrire le pixel
GetAddress:
	sll $t0, $a0, 2			# Multiplie X par 4
	sll $t1, $a1, 8			# Multiplie Y par 64*4 (512/8= 64 * 4 words)
	add $t2, $t0, $t1		# Additionne les deux 
	addi $v0, $t2, 0x10040000	# Ajout de l'adresse pointé par Bitmap (heap) 
	jr $ra

# Procedure: GetColor
# Input - $a2 = Index dans Colors (0-5)
# Output - $v1 = valeur Hexadécimale
# Retourne la valeur Hexadécimale de la couleur demandée
GetColor:
	la $t0, Colors		
	sll $a2, $a2, 2		
	add $a2, $a2, $t0	
	lw $v1, ($a2)		
	jr $ra

################################   Fin des procédures d'affichage ################################  



################################ Début UpdateRecord ################################ 
# Procedure: UpdateRecord
# Input: Index donné par l'utilisateur - $v0
# Input: Numéro du joeur (1 ou 2) - $a0
# Output: numéro du carré ($v0)
# Détermine la position exacte où placer le jeton et met à jour l'état du jeu en mémoire, puis renvoit la position de jeton
UpdateRecord:

##########################################
## Fonction UpdateRecord
##########################################
### registres:

### $s0 : adresse du début du tableau trackJetons
### $s1 : couleur choisie par le joueur 

### $t0 : index donné par l'utilisateur -1
### $t1 : offset du plus bas carré de la colonne choisie
### $t2 : adresse du plus bas carré de la colonne choisie du tableau trackJetons
### $t3 : contenu de la case courante du tableau trackJetons
### $t4 : compteur (+28 à chaque tour de boucle pour atteindre la case au-dessus)
### $t5 : offset du plus haut carré de la colonne choisie 
### $t8 : numéro de la colonne choisie par le joueur
##########################################

		la   $s0 trackJetons		# s0 : adresse du début du tableau trackJetons
		move $s1 $a0			# s1 : numéro de la couleur choisie par l'utilisateur 
		move $t8 $v0 			# t8: index donnée par le joueur (numéro de la colonne)	
		addi $t0 $v0 -1			# t0 : numéro de la colonne -1
		
		###  Vérifie si la colonne choisie par le joueur est inclue entre 1 et 7 compris  ###
		bgt  $v0 7 incorrectInput
		blt  $v0 1 incorrectInput
	
		###  Calculs pour trouver l'offset du plus haut carré de la colonne choisie  ###
		mulu $t1 $t0 4			# t1 : (numéro de la colonne -1) * 4 = offset du plus bas carré de la colonne choisie
		addu $t2 $s0 $t1		# t2 : adresse du début du tableau + t1 = adresse du plus bas carré de la colonne choisie dans le tableau trackJetons 
		addu $t5 $t1 140		# t5 : offset du plus haut carré de la colonne choisie
		# 140 = offset du plus haut carré de la colonne 1 (= carré 35 * 4)
				
		move $t4 $t1			# t4 : compteur 
	
		###  Cherche le premier carré vide dans la colonne selectionné par le joueur  ###
    videCheck:  bgt  $t4 $t5 colonnePleine	# si aucun carré n'est vide, aller à colonnePleine
		lw   $t3 0($t2)			# t3 : contient la valeur de la case courante du tableau trackJetons
		beqz $t3 caseVide		# si t3 == 0 (vide), aller à caseVide
		addu $t4 $t4 28			# t4 : incrémenter le compteur de boucle (28 =  7 (nombre de colonnes) * 4 (octets pour int))
		addu $t2 $t2 28			# t2 : va au carré au-dessus
		
		j videCheck
						
incorrectInput: ###  Redemande au joueur d'entrer un nombre compris entre 1 et 7 ###
		la   $a0 displayInstructions
                li   $v0 4 
                syscall
                
                lw   $t6 couleurJoueur1			
		beq  $s1 $t6 playerOne		# si c'est au tour du joueur 1, aller à playerOne 
		j playerTwo
                																
colonnePleine:  ###  Si la colonne est pleine, on demande au joueur X de donner une autre colonne  ###
		la   $a0 displayFull	
		li   $v0 4
		syscall	
		
		lw   $t6 couleurJoueur1			
		beq  $s1 $t6 playerOne		# si c'est au tour du joueur 1, aller à playerOne 
		j playerTwo
			
caseVide: 	###  Ecris dans le tableau trackJetons que la case choisie est maintenant occupée et renvoie dans $v0 le numéro du carré  ###
		divu $t5 $t4 4			# t5 : numéro du carré où la case est vide  (=offset de la case vide ($t4) / 4) 
	  	move $v0 $t5 			# v0 : numéro du carré où la case est vide dans la colonne choisie
	  	sw   $s1 0($t2)			# Ecris dans la case vide de tableau trackJetons la couleur du joueur pour dire que ce carré est occupée par le joueur X
		move $a0 $s1			# a0 : numéro de la couleur du joueur
		
		jr   $ra
		
################################ Fin UpdateRecord ################################ 
	
			
################################ Début WinCheck ################################  
# Procedure: WinCheck
# Input: $a0 - Player Number
# Input: $v0 - Last location offset chip was placed
# Détermine si le dernier jeton joué a permis de gagner 
WinCheck:    

##########################################
## Fonction WinCheck
##########################################
### registres:

### $s0 : adresse du début du tableau trackJetons

### $a2 : adresse du carré choisi par le joueur dans le tableau trackJetons

### $t0 : numéro du carré choisi par le joueur
### $t1 : $a2
### $t2 : compteur
### $t3 : adresse courante du tableau trackJetons
### $t8 : numéro de la colonne choisie par le joueur
##########################################	   	
# prologue WinCheck
			addi $sp $sp -12
			sw $s0 0($sp)
			sw $a0 4($sp)	
			sw $v0 8($sp)

# corps WinCheck
			la   $s0 trackJetons			# s0 : adresse du début du tableau trackJetons
			move $t0 $v0 			 	# t0 : numéro du carré 
			mulu $a2 $t0 4				# a2 : offset du carré (= numéro du carré * 4)
			addu $a2 $a2 $s0			# a2 : adresse du carré choisi par le joueur dans le tableau trackJetons
		
			#  Vous devez vérifier sur :
     			# 1. la ligne horizontale
     			
			blt $t8 5 horizontal3Devant	# si colonne < 5, aller à horizontal3Devant1Derriere
			j horizontal3Derriere
		
			###  Vérifie si 3 jetons devant pour horizontale  ###
horizontal3Devant: 
			move $t1 $a2				# t1 : adresse de la case choisie par l'utilisateur
			li   $t2 0 				# t2 : compteur
		
TroisDevantLoopH: 	bgt  $t2 3 endWinCheckWin		# si les 3 cases devant sont égales à la couleur du joueur, il a gagné
			lw   $t3 0($t1)				# t3 : adresse de la case courante
			bne  $t3 $a0 horizontal3Derriere	# si case courante != joueur, vérifier la prochaine condition
			addu $t2 $t2 1				# incrémenter le compteur
			addu $t1 $t1 4				# accéder à l'adresse de la case suivante 
			j TroisDevantLoopH
			
			###  Vérifie si 3 jetons derrière pour horizontale  ###
horizontal3Derriere:
			blt  $t8 4 horizontal2Devant		# si colonne < 4, vérifier prochaine condition
			move $t1 $a2
			li   $t2 0
			
TroisDerriereLoopH:     bgt  $t2 3 endWinCheckWin
			lw   $t3 0($t1)
			bne  $t3 $a0 horizontal2Devant
			addu $t2 $t2 1
			addu $t1 $t1 -4				# accède à l'adresse de la case d'avant 
			j TroisDerriereLoopH
	
			###  Vérifie si 2 jetons devant 1 derrière pour horizontale  ###
horizontal2Devant:	beq  $t8 1 horizontal1Devant		# si colonne == 1, vérifier prochaine condition
			bge  $t8 6 horizontal1Devant		# si colonne >= 6, vérifier prochaine condition
			
			# vérifie le pion de derrière
			move $t1 $a2				# t1 : adresse du carré choisi par le joueur
			addu $t1 $t1 -4				# t1 : adresse du carré précédent
			lw   $t3 0($t1)				
			bne  $t3 $a0 horizontal1Devant		# si le carré précédent != joueur, vérifier la prochaine condition
			
			# vérifie les pions de devant
			addu $t1 $t1 8
			lw   $t3 0($t1)
			bne  $t3 $a0 horizontal1Devant
			
			addu $t1 $t1 4
			lw   $t3 0($t1)
			bne  $t3 $a0 horizontal1Devant
			j endWinCheckWin
			
 			###  Vérifie si 1 jeton devant 2 derrières pour horizontale  ###
horizontal1Devant:	blt  $t8 3 verticalCheck				# si colonne < 3, vérifier prochaine condition
			bgt  $t8 6 verticalCheck				# si colonne > 6, vérifier prochaine condition
			
			# vérifie le pion de devant
			move $t1 $a2
			addu $t1 $t1 4
			lw   $t3 0($t1)
			bne  $t3 $a0 verticalCheck
			
			# vérifie les pions de derrière
			addu $t1 $t1 -8
			lw   $t3 0($t1)
			bne  $t3 $a0 verticalCheck
			
			addu $t1 $t1 -4
			lw   $t3 0($t1)
			bne  $t3 $a0 verticalCheck
			j endWinCheckWin
			
	
     			# 2. la ligne verticale
verticalCheck:
			move $t1 $a2	
			li   $t2 0				
			blt  $t0 21 diagonaleAvantCheck		# si la case choisie par l'utilisateur < case 21, vérifier la prochaine condition
			 
loopVertical:		bgt  $t2 3 endWinCheckWin		# si les 3 carrés avant ont la même valeur que le joueur, il a gagné
			lw   $t3 0($t1)
			bne  $t3 $a0 diagonaleAvantCheck	# si pas 3 dernières cases pareille, vérifier la suite 
			addu $t2 $t2 1
			addu $t1 $t1 -28			# -28 = accède à l'adresse au carré en-dessous car 7 (nombre de colonne) *4 (octets)
			j loopVertical 
		
		
     			# 3. la diagonale avant
     			
diagonaleAvantCheck:	bge  $t8 5 diago3Derriere		# si la colonne choisie est >= 5, vérifier la prochaine condition
		        bge  $t0 21 diago3Derriere		# si le carré est >= 21, vérifier la prochaine condition
			
			###  Vérifie si 3 jetons devant pour diagonale avant  ###	
diago3Devant: 		move $t1 $a2
		      	li   $t2 0
		      
TroisDevantLoopD: 	bgt  $t2 3 endWinCheckWin 			
			lw   $t3 0($t1)
			bne  $t3 $a0 diago3Derriere
		  	addu $t2 $t2 1
			addu $t1 $t1 32				# 32 = accède au carré  au-dessus + 1 carré (28 octets + 4 octets)
			j TroisDevantLoopD
			  
			  
			###  Vérifie si 3 jetons derrière pour diagonale avant  ###
diago3Derriere: 	blt  $t8 4 diago2Devant			# si la colonne choisie < 4, vérifier la prochaine condition
			blt  $t0 24 diago2Devant		# si le carré est < 24, vérifier la prochaine condition
			move $t1 $a2
			li   $t2 0
			
TroisDerriereLoopD: 	bgt  $t2 3 endWinCheckWin
			lw   $t3 0($t1) 
			bne  $t3 $a0 diago2Devant
			addu $t2 $t2 1
			addu $t1 $t1 -32			# -32 = accède au carré en-dessous - 1 carré
			j TroisDerriereLoopD
			  
			    
			###  Vérifie si 2 jetons devant 1 jeton derrière pour diagonale avant  ###  
diago2Devant:    	beq  $t8 1 diago1Devant			# si la colonne == 1, aller à la condition suivante
			bgt  $t8 5 diago1Devant			# si la colonne > 5, aller à la condition suivante
			blt  $t0 8 diago1Devant			# si carré < 8, aller à la condition suivante
			bgt  $t0 25 diago1Devant		# si carré > 25, aller à la condition suivante
			move $t1 $a2
			 
	     		addu $t1 $t1 -32			# -32 = accède au carré en-dessous - 1 carré
	     		lw   $t3 0($t1)
	     		bne  $t3 $a0 diago1Devant
	     		
	     		addu $t1 $t1 64				# 64 = accède au carré en diagonale devant celui choisi par le joueur
	     		lw   $t3 0($t1)
	     		bne  $t3 $a0 diago1Devant
	     		
	     		addu $t1 $t1 32				# 32 = accède au 2ème carré devant celui choisi par le joueur
	     		lw   $t3 0($t1)
	     		bne  $t3 $a0 diago1Devant
	     		j endWinCheckWin
	     		
	     		
	     		###  Vérifie si 1 jetons devant 2 jetons derrière pour diagonale avant  ###
diago1Devant:   	blt  $t8 3 diagonaleArriereCheck	# si la colonne choisie < 3, vérifier autres conditions
	                beq  $t8 7 diagonaleArriereCheck	# si la colonne choisie == 7, vérifier autres conditions
	                bgt  $t0 33 diagonaleArriereCheck	# si carré choisi > 33, vérifier autres conditions
	                blt  $t0 14 diagonaleArriereCheck	# si carré choisi < 14, vérifier autres conditions
	                move $t1 $a2
	                
	                addu $t1 $t1 32				# vérifie que le carré devant en diaggonale est de la meme couleur
	                lw   $t3 0($t1)
	                bne  $t3 $a0 diagonaleArriereCheck
	                
	                li   $t2 0
 UnDevantLoopD:         bgt  $t2 2 endWinCheckWin
 			addu $t1 $t1 -32			# vérifie que les autres carrés derrière sont aussi de la même couleur
	                lw   $t3 0($t1)
	                bne  $t3 $a0 diagonaleArriereCheck
	                addu $t2 $t2 1
	                j UnDevantLoopD
	                
	                	
		      	
     			# 4. la diagonale arrière   	
     	
diagonaleArriereCheck:  ble  $t8 3 diagoD3Derriere		# si la colonne choisie < 3, voir autres conditions
     			bge  $t0 21 diagoD3Derriere		# si le carré >= 21, voir autres conditions
     			
     			###  Vérifie si 3 jetons devant pour diagonale arrière  ###
diagoD3devant: 		move $t1 $a2				# t1 : adresse du carré dans le tableau trackJetons
		      	li   $t2 0				# compteur
		      		
		      		
TroisDevantLoopDD: 	bgt  $t2 3 endWinCheckWin 		# si compteur > 3, le joueur a gagné
			lw   $t3 0($t1)				# charge le contenu de la case courante du tableau trackJetons
			bne  $t3 $a0 diagoD3Derriere		# si la couleur != de celle du joueur, vérifier la prochaine condition
			addu $t2 $t2 1				# incrémente le compteur
			addu $t1 $t1 24				# accède à la case au-dessus en diagonale arrière (+28-4)
			j TroisDevantLoopDD
			  
			  
			###  Vérifie si 3 jetons derrière pour diagonale arrière  ###
diagoD3Derriere: 	bge  $t8 5 diagoD2Devant		# si colonne >= 5, voir conditions suivante		
			blt  $t0 21 diagoD2Devant		# si  carré < 21, voir condition suivante
			move $t1 $a2
			li   $t2 0		  
			  
TroisDerriereLoopDD: 	bgt  $t2 3 endWinCheckWin
			lw   $t3 0($t1) 
			bne  $t3 $a0 diagoD2Devant
			addu $t2 $t2 1
			addu $t1 $t1 -24			# une case en-dessous en diagonale arrière
			j TroisDerriereLoopDD		  
			  
			  
			###  Vérifie si 2 jetons devant et 1 jeton derrière pour diagonale arrière  ###
diagoD2Devant:   	beq  $t8 7 diagoD1Devant		# si colonne == 7, voir condition suivante
			ble  $t8 2 diagoD1Devant		# si colonne < 2, voir condition suivante
			blt  $t0 7 diagoD1Devant		# si carré < 7, voir conditions suivante
			bge  $t0 28 diagoD1Devant		# si carré >= 28, voir condition suivante
			move $t1 $a2	
			  
	     		addu $t1 $t1 -24			# vérifie le jeton de derrière
	     		lw   $t3 0($t1)
	     		bne  $t3 $a0 diagoD1Devant
	     		
	     		# vérifie les jetons de devant
	     		addu $t1 $t1 48
	     		lw   $t3 0($t1)
	     		bne  $t3 $a0 diagoD1Devant
	     		
	     		addu $t1 $t1 24
	     		lw   $t3 0($t1)
	     		bne  $t3 $a0 diagoD1Devant
	     		j endWinCheckWin
			  
			  
			###  Vérifie si 1 jeton devant et 2 jeton derrière pour diagonale arrière  ###
diagoD1Devant:  	beq  $t8 1 egaliteCheck			# si colonne == 1, voir condition suivante
	                bge  $t8 6 egaliteCheck			# si colonne >= 6, voir condition suivante
	                bge  $t0 35 egaliteCheck		# si carré >= 35, voir conditions suivantes
	                blt  $t0 14 egaliteCheck		# si carré < 14, voir conditions suivante
	                move $t1 $a2		  
			    	                
	                addu $t1 $t1 24				# vérifie le carré en diagonale devant
	                lw   $t3 0($t1)
	                bne  $t3 $a0 egaliteCheck
	                                
	          	# Vérifie les 2 jetons derrière en diagonale
	                li   $t2 0
UnDevantLoopDD:         bgt  $t2 2 endWinCheckWin
 			addu $t1 $t1 -24
	                lw   $t3 0($t1)
	                bne  $t3 $a0 egaliteCheck
	                addu $t2 $t2 1
	                j UnDevantLoopDD
	                      			     			            
     	
     			# 5. si tout le plateau est remplit (Egalité)
egaliteCheck:
     			move $t0 $s0				# t0 : adresse du début du tableau trackJetons	
     			li   $t1 0				# t1 : compteur 
     	
	loopEgalite:	bgt  $t1 41 endWinCheckTie		# si le cmpteur > nb de cases, aller à endWinCheckTie (il y a égalité)
        		lw   $t2 0($t0)				# t2 : contenu de la case courante
        		beqz $t2 endWinCheckContinue		# si on tombe sur une case == 0, aller à endWinCheckContinue (le jeu continue)
        		addu $t1 $t1 1				# t1 : incrémente le compteur 
        		addu $t0 $t0 4				# accède à la case suivante
        		j loopEgalite
        
     
# epilogue WinCheck
endWinCheckWin:
		lw   $s0 0($sp)
		lw   $a0 4($sp)		
		lw   $v0 8($sp)
		addi $sp $sp 12
		j PlayerWon					# le joueur a gagné, allé au label PlayerWon
		
endWinCheckTie: 
		lw   $s0 0($sp)
		lw   $a0 4($sp)		
		lw   $v0 8($sp)
		addi $sp $sp 12
		j GameTie					# il y a égalité, aller à GameTie

endWinCheckContinue:
		lw   $s0 0($sp)
		lw   $a0 4($sp)		
		lw   $v0 8($sp)
		addi $sp $sp 12
		jr $ra						# le jeu continue, revenir dans le main

################################  Fin WinCheck ################################  

# Procedure: GameTie
# Affiche l'égalité et arrête de jeu
GameTie:
		la $a0 displayTie  				# affiche aux joueurs qu'il y a égalité
		li $v0 4
		syscall 
		j NewGame			
	

# Procedure: PlayerWon
# Input: $a0 - Player Number
# Affiche le gagnant et arrête de jeu
PlayerWon:	
		###  Affiche le gagnant  ###
		lw  $t0 couleurJoueur1				# t0 : numéro de couleur du joueur 1
		bne $a0 $t0 joueur2Gagnant			# si numéro du joueur != joueur 1, aller à joueur2Gagnant
		la  $a0 displayP1Win
		li  $v0 4
		syscall
		j NewGame

joueur2Gagnant:
		la $a0 displayP2Win				# affiche que le joueur2 a gagné
		li $v0 4
		syscall	
		j NewGame


		###  Propose aux joueurs de refaire une partie  ###
NewGame: 	la $a0 nouvellePartie
	 	li $v0 4
	 	syscall
	 
	 	li $v0 5					# récupère la réponse des joueurs  
	 	syscall
	 
		bne $v0 1 End					# si les joueurs ne veulent pas refaire de partie, aller à End
	 	
	 	###  Initialise toutes les cases du tableau trackJetons à 0  ###
	 	la $t0 trackJetons
	 	li $t1 0					# compteur 
	 	
loopReinitialiseTableau:  					# initalise tout le tableau trackJetons à 0
		bgt $t1 41 Init					# si le compteur > numéro du plsu grand carré, va au label Init pour rafraîchir la page
                sw $zero 0($t0)					# écris 0 dans la case du tableau
                addu $t0 $t0 4					# va à l'adresse du carré suivant
                addu $t1 $t1 1					# incrémente le compteur
                j loopReinitialiseTableau
                          
		 
		###  Fin du programme  ###
End:	li $v0 10
        syscall 






