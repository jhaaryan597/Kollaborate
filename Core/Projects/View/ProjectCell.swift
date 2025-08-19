import SwiftUI

struct ProjectCell: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(project.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("PrimaryText"))
            
            Text(project.description)
                .font(.system(size: 14))
                .foregroundColor(Color("SecondaryText"))
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

struct ProjectCell_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCell(project: Project(id: "1", name: "Sample Project", description: "This is a sample project description.", ownerId: "1", memberIds: [], tasks: []))
    }
}
