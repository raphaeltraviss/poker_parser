typealias Card = (Suit, Int)?
typealias ParserState = ([Card], String, String)
  
enum Suit: Int {
  case hearts, diamonds, spades, clubs
  
  static func from(_ char: Character) -> Suit? {
    switch char {
    case "♡": return .hearts
    case "♢": return .diamonds
    case "♧": return .clubs
    case "♤": return .spades
    default: return nil
    }
  }
  
  static func all() -> [Character] {
    return ["♡" ,"♢", "♧", "♤"]
  }
}

// could contain nested patterns (tie one pair, then to highest card)
// each pattern has a weight associated with it, and a value (based on
// the hand values) used to break ties.
// break tide by suit
// Is a "straight flush" both a straight and a flush?
// Each pattern has a highest Suit and highest value associated with
// it, for breaking ties.

// (pattern score, max number score, max suit score)
typealias PatternScore = (Int, Int, Int)

enum ScorePatterns {
  case highest_card(Suit, Int)
  case one_pair(Suit, Int)
  case two_pair(Suit, Int)
  case full_house(Suit, Int)
  case three_of_kind(Suit, Int)
  case straight(Suit, Int)
  case flush(Suit, Int)
  case four_kind(Suit, Int)
  
  var weight: Int {
    switch self {
    case .highest_card: return 1
    case .one_pair: return 2
    case .two_pair: return 3
    case .full_house: return 4
    case .three_of_kind: return 5
    case .straight: return 6
    case .flush: return 7
    case .four_kind: return 8
    }
  }
  
  func score() -> PatternScore {
    switch self {
    case .highest_card(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .one_pair(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .two_pair(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .full_house(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .three_of_kind(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .straight(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .flush(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    case .four_kind(let max_suit, let max_value): return (self.weight, max_value, max_suit.rawValue)
    }
  }
}


  
struct PokerHand: CustomStringConvertible {
  private let m_input: String
  
  private let cards: [(Suit, Int)?]
  
  var value: Int { get {
    return 55
  }}
  
  var description: String { get { return m_input }}
  
  init(_ input: String) {
    m_input = input
    cards = Poker.parse_input(input)
  }
}

class Poker {
  static func bestHand(_ inputs: [String]) -> String {
    let hands = inputs.map { PokerHand($0) }
    let best = hands.max { a,b in a.value < b.value }
    return best?.description ?? ""
  }
  
  static func parse_input(_ input: String) -> [Card] {
    typealias ParserState = ([Card], String, String)
    let base_state: ParserState = ([], "", input)
    let parser_result = parse(state: base_state)
    return parser_result.0
  }
  
  private static func parse(state: ParserState) -> ParserState {
    let (result, buffer, remaining) = state
    var (next_result, next_buffer, next_remaining) = state
    
    // If we are out of input, return the result
    guard !next_remaining.isEmpty else {
      return (next_result, next_buffer, "")
    }
    
    let curr_char = next_remaining.removeFirst()
    
    // Ignore spaces.
    if curr_char == " " {
      return parse(state: (next_result, next_buffer, next_remaining))
    }
    
    // If we hit suit character, append a new card, empty the buffer, and recurse.
    if Suit.all().contains(curr_char) {
      let suit = Suit.from(curr_char)!
      let value: Int? = Int(buffer) ?? face_value(buffer)

      let next_card: Card = value == nil ? nil : (suit, value!)
      next_result += [next_card]
      return parse(state: (next_result, "", next_remaining))
    }
    
    // Otherwise, append the number to the buffer, and recurse.
    next_buffer += String(curr_char)
    return parse(state: (next_result, next_buffer, next_remaining))
  }
  
  // Jokers are represented by nil
  private static func face_value(_ face: String) -> Int? {
    switch face {
    case "A": return 1
    case "J": return 11
    case "Q": return 12
    case "K": return 13
    default: return nil
    }
  }
  
  // Jokers are represented by nil
  private static func face_value(_ value: Int) -> String? {
    switch value {
    case 1: return "A"
    case 11: return "J"
    case 12: return "Q"
    case 13: return "K"
    default: return nil
    }
  }
}
