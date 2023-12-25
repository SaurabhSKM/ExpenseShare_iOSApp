import Foundation
import CoreData

extension ExpenseLog {
    
    var categoryEnum: Category {
        Category(rawValue: category ?? "") ?? .other
    }
    
    var dateText: String {
        Utils.dateFormatter.localizedString(for: date ?? Date(), relativeTo: Date())
    }
    
    var nameText: String {
        name ?? ""
    }
    var currencyText: String {
           currency ?? ""
       }
       
       var whopaidText: String {
           whopaid ?? ""
       }
    
    var amountText: String {
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.currencySymbol = Currency(rawValue: currency ?? "")?.symbol ?? ""
          return formatter.string(from: NSNumber(value: amount?.doubleValue ?? 0)) ?? ""
      }
    
    
    static func fetchAllCategoriesTotalAmountSum(context: NSManagedObjectContext, completion: @escaping ([(sum: Double, category: Category)]) -> ()) {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        request.returnsObjectsAsFaults = false

        request.propertiesToFetch = ["amount", "category", "currency"]
        request.resultType = .dictionaryResultType

        context.perform {
            do {
                let results = try request.execute()
                print(results)

                var categorySums: [Category: Double] = [:]

                for case let resultDict as [String: Any] in results {
                    guard
                        let amount = resultDict["amount"] as? Double,
                        let categoryKey = resultDict["category"] as? String,
                        var category = Category(rawValue: categoryKey) else {
                            continue
                    }

                    // Convert currency to INR if not already
                    if let currency = resultDict["currency"] as? String, currency.lowercased() != "inr" {
                        let exchangeRate = convertToINR(amount: amount, fromCurrency: currency.lowercased())
                        categorySums[category] = (categorySums[category] ?? 0) + (amount * exchangeRate)
                    } else {
                        // Update category sum
                        categorySums[category] = (categorySums[category] ?? 0) + amount
                    }
                }

                let data = categorySums.map { (category, sum) in
                    return (sum, category)
                }

                completion(data)
            } catch let error as NSError {
                print(error.localizedDescription)
                completion([])
            }
        }
    }

    // Function to convert currencies to INR
    private static func convertToINR(amount: Double, fromCurrency: String) -> Double {
        let exchangeRates: [String: Double] = [
            "usd": 75.0,  // Replace with actual exchange rates
            "euro": 85.0,
            "gbp": 100.0,
            "jpy": 0.70,
            "aud": 55.0,
            "cad": 60.0,
            "cny": 11.0
        ]

        guard let exchangeRate = exchangeRates[fromCurrency] else {
            // If the currency is not in the list, return 1 as a default (no conversion)
            return 1.0
        }

        return exchangeRate
    }




    static func predicate(with categories: [Category], searchText: String) -> NSPredicate? {
        var predicates = [NSPredicate]()
        
        if !categories.isEmpty {
            let categoriesString = categories.map { $0.rawValue }
            predicates.append(NSPredicate(format: "category IN %@", categoriesString))
        }
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", searchText.lowercased()))
        }
        
        if predicates.isEmpty {
            return nil
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
}

