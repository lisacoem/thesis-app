//
//  SeedOption.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 28.08.22.
//

import SwiftUI

struct SeedOption: View {
    
    var seed: Seed
    
    init(_ seed: Seed) {
        self.seed = seed
    }
    
    var body: some View {
        ZStack {
            Image(seed.name)
                .resizable()
                .scaledToFit()
                .padding(.bottom, Spacing.medium)
            
            VStack {
                Spacer()
                
                HStack {
                    Text(seed.name.uppercased())
                        .font(.custom(Font.normal, size: 12))
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.customOrange)
                            .frame(width: 20, height: 20)
                        
                        Text("\(seed.price)")
                            .font(.custom(Font.normal, size: 10))
                    }
                }
            }
            .padding(Spacing.extraSmall)
        }
        .aspectRatio(1/1, contentMode: .fit)
        .background(Color.customBeige)
        .cornerRadius(18)
    }
}

struct SeedOption_Previews: PreviewProvider {
    static var previews: some View {
        let seed = Seed(
            id: 0,
            name: "Wirsing",
            price: 25,
            seasons: [],
            in: PersistenceController.preview.container.viewContext
        )

        SeedOption(seed)
            .frame(width: 100)
        
    }
}
