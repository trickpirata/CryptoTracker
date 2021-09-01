//
//  GPCoinSettingSwitchView.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/31/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import CryptoTrackerUI

struct GPCoinSettingSwitchView: View {
    @Environment(\.defaultStyle) private var style
    
    @Binding var isOn: Bool
    let title: String
    let action: () -> Void
    var body: some View {
        let bindingOn = Binding<Bool> (
            get: { self.isOn },
            set: { newValue in
                self.isOn = newValue
                action()
            }
        )
        HStack {
            Toggle(title, isOn: bindingOn)
                .toggleStyle(CheckboxStyle())
        }.padding()
        
    }
}

struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
 
            configuration.label
 
            Spacer()
 
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .green : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
 
    }
}

#if DEBUG
struct GPCoinSettingSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        GPCoinSettingSwitchView(isOn: .constant(false), title: "Cardano", action: {})
    }
}
#endif
