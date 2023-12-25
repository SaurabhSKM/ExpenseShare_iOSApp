import SwiftUI
import CoreData

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    @State var isAddFormPresented: Bool = false
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                if totalExpenses != nil {
                    Text("Total expenses")
                        .font(.headline)
                    if totalExpenses != nil {
                        Text(totalExpenses!.formattedCurrencyText)
                            .font(.largeTitle)
                    }
                }
            }
            
            if categoriesSum != nil {
                if totalExpenses != nil && totalExpenses! > 0 {
                    PieChartView(
                        data: categoriesSum!.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                }
                
                Divider()

                List {
                    Text("Breakdown").font(.headline)
                    ForEach(self.categoriesSum!) {
                        CategoryRowView(category: $0.category, sum: $0.sum)
                    }
                }
            }
            
            if totalExpenses == nil && categoriesSum == nil {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
        .onAppear(perform: {fetchTotalSums()})
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }


    // Helper function to get the currency conversion factor
    public func getConversionFactor(for currency: String) -> Double? {
        // Implement logic to fetch or define conversion factor for the given currency
        // Example: USD to INR conversion factor
        let conversionFactors: [String: Double] = [
            "usd": 75.0, // Replace with actual conversion factors
            "inr": 1.0,
            "euro": 85.0,
            "gbp": 100.0,
            "jpy": 0.70,
            "aud": 55.0,
            "cad": 60.0,
            "cny": 12.0
        ]
        
        return conversionFactors[currency.lowercased()]
    }

}


struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
