//
//  RegisterFormModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation
import Combine

class RegisterFormModel: FormModel {
    
    @Published var mail = FieldModel(
        label: "E-Mail",
        type: .Email,
        validate: Validator.mail
    )
    @Published var firstName = FieldModel(
        label: "Vorname",
        contentType: .givenName,
        validate: Validator.name
    )
    @Published var lastName = FieldModel(
        label: "Nachname",
        contentType: .familyName,
        validate: Validator.name
    )
    @Published var password = FieldModel(
        label: "Password",
        type: .Password,
        validate: Validator.password
    )
    
    override var fields: [FieldModel] {
        [mail, firstName, lastName, password]
    }
    
    override func submit() {
        let data = UserRegisterDto(
            mail: mail.value,
            firstName: firstName.value,
            lastName: lastName.value,
            password: password.value,
            role: .Participant
        )
        
        if let url = URL(string: Http.baseUrl + "/auth/signup") {
            do {
                try Http.post(url, payload: data)
                    .subscribe(on: DispatchQueue(label: "SessionProcessingQueue") )
                    .map({ $0.data })
                    .decode(type: UserDto.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .finished:
                            print("finished")
                        case .failure(let error):
                            self.errorMessage = "Es ist ein Fehler aufgetreten"
                            print(error.localizedDescription)
                        }
                    }, receiveValue: { [weak self] user in
                        self?.errorMessage = nil
                        Application.token = user.token
                    }).store(in: &anyCancellable)
            } catch {
                self.errorMessage = "Bitte überprüfen Sie Ihre Eingaben versuchen es dann erneut"
            }
        }
    }
}
