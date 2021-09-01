//
//  GPTextField.swift
//
//  Created by Trick Gorospe on 8/13/21.
//

import SwiftUI

public struct GPTextField: UIViewRepresentable {
    private let keyboardType: UIKeyboardType
    private let returnType: UIReturnKeyType
    private let returnAction: () -> Void
    @Binding private var text: String
    private let placeholder: String
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnType
        textField.autocorrectionType = .no
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.text = text
        textField.addTarget(context.coordinator,
                            action:  #selector(Coordinator.updateText(sender:)),
                            for: .editingChanged)
        return textField
    }

    public func updateUIView(_ textField: UITextField, context: Context) {
        textField.text = text
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    public init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType, returnType: UIReturnKeyType, returnAction: @escaping () -> Void) {
        self._text = text
        self.keyboardType = keyboardType
        self.returnType = returnType
        self.returnAction = returnAction
        self.placeholder = placeholder
    }
        
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension GPTextField {
    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: GPTextField
        
        init(_ textField: GPTextField) {
            self.parent = textField
        }
        
        func updatefocus(textfield: UITextField) {
            textfield.becomeFirstResponder()
        }
        
        @objc func updateText(sender: UITextField) {
            parent.text = sender.text ?? ""
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.returnAction()
            textField.resignFirstResponder()
            return true
        }
        
    }
}

#if DEBUG
struct GPTextField_Previews: PreviewProvider {
    static var previews: some View {
        GPTextField(placeholder: "Search", text: .constant(""), keyboardType: .default, returnType: .search) {
            print("Do Search")
        }.padding()
    }
}
#endif
