import Foundation
import SwiftUI
struct Utils {
    
    static let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    static var selectedCurrency: Currency = .inr

    static var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = selectedCurrency.symbol
        return formatter
    }
}

struct AmountTextField: View {
    @Binding var amount: Double
    var selectedCurrency: Currency

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = selectedCurrency.symbol
        return formatter
    }

    var body: some View {
        TextField("Amount", value: $amount, formatter: numberFormatter)
            .keyboardType(.numbersAndPunctuation)
    }
}
