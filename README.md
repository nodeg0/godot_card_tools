# godot_card_tools
Framework for making card-games in Godot
currently in development.  A more robust readme that explains the architecture will follow.

Essentially, you can delete the main script/node and build off of the remaining assets. Main contains the demo.

Card is the card itself.  All the info for the cards are generated with a custom resource. The stats/etc used are in Cardtypes.gd.  Create new cards by adding a New Resource in the Resources/Cards folder. It currently has an exported variable to turn off "Drag and Drop" for a click to select playstyle.  The click and select playstyle has not been implemented yet, so leave it on.

Library contains methods for making a card array based on card resources in a directory.  It currently allows you to grab cards of a specific "rarity" so that you can make, perhaps, booster packs. The return has been commented out for testing and has currently not been tested since there is only one small card pool at the moment.

Table controls all the player cards in play as well as all interactions.   The leftpoint/rightpoint position2d nodes dictate the left and right of where cards appear. The top of the cards will be at the same level as leftpoint. 

Deck will eventually allow loading and saving of decks. Currently the only function that works is the default_deck function which contains 10 cards for the demo.

I believe there is already enough for a basic framework.  Basically, I need to refactor for readablitity, functionality and usablility. I'm sure that you can figure something out if you're brave enough to play with this before it's finished.

commenting in the code is very limited, and I still have some refactoring and cleaning up to do.

Feel free to let me know if you use this for anything.  I'd love to check it out.

Just added: Draw Cards, tweening, improved demo
