//
//  GPContentView.swift
//  CryptoTrackerUI
//
//  Created by Trick Gorospe on 8/30/21.
//

import SwiftUI

public struct GPContentView<Content: View>: View {
    
    @Environment(\.defaultStyle) private var style
    private let content: Content
    private let showShadow: Bool
    private let contentForegroundColor: Color?
    
    private var stackedContent: some View {
        VStack {
            content
        }
    }

    @ViewBuilder public var body: some View {
        stackedContent
            .modifier(ContentModifier(showShadow: showShadow, contentForegroundColor: contentForegroundColor ?? Color(style.color.secondaryCustomGroupedBackground)))
    }

    public init(@ViewBuilder content: () -> Content, showShadow: Bool = true) {
        self.content = content()
        self.showShadow = showShadow
        self.contentForegroundColor = nil
    }
    
    public init(@ViewBuilder content: () -> Content, showShadow: Bool = true, contentForegroundColor: Color) {
        self.content = content()
        self.showShadow = showShadow
        self.contentForegroundColor = contentForegroundColor
    }
}

private struct ContentModifier: ViewModifier {
    @Environment(\.defaultStyle) private var style
    private let showShadow: Bool
    private let contentForegroundColor: Color
    
    private var contentShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: style.appearance.cornerRadius2, style: .continuous)
    }

    func body(content: Content) -> some View {
        content
            .clipShape(contentShape)
            .background(
                contentShape
                    .if(showShadow, trueContent: { rectangle in
                        rectangle
                            .shadow(color: Color(style.color.customGray), radius: style.appearance.shadowRadius1, x: style.appearance.shadowOffset1.width, y: style.appearance.shadowOffset1.height)
                    })
                    .foregroundColor(contentForegroundColor)
            )
    }
    
    init(showShadow: Bool = true) {
        self.showShadow = showShadow
        self.contentForegroundColor = .clear
    }
    
    init(showShadow: Bool = true, contentForegroundColor: Color) {
        self.showShadow = showShadow
        self.contentForegroundColor = contentForegroundColor
    }
}

#if DEBUG
struct GPContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                GPContentView {
                    VStack {
                        Button(action: {}, label: {
                            Text("Button")
                        })
                        Text("I")
                        Text("Am")
                        Text("Vertical")
                    }.padding().background(Color.blue.opacity(0.15))
                }
                GPContentView {
                    VStack {
                        Text("I")
                        Text("Am")
                        Text("Vertical")
                    }.padding().background(Color.blue.opacity(0.15))
                }
            }.padding()
        }.background(Color.red)
        .edgesIgnoringSafeArea(.all)
        
    }
}
#endif
