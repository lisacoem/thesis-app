//
//  TextArea.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import SwiftUI

struct TextArea: View {
    
    @ObservedObject var model: FieldModel
    @State var valid = true
    
    init(_ model: FieldModel) {
        self.model = model
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(model.label)
                .font(.custom(fontBold, size: fontSizeText))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.clear)

            TextEditor(text: $model.value)
                .frame(minHeight: 0, maxHeight: 150)
                .foregroundColor(valid ? colorBlack : colorRed)
                .font(.custom(fontNormal, size: fontSizeText))
                .onChange(of: model.value) { value in
                    valid = model.validate(value)
                }
            
            Rectangle()
                .frame(height: 2.5)
                .foregroundColor(colorLightBrown)
                .opacity(0.7)
        }

    }
}

struct TextArea_Previews: PreviewProvider {
    static var previews: some View {
        Page {
            TextArea(.init(label: "Nachricht"))
        }
    }
}
