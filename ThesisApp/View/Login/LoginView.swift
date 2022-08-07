//
//  LoginView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 31.07.22.
//

import SwiftUI

struct LoginView: View {
    
    @State var register = false
    
    var body: some View {
        Page {
            if register {
                RegisterForm(switchMode: { register = false })
            } else {
                LoginForm(switchMode: { register = true })
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
