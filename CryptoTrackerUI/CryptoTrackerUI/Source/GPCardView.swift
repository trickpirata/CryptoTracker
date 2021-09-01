//
//  GPCardView.swift
//  CryptoTrackerUI
//
//  Created by Trick Gorospe on 8/30/21.
//

import SwiftUI

public struct GPCardView<Header: View>: View {
    
    // MARK: - Properties
    @Environment(\.defaultStyle) private var style
        
    private let isHeaderPadded: Bool
    private let header: Header
    private let backgroundColor: Color
    private let action: () -> Void
    
    public var body: some View {
        GPContentView {
            Button {
                self.action()
            } label: {
                header
                    .foregroundColor(Color.white)
                    .if(isHeaderPadded) { $0.padding([.horizontal],
                                                     style.dimension.horizontalCardPadding) }
                    .if(isHeaderPadded) { $0.padding([.vertical],
                                                     style.dimension.verticalCardPadding) }
            }.frame(width: 125, height: 140, alignment: .center)
            .buttonStyle(NoHighlightStyle())
            .background(backgroundColor)
        }
    }
    
    // MARK: - Init

    /// Create an instance.
    /// - Parameter action: The action to perform when the view is tapped.
    /// - Parameter header: The header view to inject to the left of the button. The specified content will be stacked vertically.
    public init(action: @escaping () -> Void = {}, @ViewBuilder header: () -> Header) {
        self.init(isHeaderPadded: false, backgroundColor: Color.clear, action: action, header: header)
    }

    private init(isHeaderPadded: Bool, backgroundColor: Color, action: @escaping () -> Void = {}, @ViewBuilder header: () -> Header) {
        self.isHeaderPadded = isHeaderPadded
        self.backgroundColor = backgroundColor
        self.header = header()
        self.action = action
    }
}

public extension GPCardView where Header == _GPCardHeaderView {

    /// Create an instance.
    /// - Parameter title: The title text to display in the header.
    /// - Parameter detail: The detail text to display in the header.
    /// - Parameter action: The action to perform when the whole view is tapped.
    init(title: Text, detail: Text? = nil, icon: Image? = nil, backgroundColor: Color, action: @escaping () -> Void = {}) {
        self.init(isHeaderPadded: false, backgroundColor: backgroundColor, action: action) {
            _GPCardHeaderView(title: title, detail: detail, image: icon)
        }
    }
}

public struct _GPCardHeaderView: View {
    fileprivate let title: Text
    fileprivate let detail: Text?
    fileprivate let image: Image?

    public var body: some View {
        GPVerticalHeaderView(title: title, detail: detail, image: image)
    }
}

#if DEBUG
struct GPCardView_Previews: PreviewProvider {
    static var previews: some View {
        GPCardView(title: Text("Title"), detail: Text("Description"), icon: Image(systemName: "paperplane"), backgroundColor: Color.red, action: {})
        
        
    }
}
#endif
