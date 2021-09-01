//
//  GPVerticalHeaderView.swift
//  CryptoTrackerUI
//
//  Created by Trick Gorospe on 8/30/21.
//

import SwiftUI

public struct GPVerticalHeaderView: View {
    
    // MARK: - Properties
    @Environment(\.defaultStyle) private var style
    
    private let title: Text
    private let description: Text?
    private let icon: Image?
    
    public var body: some View {
        VStack(spacing: style.dimension.directionalInsets2.bottom) {
            icon?
                .resizable()
                .font(.largeTitle)
                .scaledToFit()
                .frame(width: 48, height: 48, alignment: .center)
                .padding(.all, 1)
            VStack(alignment: .leading) {
                title
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                description?
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            
        }
    }
    
    public init(title: Text, detail: Text? = nil, image: Image? = nil) {
        self.title = title
        self.description = detail
        self.icon = image
    }
}

#if DEBUG
struct GPVerticalHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GPVerticalHeaderView(title: Text("Title"), detail: Text("Description"), image: Image(systemName: "person.crop.circle")).frame(width: 120, height: 140, alignment: .center)
    }
}
#endif

