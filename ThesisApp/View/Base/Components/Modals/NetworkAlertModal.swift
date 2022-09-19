//
//  NetworkAlert.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import SwiftUI
import PopupView

extension View {
    
    func networkAlertModal(isPresented: Binding<Bool>) -> some View {
        self.popup(
            isPresented: isPresented,
            type: .floater(
                verticalPadding: 80,
                useSafeAreaInset: true
            ),
            position: .bottom,
            animation: .spring(),
            autohideIn: 10
        ) {
            NetworkAlertModal()
        }
    }
}

struct NetworkAlertModal: View {
    var body: some View {
        HStack(spacing: .extraSmall) {
            Image(systemName: "wifi.slash")
                .foregroundColor(.customBlack)
                .frame(width: IconSize.medium, height: IconSize.medium)

            Text("Keine Netzwerkverbindung")
                .modifier(FontH5())
        }
        .spacing(.all, .small)
        .background(Color.customOrange)
        .cornerRadius(12)
    }
}

struct NetworkAlert_Previews: PreviewProvider {
    static var previews: some View {
        NetworkAlertModal()
    }
}
