//
//  GPCoiView.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import CryptoTrackerUI
import SDWebImageSwiftUI

struct GPCoinView: View {
    @Environment(\.defaultStyle) private var style
    
    let changeColor: Color
    let imageURL: String?
    let title: String
    let subTitle: String
    let price: String
    let change: String
    
    var body: some View {
        GPContentView {
            HStack(alignment: .top) {
                WebImage(url: URL(string: imageURL ?? ""), options: .retryFailed, context: nil)
                    .placeholder(content: {
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    })
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(maxWidth: 80, maxHeight: 80)
                    .clipped()
                    .padding()
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(style.color.black))
                    Text(subTitle)
                        .font(.subheadline)
                        .foregroundColor(Color(style.color.black))
                    VStack(alignment: .leading) {
                        Text("$\(price)")
                            .font(.body)
                    }
                }.padding([.top], 10)
                Spacer()
                Text("\(change)")
                    .font(.body)
                    .foregroundColor(changeColor)
                    .padding()
         
            }

        }.overlay(
            RoundedRectangle(cornerRadius: style.appearance.cornerRadius2)
                .stroke(Color(style.color.borderColor), lineWidth: style.appearance.lineWidth2)
        )
    }
}

#if DEBUG
struct GPCoinView_Previews: PreviewProvider {
    static var previews: some View {
        GPCoinView(changeColor: .green, imageURL: "https://assets.coingecko.com/coins/images/975/large/cardano.png?1547034860",
                   title: "Cardano",
                   subTitle: "ADA",
                   price: "2.48",
                   change: "-1")
    }
}
#endif
