//
//  ViewController.swift
//  Concentration
//
//  Created by Alon Reik on 09/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateScoreForTime), userInfo: nil, repeats: true)
        startNewGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
    }
    
    @objc func updateScoreForTime() {
        game.score -= 1
    }
    
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
    @IBAction func newGamePressed(_ sender: UIButton) {
        startNewGame()
    }
    
    // Resets all Model and View properties
    func startNewGame() {
        // choose a new random theme (default theme is Halloween)
        emojiChoices = themesDict.randomElement() ?? (key: "Halloween", value:(["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"], #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        
        background.backgroundColor = emojiChoices.value.2
        emoji.removeAll() // clear previous mapping between cards and emojis
        game.resetGame()
        
        // reset timer
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateScoreForTime), userInfo: nil, repeats: true)
        
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
                // Alon Reik: I know that this is bad practice but the lecturer wrote this code
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : themesDict[emojiChoices.key]!.1
            }
        }
    }
    
    /* A dictionary mapping themes (Strings) to tuples of the form (array, color1, color2) where
     "array" is an array of emoji choices, "color1" is a color literal for the background (bg) of the cards,
     and "color2" is a color literal for the overall bg.
    */
    let themesDict = ["Halloween": (["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"], #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                      "Animals": (["🙀", "🦇", "🐱", "🐥", "🐦", "🦉", "🐺", "🦄", "🐷" ], #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
                      "Sports": (["⚽️", "🥎", "⚾️", "🥋", "🎽", "🥏", "🤿","🏒", "🏉" ], #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
                      "Food": (["🍭", "🎃", "🍎", "🍬", "🍌", "🥝" ,"🍞", "🥕", "🥯"], #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
                      "Faces": (["😱", "😀", "😋", "🥸", "😜", "🥳", "😛", "🤩", "😏"], #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
                      "Flags": (["🏳️‍🌈", "🏳️", "🏴","🏴‍☠️","🏁","🇧🇿","🇫🇯","🇹🇭","🇮🇳"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
    ]
    
    // The theme of the game (default theme is halloween).
    lazy var emojiChoices = themesDict.randomElement() ??
        (key: "Halloween", value:(["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"], #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))

    // A dictionary mapping an identifier of a card (Int) to an emoji (String)
    var emoji = [Int: String]()
    
    // Assigns the given card with an emoji from the emojiChoices array.
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.value.0.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.value.0.count)))
            emoji[card.identifier] = emojiChoices.value.0.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}


class GameTheme {

    static let emojies = [["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
                        ["🙀", "🦇", "🐱", "🐥", "🐦", "🦉", "🐺", "🦄", "🐷" ],
                        ["⚽️", "🥎", "⚾️", "🥋", "🎽", "🥏", "🤿","🏒", "🏉"],
                        ["🍭", "🎃", "🍎", "🍬", "🍌", "🥝" ,"🍞", "🥕", "🥯"],
                        ["😱", "😀", "😋", "🥸", "😜", "🥳", "😛", "🤩", "😏"],
                        ["🏳️‍🌈", "🏳️", "🏴","🏴‍☠️","🏁","🇧🇿","🇫🇯","🇹🇭","🇮🇳"]
                        ]
    
    static let cardColors = [#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    
    static let bgColors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]
    
    let themeIndex: Int
    let emojis: [String]
    let cardsColor: UIColor
    let bgColor: UIColor
    
    init(){
        self.themeIndex = Int.random(in: 0..<GameTheme.emojies.count)
        self.emojis = GameTheme.emojies[themeIndex]
        self.cardsColor = GameTheme.cardColors[themeIndex]
        self.bgColor = GameTheme.bgColors[themeIndex]
    }
}
