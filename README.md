# Word-Scramble
100 Days of Swift (Project 5) A word game that deals with anagrams. This project helped me understand the usage of capture lists, how to load text from files, 
how to ask for user input in UIAlertController, UITextChecker to find invalid words, inserting table view rows with animation, ec. When the app is first loaded, 
a table view is revealed with a word as its title that has been randomly generated from a list of thousands of words. The screen contains a right bar button item 
that when clicked on displays an alert message that prompts the user to enter an anagram of the word, and adds it to the table view. If the world lacks originality 
(has already been added to the table view), isn't an anagram, or simply does not exist, an error message will appear that lets the user know precisely what
their mistake was. The screen also contains a left bar button item that allows the user to reset the game (completely erase the table view).

I completed the following (part 3) challenges:
-Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into isReal()
that returns false if the word length is under three letters. For the second part, just compare the start word against their input word and return false if they 
are the same.
-Refactor all the else statements we just added so that they call a new method called showErrorMessage(). This should accept an error message and a title, and do 
all the UIAlertController work from there.
-Add a left bar button item that calls startGame(), so users can restart with a new word whenever they want to.

![ezgif-4-88e4d7f044d9](https://user-images.githubusercontent.com/42749527/99895548-9eebdf80-2c56-11eb-84b4-c1af4328e628.gif)
