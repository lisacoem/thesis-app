//
//  FieldViewModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 05.09.22.
//

import Foundation
import Combine

extension FieldView {
    
    class ViewModel: ObservableObject {
        
        @Published var daytime: Daytime?
        @Published var weather: Weather?
        
        let fieldService: FieldService
        let persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
            self.getWeatherInfo()
            self.loadFields()
        }

        func loadFields() {
            self.fieldService.getFields()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { fields in
                        for field in fields {
                            self.persistenceController.save(with: field)
                        }
                    }
                )
                .store(in: &anyCancellable)
        }

        func refresh() async {
            do {
                let fields = try await self.fieldService.getFields().async()
                for field in fields {
                    self.persistenceController.save(with: field)
                }
                let weatherInfo = try await fieldService.getWeather().async()
                self.daytime = weatherInfo.daytime
                self.weather = weatherInfo.weather
            } catch {
                print(error)
            }
        }
        
        func getWeatherInfo() {
            fieldService.getWeather()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { data in
                        self.daytime = data.daytime
                        self.weather = data.weather
                    }
                )
                .store(in: &anyCancellable)
        }
    }
}
