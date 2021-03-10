//
//  ViewController.swift
//  Concentration
//
//  Created by Alon Reik on 09/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBOutlet var background: UIView!
    
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
        emojiChoices = themesEmojies.randomElement()! // choose a new random theme
        background.backgroundColor = themeColors[emojiChoices.key]!.1
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
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : themeColors[emojiChoices.key]!.0
            }
        }
    }
    
    // A dictionary mapping themes (Strings) to an array of emoji choices (array of Strings)
    let themesEmojies = ["Halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
                  "Animals": ["🙀", "🦇", "🐱", "🐥", "🐦", "🦉", "🐺", "🦄", "🐷" ],
                  "Sports": ["⚽️", "🥎", "⚾️", "🥋", "🎽", "🥏", "🤿","🏒", "🏉" ],
                  "Food": ["🍭", "🎃", "🍎", "🍬", "🍌", "🥝" ,"🍞", "🥕", "🥯"],
                  "Faces": ["😱", "😀", "😋", "🥸", "😜", "🥳", "😛", "🤩", "😏"],
                  "Flags": ["🏳️‍🌈", "🏳️", "🏴","🏴‍☠️","🏁","🇧🇿","🇫🇯","🇹🇭","🇮🇳"]
                ]
    
    // A dictionary mapping themes (Strings) to tuples of color literals, where the first
    // color is for the background (bg) of the cards, and the second is for the overall bg.
    let themeColors = ["Halloween": (#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                       "Animals": (#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
                       "Sports": (#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
                       "Food": (#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                       "Faces": (#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
                       "Flags": (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
                     ]
    
    lazy var emojiChoices = themesEmojies.randomElement()!

    // A dictionary mapping an identifier of a card (Int) to an emoji (String)
    var emoji = [Int: String]()
    
    // Assigns the given card with an emoji from the emojiChoices array.
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.value.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.value.count)))
            emoji[card.identifier] = emojiChoices.value.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}
