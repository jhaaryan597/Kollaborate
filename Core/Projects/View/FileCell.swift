import SwiftUI

struct FileCell: View {
    let file: File
    
    var body: some View {
        HStack {
            Image(systemName: "doc.fill")
                .foregroundColor(Color("AccentColor"))
            
            Text(file.name)
                .font(.system(size: 14))
                .foregroundColor(Color("PrimaryText"))
            
            Spacer()
        }
        .padding()
        .background(Color("SurfaceHighlight"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct FileCell_Previews: PreviewProvider {
    static var previews: some View {
        FileCell(file: File(id: "1", name: "Sample File.pdf", type: "pdf", url: ""))
    }
}
