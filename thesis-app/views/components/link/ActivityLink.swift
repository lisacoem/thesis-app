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
                    Text(Activity.string(from: activity))
                        .font(.custom(fontBold, size: fontSize))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(Activity.string(from: activity.date))
                        .modifier(FontText())
                }
                Image(systemName: "chevron.right")
                    .font(.custom(fontNormal, size: fontSize))
                    
            }
            .foregroundColor(colorBlack)
        }
    }
    
    var destination: some View {
        ActivityDetailView(activity)
    }
    
    let spacing: CGFloat = 5
    let fontSize: CGFloat = 22
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
