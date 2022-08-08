//
//  ActivityLink.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import SwiftUI

struct ActivityLink: View {
    
    var activity: Activity
    
    init(_ activity: Activity) {
        self.activity = activity
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                VStack(spacing: spacing) {
                    Text("\(activity.movement.name) \(Formatters.double(activity.distance, unit: "km"))")
                        .font(.custom(fontBold, size: iconSizeMedium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(Formatters.date(activity.date))
                        .modifier(FontText())
                }
                Image(systemName: "chevron.right")
                    .font(.custom(fontNormal, size: iconSizeMedium))
                    
            }
            .foregroundColor(colorBlack)
        }
    }
    
    var destination: some View {
        ActivityDetailView(activity)
    }
    
    let spacing: CGFloat = 5
}

struct ActivityLink_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let activites: [Activity] = try! persistenceController.container.viewContext.fetch(Activity.fetchRequest())
        
        NavigationView {
            ActivityLink(activites.randomElement()!)
        }
    }
}
