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
        Container {
            if register {
                RegisterForm(switchMode: switchMode)
            } else {
                LoginForm(switchMode: switchMode)
            }
        }
    }
    
    func switchMode() {
        register.toggle()
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
