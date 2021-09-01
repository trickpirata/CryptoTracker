//
//  GPHomeDetailContentView.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/31/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import SwiftUICharts
import Stinsen
import CryptoTrackerStorage
import Combine
import ActivityIndicatorView

struct GPHomeDetailContentView<ViewModel>: View where ViewModel: GPHomeDetailViewModel {
    @EnvironmentObject var router: NavigationRouter<GPHomeCoordinator.Route>

    @ObservedObject private var viewModel: GPHomeDetailViewModel
        
    private let didLoad = PassthroughSubject<String, Never>()
    private let output: ViewModel.Output
    private let marketID: String
    private let title: String
    private let subtitle: String
    var body: some View {
        ZStack {
            VStack {
                Picker("Select Time Frame", selection: $viewModel.selectedDayIndex, content: {
                    ForEach(GPHomeDetailDayInterval.allCases, id: \.self) {
                        Text($0.title)
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
                LineView(data: viewModel.marketChartValues, title: title, legend: subtitle).padding()
            }
            
            //HUD loader
            ActivityIndicatorView(isVisible: $viewModel.isLoading,
                                  type: .default)
                .frame(width: 50.0, height: 50.0)
        }.navigationTitle("Price History")
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear(perform: {
            didLoad.send(marketID)
        }).alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        })
    }
    
    init(withMarketID _marketID: String,withTitle _title: String,andSubTitle _subtitle: String) {
        let homeViewModel = GPHomeDetailViewModel() as! ViewModel
        let input = GPHomeDetailViewModel.Input(didLoad: didLoad.eraseToAnyPublisher())
        output = homeViewModel.bind(input)
        viewModel = homeViewModel
        marketID = _marketID
        title = _title
        subtitle = _subtitle
    }
}

#if DEBUG
struct GPHomeDetailContentView_Previews: PreviewProvider {
    static var previews: some View {
        GPHomeDetailContentView(withMarketID: "cardano",withTitle: "",andSubTitle: "")
    }
}
#endif
