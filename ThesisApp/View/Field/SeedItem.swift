//
//  SeedItem.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.09.22.
//

import SwiftUI

struct SeedItem: View {
    
    @ObservedObject var seed: Seed

    var selected: Bool
    var available: Bool
    
    var body: some View {
        ZStack {
            image
            VStack {
                Spacer()
                HStack {
                    name
                    Spacer()
                    price
                }
            }
            .spacing(.all, .extraSmall)
        }
        .aspectRatio(1/1, contentMode: .fit)
        .background(backgroundColor)
        .opacity(available ? 1 : 0.5)
        .cornerRadius(18)
    }
    
    var image: some View {
        AsyncImage(url: seed.imageUrl) { image in
            image
                .resizable()
                .scaledToFit()
                .spacing(.bottom, .medium)
        } placeholder: {
            Color.clear
        }
    }
    
    var name: some View {
        Text(seed.name.uppercased())
            .font(.custom(.normal, size: 12))
    }
    
    var price: some View {
        ZStack {
            Circle()
                .fill(Color.customOrange)
                .frame(width: 20, height: 20)
            
            Text("\(seed.price)")
                .font(.custom(.normal, size: 10))
        }
    }
    
    var backgroundColor: Color {
        selected ? Color.customLightBrown : Color.customLightBeige
    }
}
