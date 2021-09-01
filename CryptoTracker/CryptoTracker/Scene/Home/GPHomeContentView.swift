//
//  GPHomeContentView.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import Stinsen
import Combine
import ActivityIndicatorView

struct GPHomeContentView<ViewModel>: View where ViewModel: GPHomeViewModel {
    @EnvironmentObject var router: NavigationRouter<GPHomeCoordinator.Route>

    @ObservedObject private var viewModel: GPHomeViewModel
    
    let layout = [
        GridItem(.flexible()),
    ]

    private let didLoad = PassthroughSubject<Bool, Never>()
    private let output: ViewModel.Output
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true, content: {
                LazyVGrid(columns: layout, spacing: 0.0) {
                    ForEach(viewModel.market, id: \.id) { market in

                        Button(action: {
                            router.route(to: .detail(marketID: market.id, title: market.name, subtitle: market.symbol))
                        }, label: {
                            let color: Color = market.priceChange24h.sign == .minus ? .red : .green
                                GPCoinView(changeColor: color,
                                           imageURL: market.image,
                                       title: market.name,
                                       subTitle: market.symbol,
                                       price: "\(market.currentPrice.round(to: 2))",
                                       change: "\(market.priceChange24h.round(to: 2))")
                                .padding()
                        })
                        
                    }
                }
            })
            //HUD loader
            ActivityIndicatorView(isVisible: $viewModel.isLoading,
                                  type: .default)
                .frame(width: 50.0, height: 50.0)
        }.navigationTitle("Cypto Price Tracker")
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear(perform: {
            print("")
            didLoad.send(GPAppManager.defaultManager.isFirstTime)
        }).onReceive(output.didLoadMarket, perform: { market in
            GPAppManager.defaultManager.isFirstTime = false
        }).alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        })
    }
    
    init() {
        let homeViewModel = GPHomeViewModel() as! ViewModel
        let input = GPHomeViewModel.Input(didLoad: didLoad.eraseToAnyPublisher())
        output = homeViewModel.bind(input)
        viewModel = homeViewModel
    }
}

#if DEBUG
struct GPHomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            GPHomeContentView()
        })
    }
}
#endif
