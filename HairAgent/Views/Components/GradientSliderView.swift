import SwiftUI

struct GradientSliderView: View {
    @Binding var selectedColor: SelectedHairColor?
    @State private var sliderPosition: Double = 0.3

    var body: some View {
        VStack(spacing: 16) {
            Text(HairColorGradient.closestLabel(at: sliderPosition))
                .font(AppTheme.headingFont(size: 22))
                .foregroundStyle(AppTheme.textPrimary)
                .animation(.easeInOut(duration: 0.15), value: sliderPosition)

            Circle()
                .fill(HairColorGradient.interpolate(at: sliderPosition).color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)

            GeometryReader { geo in
                let barHeight: CGFloat = 40
                let thumbSize: CGFloat = 44

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: barHeight / 2)
                        .fill(HairColorGradient.swiftUIGradient)
                        .frame(height: barHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: barHeight / 2)
                                .stroke(Color.white, lineWidth: 2)
                        )

                    Circle()
                        .fill(HairColorGradient.interpolate(at: sliderPosition).color)
                        .frame(width: thumbSize, height: thumbSize)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                        .offset(x: sliderPosition * (geo.size.width - thumbSize))
                }
                .frame(height: max(barHeight, thumbSize))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let thumbSize: CGFloat = 44
                            let newPos = max(0, min(1, value.location.x / (geo.size.width - thumbSize + 1)))
                            sliderPosition = newPos
                            selectedColor = HairColorGradient.interpolate(at: newPos)
                        }
                )
            }
            .frame(height: 50)
        }
        .padding(.horizontal, 24)
        .onAppear {
            selectedColor = HairColorGradient.interpolate(at: sliderPosition)
        }
    }
}
