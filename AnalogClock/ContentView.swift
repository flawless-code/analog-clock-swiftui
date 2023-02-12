//
//  ContentView.swift
//  AnalogClock
//
//  Created by Kavinkumar on 12/02/23.
//  
    

import SwiftUI

struct ContentView: View {
    
    @State private var themeColor: Color = .red
    @State private var currentTime: Date = Date.now
    @State private var changeRandomColor: Bool = false
    
    private var colors: [Color]
    
    init() {
        colors = [.red, .yellow, .black, .green, .orange, .blue]
    }
    
    var body: some View {
        VStack {
            AnalogClockView(foregroundColor: $themeColor) { date in
                currentTime = date
                if changeRandomColor {
                    themeColor = colors.randomElement() ?? themeColor
                }
            }
            .shadow(color: Color.black.opacity(0.15),radius: 32)
            .padding(60)
            Text(currentTime, style: .time)
                .font(.system(size: 52))
                .bold()
            Toggle(isOn: $changeRandomColor) {
                Text("Change Color")
            }
            .padding(.horizontal, 30)
            Spacer(minLength: 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeColor.opacity(0.15))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
