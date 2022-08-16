//
//  ColumnList.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI
import ViewExtractor

struct ColumnList: View {
    
    let views: [AnyView]
    
    init<Views>(@ViewBuilder content: TupleContent<Views>) {
        views = ViewExtractor.getViews(from: content)
    }
    
    var body: some View {
        HStack {
            ForEach(views.indices) { index in
                if (index > 0) {
                    Rectangle()
                        .background(Color.customBlack)
                        .frame(maxHeight: 100)
                        .frame(width: 1)
                }
                views[index]
            }
        }
    }
}

struct ColumnList_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            VStack(spacing: 30) {
                Text("ColumnList with 2 Items")
                    .modifier(FontSubtitle())
                ColumnList {
                    DistanceTracker(.Walking, distance: 13.7)
                    DistanceTracker(.Cycling, distance: 50.6)
                    
                }
            }
        
            VStack(spacing: 30) {
                Text("ColumnList with 4 Items")
                    .modifier(FontSubtitle())
                ColumnList {
                    DistanceTracker(.Walking, distance: 13.7)
                    DistanceTracker(.Cycling, distance: 50.6)
                    DistanceTracker(.Cycling, distance: 46.1)
                    DistanceTracker(.Walking, distance: 12.3)
                }
            }
        }
    }
}
