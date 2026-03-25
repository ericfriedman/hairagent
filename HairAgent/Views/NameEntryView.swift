import SwiftUI

struct NameEntryView: View {
    @State private var name = ""
    var onContinue: (String) -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("What's your name?")
                .font(AppTheme.headingFont(size: 36))
                .foregroundStyle(AppTheme.textPrimary)

            TextField("Enter your name", text: $name)
                .font(AppTheme.bodyFont(size: 22))
                .padding()
                .frame(maxWidth: 400)
                .background(.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.pastelPink.opacity(0.5), lineWidth: 2)
                )
                .multilineTextAlignment(.center)
                .onSubmit {
                    if !name.isEmpty { onContinue(name) }
                }

            Button(action: { onContinue(name) }) {
                Text("Continue")
                    .font(AppTheme.headingFont(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 18)
                    .background(name.isEmpty ? Color.gray : AppTheme.pastelCoral)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(name.isEmpty)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            DecorativeBackground(style: .nameEntry)
        }
    }
}
