//
//  GPSettingsView.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import Stinsen
import CryptoTrackerUI
import CryptoTrackerStorage
import ActivityIndicatorView
import Combine

struct GPSettingsContentView<ViewModel>: View where ViewModel: GPSettingsViewModel {

    @ObservedObject private var viewModel: ViewModel
    
    let layout = [
        GridItem(.flexible()),
    ]

    private let didLoad = PassthroughSubject<Void, Never>()
    private let didUpdateCoin = PassthroughSubject<GPCoin, Never>()
    private let output: ViewModel.Output
    @State var isActive: Bool = false
    init(viewModel: ViewModel = GPSettingsViewModel() as! ViewModel, coins: State<[GPCoin]> = State(initialValue: [])) {
        let input = GPSettingsViewModel.Input(didLoad: didLoad.eraseToAnyPublisher(),
                                              didUpdateCoin: didUpdateCoin.eraseToAnyPublisher())
        output = viewModel.bind(input)

        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true, content: {
                VStack(spacing: 20.0) {
                    LazyVGrid(columns: layout, spacing: 5.0) {
                        ForEach(viewModel.coins, id: \.self) { coin in
                            GPCoinSettingSwitchView(isOn: .constant(coin.isActive), title: "\(coin.name)") {
                                didUpdateCoin.send(coin)
                            }
                            Divider()
                        }
                        
                    }
                }
            })
            
            //HUD loader
            ActivityIndicatorView(isVisible: $viewModel.isLoading,
                                  type: .default)
                .frame(width: 50.0, height: 50.0)
        }.navigationTitle("Coins")
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear {
            didLoad.send()
        }
    }
}

#if DEBUG
struct GPSettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        GPSettingsContentView()
    }
}
#endif
