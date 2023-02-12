//
//  AnalogClockView.swift
//  AnalogClock
//
//  Created by Kavinkumar on 12/02/23.
//  
    

import SwiftUI

struct AnalogClockView: View {
    
    typealias AnalogClockCallback = (Date) -> Void
    
    @Binding var foregroundColor: Color
    @State private var currentTime: Date = Date.now
    
    var onUpdateTime: AnalogClockCallback? = nil
    
    let borderWidth: CGFloat = 20
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            let radius = geometry.size.width / 2
            let innerRadius = radius - borderWidth
            
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            
            let center = CGPoint(x: centerX, y: centerY)
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime)
            
            let hour = Double(components.hour ?? 0)
            let minute = Double(components.minute ?? 0)
            let second = Double(components.second ?? 0)
            
            // Using this circle for creating the border
            Circle()
                .foregroundColor(foregroundColor)
            
            // For clock dial
            Circle()
                .foregroundColor(.white)
                .padding(borderWidth)
            
            // Creating the ticks
            Path { path in
                for index in 0..<60 {
                    let radian = Angle(degrees: Double(index) * 6 - 90).radians
                    
                    let lineHeight: Double = index % 5 == 0 ? 25 : 10
                    
                    let x1 = centerX + innerRadius * cos(radian)
                    let y1 = centerY + innerRadius * sin(radian)
                    
                    let x2 = centerX + (innerRadius - lineHeight) * cos(radian)
                    let y2 = centerY + (innerRadius - lineHeight) * sin(radian)
                    
                    path.move(to: .init(x: x1, y: y1))
                    path.addLine(to: .init(x: x2, y: y2))
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing Seconds hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius - 20
                
                let radian = Angle(degrees: second * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing Minute hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.7
                
                let radian = Angle(degrees: minute * 6 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            // Drawing hour hand
            Path { path in
                path.move(to: center)
                
                let height = innerRadius * 0.45
                
                let radian = Angle(degrees: hour * 30 - 90).radians
                let x = centerX + height * cos(radian)
                let y = centerY + height * sin(radian)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .foregroundColor(foregroundColor)
            
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(foregroundColor)
                .position(center)
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { time in
            currentTime = time
            onUpdateTime?(time)
        }
    }
}

struct AnalogClockView_Previews: PreviewProvider {
    static var previews: some View {
        AnalogClockView(foregroundColor: .constant(.red))
    }
}
