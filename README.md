# MIPS Assembly Project - Connect 4 Game (Jeu Puissance 4)

## Getting Started

### Prerequisites

- The ``Mars4_5.jar`` simulator available here http://courses.missouristate.edu/kenvollmar/mars/


### Installation

- To launch the MARS emulator, type this command in the terminal :

```
java -jar Mars4_5.jar
```

- Load the file ``Puissance_4.asm``, assemble it then go the **Tools** tab to launch **Bitmap Display**.

- In the **Bitmap Display** window, select :
	+ **8** for **Unit Width in Pixels** and **Unit Height in Pixels**
	+ **512** for **Display Width in Pixels** and **Display Height in Pixels** 
	+ **0x10040000(heap)** for **Base adress for display**

- Ultimately, click on the widget **Connect to MIPS** and launch the program execution.

![readmepuissance4_1](https://user-images.githubusercontent.com/95167842/170264451-ef9fc364-4e04-4d0a-8d78-ce0e13482d51.png)

## Connect 4 Usage

### Game Principle

- Connect 4 is a two-player game. To win you have to be the first one to place 4 tokens of your color in a line either :
	+ **horizontally** 
	+ **vertically** 
	+ **diagonally** _(front or rear)_

### Program Flow

- When you launch the program, the console asks each player to type the color of their token :
	+ **1** : _Red_ 
	+ **2** : _Yellow_
	+ **3** : _Purple_
	+ **4** : _Green_
	+ **5** : _Pink_
	+ **6** : _Blue_
	
**NB** : You can't pick the same color as your opponent.

- Then in turn, each player types the number of the column _(bewteen 1 and 7 included)_ where he wishes to place his token.

- Once the token is placed, the program checks if: 
	+ **the player won** &#8594; the last token placed by the player managed to align 4 tokens in a row
	+ **the board is completely filled** &#8594; there is equality
	+ **the game continues** &#8594; the token placed didn't allow the player to win


### Endgame

- At the end of the game, the winner is displayed on the console and the program suggests to start a new game.

## Authors

* **Justine Andreolli**  _alias_ [@jandreolli](https://github.com/jandreolli)
* **Ambre Lis**  _alias_ [@ambrelis](https://github.com/ambrelis)






