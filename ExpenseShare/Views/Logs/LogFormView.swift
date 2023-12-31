import SwiftUI
import CoreData

struct LogFormView: View {
    var logToEdit: ExpenseLog?
    var context: NSManagedObjectContext
    @State private var isAddingFriend = false
    @State private var newFriendName = ""
    @State var selectedCurrency: Currency = .inr
    @State var name: String = ""
    @State var amount: Double = 0
    @State var category: Category = .utilities
    @State var date: Date = Date()
    @State var Friend: String = ""
    @State var isPaidByMe: Bool = false
    @Environment(\.presentationMode)
    var presentationMode
    
    var title: String {
        logToEdit == nil ? "Create Expense Log" : "Edit Expense Log"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(logToEdit == nil ? "Create Expense Log" : "Edit Expense Log")) {
                    TextField("Name", text: $name)
                        .disableAutocorrection(true)
                    
                    AmountTextField(amount: $amount, selectedCurrency: selectedCurrency)
                    
                    Picker(selection: $selectedCurrency, label: Text("Currency")) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue.uppercased()).tag(currency)
                        }
                    }
                    .onReceive([selectedCurrency].publisher.first()) { newCurrency in
                    }
                    
                    Picker(selection: $category, label: Text("Category")) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    
                    DatePicker(selection: $date, displayedComponents: .date) {
                        Text("Date")
                    }
                }
                    Section {
                        Toggle("Paid by Me", isOn: $isPaidByMe)
                            .accentColor(.blue)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            
                            TextField("Who Paid", text: $Friend)
                                .disableAutocorrection(true)
                                .disabled(isPaidByMe)
                        }
                    }

                Section {
                    VStack {
                        Button(action: onSaveTapped) {
                            Text("Save")
                        }
                        .foregroundColor(.blue)
                        Divider()
                        Button(action: onCancelTapped) {
                            Text("Cancel")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationBarHidden(true)

        }

        
    }
    
    private func onCancelTapped() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onSaveTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let log: ExpenseLog
        if let logToEdit = self.logToEdit {
            log = logToEdit
        } else {
            log = ExpenseLog(context: self.context)
            log.id = UUID()
        }
        
        log.name = self.name
        log.category = self.category.rawValue
        log.amount = NSDecimalNumber(value: self.amount)
        log.date = self.date
        log.currency=self.selectedCurrency.rawValue
        if isPaidByMe {
               log.whopaid = "Me"
           } else {
               log.whopaid = self.Friend
        }
        
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct LogFormView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(containerName: "ExpenseTracker")
        return LogFormView(context: stack.viewContext)
    }
}
