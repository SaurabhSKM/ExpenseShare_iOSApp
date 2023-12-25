import Foundation

enum Currency: String, CaseIterable {
    
    case usd, inr, euro, gbp, jpy, aud, cad, cny

    var symbol: String {
        switch self {
        case .usd: return "$"
        case .inr: return "₹"
        case .euro: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .aud: return "A$"
        case .cad: return "C$"
        case .cny: return "¥"
        }
    }
}

extension Currency: Identifiable {
    var id: String { rawValue }
}
