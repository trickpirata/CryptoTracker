//
//  GPSearchBar.swift
//
//  Created by Trick Gorospe on 8/13/21.
//

import SwiftUI

public struct GPSearchBar: View {
    private let placeholder: String
    private var searchText: Binding<String>
    private let action: () -> Void
    private let returnAction: () -> Void
    @State private var isEditing = false
    
    public var body: some View {
        HStack {
            GPTextField(placeholder: placeholder, text: searchText, keyboardType: .default, returnType: .search, returnAction: returnAction)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.action()
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }.padding()
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.action()
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
    
    public init(placeholder: String, searchText: Binding<String>, cancelAction: @escaping () -> Void = {}, returnAction: @escaping () -> Void = {}) {
        self.searchText = searchText
        self.action = cancelAction
        self.placeholder = placeholder
        self.returnAction = returnAction
    }
}

#if DEBUG
struct GPSearchBarSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        GPSearchBar(placeholder: "Search", searchText: .constant(" "))
    }
}
#endif

