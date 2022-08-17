//
//  PermissionError.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.08.22.
//

import SwiftUI

extension PermissionError {
    
    class ViewModel: ObservableObject {
        
        @Published var symbol: String
        @Published var description: String
        
        init(symbol: String, description: String) {
            self.symbol = symbol
            self.description = description
        }
        
        func openSettings() {
            UIApplication.shared.open(URL(string:
                UIApplication.openSettingsURLString)!
            )
        }
    }
}

struct PermissionError: View {
    
    @StateObject var viewModel: ViewModel
    
    init(
        symbol: String = "xmark.octagon",
        description: String = ""
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(symbol: symbol, description: description)
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: Spacing.medium) {
                
                Image(systemName: viewModel.symbol)
                    .resizable()
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .foregroundColor(.customOrange)
                    .padding()
                
                ButtonIcon(
                    "Einstellungen öffnen",
                    icon: "arrow.forward",
                    action: viewModel.openSettings
                )
                
                Text(viewModel.description)
                    .foregroundColor(.gray)
                    .modifier(FontText())
            }
            Spacer()
        }
    }
    
    let imageSize: CGFloat = 100
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionError(
            symbol: "location.circle",
            description: "Um Kilometer sammeln zu können, musst du uns erlauben, auf deinen Standort zuzugreifen."
        )
    }
}
