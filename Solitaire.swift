import UIKit

class Card {
    let rank: String
    let suit: String
    var isFaceUp: Bool
    
    init(rank: String, suit: String, isFaceUp: Bool = false) {
        self.rank = rank
        self.suit = suit
        self.isFaceUp = isFaceUp
    }
}

class SolitaireViewController: UIViewController {
    
    var deck: [Card] = []
    var tableau: [[Card]] = []
    var foundation: [[Card]] = []
    
    var cardViews: [UIView] = []
    var selectedCardView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setupUI()
    }
    
    func setupGame() {
        deck = createDeck()
        deck.shuffle()
        tableau = createTableau()
        foundation = createFoundation()
    }
    
    func createDeck() -> [Card] {
        var deck: [Card] = []
        
        let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        let suits = ["♠️", "♥️", "♦️", "♣️"]
        
        for suit in suits {
            for rank in ranks {
                deck.append(Card(rank: rank, suit: suit))
            }
        }
        
        return deck
    }
    
    func createTableau() -> [[Card]] {
        var tableau: [[Card]] = []
        
        for i in 0..<7 {
            var column: [Card] = []
            
            for j in 0...i {
                let card = deck.removeFirst()
                card.isFaceUp = j == i
                column.append(card)
            }
            
            tableau.append(column)
        }
        
        return tableau
    }
    
    func createFoundation() -> [[Card]] {
        var foundation: [[Card]] = []
        
        for _ in 0..<4 {
            foundation.append([])
        }
        
        return foundation
    }
    
    func setupUI() {
        // Setup tableau card views
        for (columnIndex, column) in tableau.enumerated() {
            for (cardIndex, card) in column.enumerated() {
                let cardView = createCardView(card)
                cardView.frame.origin = CGPoint(x: 20 + (80 * columnIndex), y: 100 + (30 * cardIndex))
                view.addSubview(cardView)
                cardViews.append(cardView)
                
                // Add tap gesture recognizer to card view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
                cardView.addGestureRecognizer(tapGesture)
                cardView.isUserInteractionEnabled = true
            }
        }
        
        // Setup foundation card views
        // ...
    }
    
    @objc func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedCardView = sender.view else { return }
        
        if let selectedCard = getCard(from: selectedCardView) {
            if selectedCard.isFaceUp {
                // Card is already face up, perform additional logic (e.g., move card, check for valid move)
            } else {
                // Flip the card face up
                selectedCard.isFaceUp = true
                updateCardView(selectedCardView, with: selectedCard)
            }
        }
    }
    
    func getCard(from cardView: UIView) -> Card? {
        guard let index = cardViews.firstIndex(of: cardView) else { return nil }
        
        let column = index / 7
        let cardIndex = index % 7
        
        return tableau[column][cardIndex]
    }
    
    func createCardView(_ card: Card) -> UIView {
        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 100))
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.black.cgColor
        
        let rankLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 60, height: 20))
        rankLabel.text = card.rank
        rankLabel.textAlignment = .center
        cardView.addSubview(rankLabel)
        
        let suitLabel = UILabel(frame: CGRect(x: 5, y: 30, width: 60, height: 20))
        suitLabel.text = card.suit
        suitLabel.textAlignment = .center
        cardView.addSubview(suitLabel)
        
        cardView.isHidden = !card.isFaceUp
        
        return cardView
    }
    
    func updateCardView(_ cardView: UIView, with card: Card) {
        for subview in cardView.subviews {
            if let rankLabel = subview as? UILabel {
                rankLabel.text = card.rank
            } else if let suitLabel = subview as? UILabel {
                suitLabel.text = card.suit
            }
        }
        
        cardView.isHidden = !card.isFaceUp
    }
}

// Entry point
let viewController = SolitaireViewController()
viewController.view.backgroundColor = .green
viewController.view.frame = CGRect(x: 0, y: 0, width: 500, height: 700)
viewController.viewDidLoad()
PlaygroundPage.current.liveView = viewController.view
