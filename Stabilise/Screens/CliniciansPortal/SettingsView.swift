import SwiftUI

struct SettingsView: View {
    @State private var bannerNotification = false
    @State private var questionnaireTime: Date = Date()
    @State private var exerciseTime: Date = Date()
    @State private var automaticActivityDetection = false
    
    var body: some View {
        VStack {
            // Title
            Text("Stabilise")
                .font(.largeTitle)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 184/255, green: 127/255, blue: 105/255))
                .foregroundColor(.white)
            
            Spacer()
            
            // Settings Options
            VStack(spacing: 16) {
                HStack {
                    Text("Banner Notification")
                    Spacer()
                    Toggle("", isOn: $bannerNotification)
                        .labelsHidden()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    Text("Questionnaire")
                    Spacer()
                    DatePicker("", selection: $questionnaireTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    Text("Exercise")
                    Spacer()
                    DatePicker("", selection: $exerciseTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    Toggle(isOn: $automaticActivityDetection) {
                        Text("Automatic Activity Detection")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Buttons
            VStack {
                Button(action: {
                    // Save action
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 102/255, green: 63/255, blue: 58/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Go back action
                }) {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 184/255, green: 127/255, blue: 105/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
