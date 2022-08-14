//
//  PermissionError.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.08.22.
//

import SwiftUI

struct PermissionError: View {
    
    var symbol: String
    var description: String
    
    init(
        symbol: String = "xmark.octagon",
        description: String = ""
    ) {
        self.symbol = symbol
        self.description = description
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: Spacing.medium) {
                
                Image(systemName: symbol)
                    .resizable()
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .foregroundColor(.orange)
                    .padding()
                
                ButtonIcon(
                    "Einstellungen öffnen",
                    icon: "arrow.forward",
                    action: openSettings
                )
                
                Text(description)
                    .foregroundColor(.gray)
                    .modifier(FontText())
            }
            Spacer()
        }
    }
    
    let imageSize: CGFloat = 100
    
    private func openSettings() {
        UIApplication.shared.open(URL(string:
            UIApplication.openSettingsURLString)!
        )
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionError(
            symbol: "location.circle",
            description: "Um Kilometer sammeln zu können, musst du uns erlauben, auf deinen Standort zuzugreifen."
        )
    }
}
