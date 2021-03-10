//
//  ViewController.swift
//  Concentration
//
//  Created by Alon Reik on 09/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
        
    @IBAction func touchCard(_ sender: UIButton) {
        game.flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber) // Controller is updating the model
            updateViewFromModel() // Controller is updating the view
        } else {
            print("chosen card was not in cardButtons") 
        }
    }
    
    // Resets the score(flipCount) and flips back all cards.
    @IBAction func startNewGame(_ sender: UIButton) {
        emojiChoices = themes.randomElement()!.value // choose a new random theme
        emoji.removeAll() // clear previous mapping between cards and emojis
        game.resetGame()
        updateViewFromModel()
    }

    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
        for index in cardButtons.indices { // making sure every card is viewed correctly
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    // A dictionary mapping themes (Strings) to an array of emoji choices (array of Strings)
    let themes = ["Halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
                  "Animals": ["🙀", "🦇", "🐱", "🐥", "🐦", "🦉", "🐺", "🦄", "🐷" ],
                  "Sports": ["⚽️", "🥎", "⚾️", "🥋", "🎽", "🥏", "🤿","🏒", "🏉" ],
                  "Food": ["🍭", "🎃", "🍎", "🍬", "🍌", "🥝" ,"🍞", "🥕", "🥯"],
                  "Faces": ["😱", "😀", "😋", "🥸", "😜", "🥳", "😛", "🤩", "😏"],
                  "Flags": ["🏳️‍🌈", "🏳️", "🏴","🏴‍☠️","🏁","🇧🇿","🇫🇯","🇹🇭","🇮🇳"]
                ]
    
    lazy var emojiChoices = themes.randomElement()!.value

    // A dictionary mapping an identifier of a card (Int) to an emoji (String)
    var emoji = [Int: String]()
    
    // Assigns the given card with an emoji from the emojiChoices array.
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}
