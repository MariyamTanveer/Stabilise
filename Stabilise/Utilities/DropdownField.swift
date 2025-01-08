import SwiftUI

struct DropdownField: View {
    @Binding var title: String
    var options: [String]
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack {
                    Text(title)
                        .foregroundColor(title.contains("Select") ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color(UIColor.systemBrown))
                }
                .dropDownStyle()
            }
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            title = option
                            isExpanded = false
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                        }
                        .overlay(Divider(), alignment: .bottom)
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(AppColors.secondary), lineWidth: 1))
            }
        }
        .animation(.easeInOut, value: isExpanded)
    }
}

