//
//  PinboardView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import Combine
import PopupView

struct PinboardView: View {
    
    @FetchRequest var entries: FetchedResults<Posting>
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
        self._entries = FetchRequest(
            entity: Posting.entity(),
            sortDescriptors: [
                NSSortDescriptor(key: "creationDate_", ascending: false)
            ],
            animation: .easeIn
        )
        self._userId = AppStorage(wrappedValue: 0, .userId)
    }
    
    var body: some View {
        ScrollContainer {
            header
            control
            postings
        }
        .onAppear {
            viewModel.loadPostings()
        }
        .popup(
            isPresented: $viewModel.disconnected,
            type: .floater(
                verticalPadding: Spacing.ultraLarge,
                useSafeAreaInset: true
            ),
            position: .bottom,
            animation: .spring(),
            autohideIn: 10
        ) {
            NetworkAlert()
        }
         
    }
    
    var header: some View {
        Text("Schwarzes Brett")
            .modifier(FontTitle())
            .modifier(Header())
    }
    
    var control: some View {
        VStack(spacing: Spacing.small) {
            ButtonLink("Neuer Aushang", icon: "plus") {
                CreatePostingView(
                    pinboardService: viewModel.pinboardService,
                    persistenceController: viewModel.persistenceController
                ).navigationLink()
            }
            
            ButtonIcon("Suchen", icon: "magnifyingglass") {
                
            }
        }
        .padding(.bottom, Spacing.medium)
    }
    
    var postings: some View {
        LazyVStack(spacing: Spacing.large) {
            ForEach(entries) { entry in
                link(for: entry)
            }
        }
    }
    
    func link(for posting: Posting) -> some View {
        NavigationLink(destination: destination(for: posting)) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.ultraSmall) {
                    Text(posting.headline)
                        .modifier(FontH1())
                        .multilineTextAlignment(.leading)
                    KeywordList(posting.keywords)
                        .modifier(FontH5())
                }
                
                Image(systemName: "chevron.right")
                    .modifier(FontIconMedium())
                    
            }
            .foregroundColor(.customBlack)
        }
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
