import UIKit

class ViewController: UIViewController {
    var currentGame: Game!
    var listOfWords = ["buccaneer", "swift", "glorious",
                       "incandescent", "bug", "program"]
    let incorrectMovesAllowed = 7
    var totalWins = 0 {
        didSet{
            enableLetterButtons(false)
            resultLabel.isHidden = false
            resultLabel.text = "Successfully"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.enableLetterButtons(true)
                self.newRound()
                self.resultLabel.isHidden = true
            }
        }
    }
    var totalLosses = 0 {
        didSet{
            enableLetterButtons(false)
            resultLabel.isHidden = false
            resultLabel.text = "You lose"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.enableLetterButtons(true)
                self.newRound()
                self.resultLabel.isHidden = true
            }
        }
    }
    
    // MARK: IBOutlet
    @IBOutlet var treeImageView: UIImageView!
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet var resultLabel: UILabel!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.isHidden = true
        newRound()
    }
    
    func newRound () {
        if !listOfWords.isEmpty{
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        }else{
            correctWordLabel.isHidden = true
            enableLetterButtons(false)
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        }else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
            updateUI()
        }else{
            updateUI()
        }
    }
    
    // MARK: @IBAction
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.configuration!.title!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    

}

