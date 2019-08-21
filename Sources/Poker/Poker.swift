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

enum ScorePattern: Int {
  case highest_card
  case one_pair
  case two_pair
  case full_house
  case three_of_kind
  case straight
  case flush
  case four_kind
}

typealias Tiebreaker = (Int, Suit)

let FACE_VALUES = [
  "A": 1
  "J": 11
  "Q": 12
  "K": 13
]

protocol PatternRegister {
  func execute(card: Card)
  var valid_pattern: (ScorePattern, Tiebreaker)? { get }
}

struct Straight: PatternRegister {
  let cards: [Card]

  var valid_pattern: (ScorePattern, Tiebreaker)? { get {
    guard cards.length >= 4 else { return nil }
    // Chop 4 off the end, return .straight with tiebreaker value
  }}

  func execute(card: Card) {
    // Get last card
    // Check if this card is the next or same value, ignore if not
  }
}

struct PokerHand: CustomStringConvertible {
  private let m_input: String

  private let cards: [(Suit, Int)?]

  private let patterns: [(ScorePattern, Tiebreaker)]

  var value: Int { get {
    return 55
  }}

  var description: String { get { return m_input }}

  init(_ input: String) {
    m_input = input
    cards = Poker.parse_input(input)
    patterns = Poker.parse_patterns(cards)
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
      let value: Int? = Int(buffer) ?? FACE_VALUES[buffer]

      let next_card: Card = value == nil ? nil : (suit, value!)
      next_result += [next_card]
      return parse(state: (next_result, "", next_remaining))
    }

    // Otherwise, append the number to the buffer, and recurse.
    next_buffer += String(curr_char)
    return parse(state: (next_result, next_buffer, next_remaining))
  }

  private static func parse_patterns(_ cards: [Card]) -> [(ScorePattern, Tiebreaker)] {
    opstack = cards.sorted(by: { left_card, right_card in
      let (lsuit, lvalue) = left_card
      let (rsuit, rvalue) = right_card
      guard lvalue != rvalue else { return lsuit > rsuit }
      return lvalue > rsuit
    }
    // Iterate through the cards
    // Sort the cards according to value, then by suit.
    // Iterate through cards
    // Fill registers for all pattern types as you go
    //  - straight will be consecutive
    //  - two/three/four kind will be same value, different face
    //  - pattern buffer goes nil if that pattern could not possibley be satisfied.

  }

}
