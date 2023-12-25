import SwiftUI
import CoreData

struct CategoryRowView: View {
    @Environment(\.managedObjectContext)
        var context: NSManagedObjectContext
    @State var isAddFormPresented: Bool = false
    let category: Category
    let sum: Double
    
    var body: some View {
        HStack {
            CategoryImageView(category: category)
            Text(category.rawValue.capitalized)
            Spacer()
            Text(sum.formattedCurrencyText).font(.headline)
        }
        .sheet(isPresented: $isAddFormPresented) {
            LogFormView(context: self.context)
        }
    }

    
    func addTapped() {
        isAddFormPresented = true
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(category: .donation, sum: 2500)
    }
}
