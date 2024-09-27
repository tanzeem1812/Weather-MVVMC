import SwiftUI

struct MessageView: View {
    let text: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text)
            Spacer()
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

#Preview {
    MessageView(text: String(localized: "noData"), image: Image(systemName: "face.smiling"))
} 
