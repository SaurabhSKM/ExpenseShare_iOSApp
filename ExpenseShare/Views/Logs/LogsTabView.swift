import SwiftUI
import CoreData

struct LogsTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State private var searchText: String = ""
    @State private var searchBarHeight: CGFloat = 0
    @State private var sortType = SortType.date
    @State private var sortOrder = SortOrder.descending
    
    @State var selectedCategories: Set<Category> = Set()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText, keyboardHeight: $searchBarHeight, placeholder: "Search expenses")
                FilterCategoriesView(selectedCategories: $selectedCategories)
                Divider()
                SelectSortOrderView(sortType: $sortType, sortOrder: $sortOrder)
                Divider()
                LogListView(predicate: ExpenseLog.predicate(with: Array(selectedCategories), searchText: searchText), sortDescriptor: ExpenseLogSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor)
            }
            .padding(.bottom, searchBarHeight)
            .navigationBarItems(trailing: NavigationLink(destination: LogFormView(context: context)) {
                Text("Add")
            })
            .navigationBarTitle("Expense Logs", displayMode: .inline)
        }
    }
}


struct LogsTabView_Previews: PreviewProvider {
    static var previews: some View {
        LogsTabView()
    }
}
