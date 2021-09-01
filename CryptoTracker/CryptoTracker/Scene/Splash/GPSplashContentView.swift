//
//  GPSplashContentView.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import Stinsen

struct GPSplashContentView: View {
    @EnvironmentObject private var router: ViewRouter<MainCoordinator.Route>
    
    @State private var scale = false
    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
                .scaleEffect(scale ? 1 : 2)
                .animation(.linear(duration: 1.5))
            Spacer()
            Text("Copyright © 2021 Patrick Gorospe")
                .font(.footnote)
                .foregroundColor(.secondary)
        }.onAppear(perform: {
            scale.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                router.route(to: .home)
            }
        })
    }
}

#if DEBUG
struct GPSplashContentView_Previews: PreviewProvider {
    static var previews: some View {
        GPSplashContentView()
    }
}
#endif
