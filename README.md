# COM SCI M152A Final Project: Wordle Game using Verilog Nexys3 and VGA

## Design

1. The user presses “down” to start the game; initially all five blocks are empty, and the first block is colored red as the current cell that the user has chosen;
2. The user presses “left” or “right” to change the cell being selected; when a cell is selected, it turns red; and when it is unselected, it goes back to gray immediately;
3. The user presses “up” to submit the letter as input to the currently selected cell; letter is encoded using the five switches; color yellow means right letter but wrong position, color green means right letter and right position, and no change in color means wrong letter;
4. If all five letters are correct (green), display “WIN” on the screen; the user can press “down” to go back to step 1; If the game isn’t over yet, the user presses “down” again to go back to step 2;
