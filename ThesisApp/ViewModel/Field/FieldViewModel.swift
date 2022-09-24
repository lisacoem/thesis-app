//
//  FieldViewModel.swift
//  ThesisApp
//
//  ViewModel of FieldView
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
        
        var cancellables: Set<AnyCancellable>
        
        init(
            fieldService: FieldService,
            persistenceController: PersistenceController
        ) {
            self.fieldService = fieldService
            self.persistenceController = persistenceController
            self.cancellables = Set()
            self.getWeatherInfo()
            self.loadFields()
        }
        
        /// Get fields at users default location from API and store them in database
        func loadFields() {
            self.fieldService.getFields()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { response in
                        for fieldData in response {
                            _ = self.persistenceController.save(with: fieldData)
                        }
                    }
                )
                .store(in: &cancellables)
        }
        
        /// Refresh field and weather data async to provide pull to refresh in view
        func refresh() async {
            do {
                let fieldResponse = try await self.fieldService.getFields().async()
                for fieldData in fieldResponse {
                    _ = self.persistenceController.save(with: fieldData)
                }
                let weatherResponse = try await fieldService.getWeather().async()
                self.daytime = weatherResponse.daytime
                self.weather = weatherResponse.weather
            } catch {
                print(error)
            }
        }
        
        /// Get weather and daytime of users default location
        func getWeatherInfo() {
            fieldService.getWeather()
                .sink(
                    receiveCompletion: { _ in},
                    receiveValue: { response in
                        self.daytime = response.daytime
                        self.weather = response.weather
                    }
                )
                .store(in: &cancellables)
        }
    }
}
