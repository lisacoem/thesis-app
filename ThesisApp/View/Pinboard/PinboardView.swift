//
//  PinboardView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import Combine

extension PinboardView {
    
    class ViewModel: ObservableObject {
        
        var pinboardService: PinboardService
        var persistenceController: PersistenceController
        
        var anyCancellable: Set<AnyCancellable>
        
        init(
            pinboardService: PinboardService,
            persistenceController: PersistenceController
        ) {
            self.pinboardService = pinboardService
            self.persistenceController = persistenceController
            self.anyCancellable = Set()
        }
        
        func loadPostings() {
            self.pinboardService.importPostings()
                .sink(
                    receiveCompletion: {_ in},
                    receiveValue: { postingListData in
                        self.pinboardService.setVersionToken(postingListData.versionToken)
                        for postingData in postingListData.data {
                            self.persistenceController.savePosting(with: postingData)
                        }
                    }
                ).store(in: &anyCancellable)
        }
    }
}

struct PinboardView: View {
    
    @FetchRequest(
        entity: Posting.entity(),
        sortDescriptors: [NSSortDescriptor(key: "creationDate_", ascending: false)]
    ) var entries: FetchedResults<Posting>
    
    @StateObject var viewModel: ViewModel
    
    init(
        pinboardService: PinboardService,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                pinboardService: pinboardService,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        ScrollContainer {
            Text("Schwarzes Brett").modifier(FontTitle())
            
            VStack(spacing: Spacing.small) {
                
                ButtonLink("Neuer Aushang", icon: "plus") {
                    CreatePostingView(
                        pinboardService: viewModel.pinboardService,
                        persistenceController: viewModel.persistenceController
                    ).navigationLink()
                }
                
                ButtonIcon("Suchen", icon: "magnifyingglass", action: {})
            }
            .padding(.bottom, Spacing.medium)
            
            VStack(spacing: Spacing.large) {
                ForEach(entries) { entry in
                    PostingLink(entry)
                }
            }
        }.onAppear {
            viewModel.loadPostings()
        }
    }
}

struct PinboardView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview

        NavigationView {
            PinboardView(
                pinboardService: PinboardMockService(),
                persistenceController: persistenceController
            ).environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
