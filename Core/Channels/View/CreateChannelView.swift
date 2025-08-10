import SwiftUI

struct CreateChannelView: View {
    @State private var name = ""
    @State private var isPrivate = false
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ChannelsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Channel Name", text: $name)
                    .modifier(KollaborateTextFieldModifier())
                
                Toggle("Private Channel", isOn: $isPrivate)
                    .padding(.horizontal, 24)
                    .foregroundColor(Color("PrimaryText"))

                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("New Channel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryText"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        Task {
                            try await viewModel.createChannel(name: name, isPrivate: isPrivate)
                            dismiss()
                        }
                    }
                    .foregroundColor(Color("AccentColor"))
                    .disabled(name.isEmpty)
                }
            }
            .background(Color("PrimaryBackground"))
            .environment(\.colorScheme, .dark)
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
            }
        }
    }
}

struct CreateChannelView_Previews: PreviewProvider {
    static var previews: some View {
        CreateChannelView()
    }
}
