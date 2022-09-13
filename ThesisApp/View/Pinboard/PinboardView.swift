//
//  PinboardView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import Combine
import PopupView

struct PinboardView: View {
    
    @FetchRequest var postings: FetchedResults<Posting>
    @StateObject var viewModel: ViewModel
    @AppStorage var userId: Int
    
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
        self._postings = FetchRequest(
            entity: Posting.entity(),
            sortDescriptors: [
                NSSortDescriptor(
                    keyPath: \Posting.creationDate_,
                    ascending: false
                )
            ],
            animation: .easeIn
        )
        self._userId = AppStorage(wrappedValue: 0, .userId)
    }
    
    var body: some View {
        List {
            Section {
                ForEach(postings) { entry in
                    link(for: entry)
                }
            }
            header: {
                VStack(alignment: .leading, spacing: .large) {
                    header
                    control
                }
                .spacing(.top, .extraLarge)
            }
        }
        .refreshable {
            await viewModel.refreshPostings()
        }
        .modifier(ListStyle())
        .networkAlert(isPresented: $viewModel.disconnected)
    }
    
    var header: some View {
        Text("Schwarzes Brett")
            .modifier(FontTitle())
    }
    
    var control: some View {
        VStack(spacing: .small) {
            ButtonLink("Neuer Aushang", icon: "plus") {
                CreatePostingView(
                    pinboardService: viewModel.pinboardService,
                    persistenceController: viewModel.persistenceController
                ).navigationLink()
            }
            
            ButtonIcon("Suchen", icon: "magnifyingglass") {}
        }
        .spacing(.bottom, .large)
    }
    
    func link(for posting: Posting) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: .ultraSmall) {
                Text(posting.headline)
                    .modifier(FontH1())
                    .multilineTextAlignment(.leading)
                KeywordList(posting.keywords)
                    .modifier(FontH5())
            }
            
            Image(systemName: "chevron.right")
                .modifier(FontIconMedium())
                
        }
        .background(
            NavigationLink(destination: destination(for: posting)) {
                EmptyView()
            }.opacity(0)
        )
        .listRowSeparator(.hidden)
        .listRowBackground(Color.background)
    }
    
    func destination(for posting: Posting) -> some View {
        PostingDetailView(
            posting: posting,
            pinboardService: viewModel.pinboardService,
            persistenceController: viewModel.persistenceController
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: ButtonBack(), trailing: menu(for: posting))
    }
    
    @ViewBuilder
    func menu(for posting: Posting) -> some View {
        if posting.isCreator(userId) {
            ButtonMenu {
                Button(role: .destructive, action: { viewModel.deletePosting(posting) }) {
                    Label("Beitrag löschen", systemImage: "trash")
                }
            }
        } else {
            EmptyView()
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
