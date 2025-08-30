import SwiftUI

struct CreateThreadView: View {
    @StateObject var viewModel = CreateThreadViewModel()
    @State private var caption = ""
    @State private var threadType: ThreadType = .standard
    @State private var showDocumentPicker = false
    @Environment(\.dismiss) var dismiss
    
    private var user: User? {
        return AuthService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.username ?? "")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("PrimaryText"))
                        
                        TextField("Start a discussion...", text: $caption, axis: .vertical)
                            .foregroundColor(Color("PrimaryText"))
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Color("SecondaryText"))
                        }
                    }
                }
                
                Picker("Thread Type", selection: $threadType) {
                    ForEach(ThreadType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button {
                    showDocumentPicker.toggle()
                } label: {
                    HStack {
                        Image(systemName: "paperclip")
                        Text(viewModel.selectedURL?.lastPathComponent ?? "Attach Document")
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .background(Color("PrimaryBackground"))
            .navigationTitle("New Discussion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            try await viewModel.uploadThread(caption: caption, type: threadType)
                            dismiss()
                        }
                    }
                    .opacity(caption.isEmpty ? 0.5 : 1.0)
                    .disabled(caption.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("AccentColor"))
                }
            }
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "PrimaryText")!]
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker(selectedURL: $viewModel.selectedURL)
            }
        }
        .environment(\.colorScheme, .dark)
    }
}

struct CreateThreadView_Previews: PreviewProvider {
    static var previews: some View {
        CreateThreadView()
    }
}
