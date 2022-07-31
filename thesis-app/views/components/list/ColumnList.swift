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
                    Divider()
                        .background(colorBlack)
                        .frame(maxHeight: 100)
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
                Text("ColumnList with 2 Items").modifier(FontSubtitle())
                ColumnList {
                    DistanceTrack(.Walking, distance: 13.7)
                    DistanceTrack(.Cycling, distance: 50.6)
                    
                }
            }
        
            VStack(spacing: 30) {
                Text("ColumnList with 4 Items").modifier(FontSubtitle())
                ColumnList {
                    DistanceTrack(.Walking, distance: 13.7)
                    DistanceTrack(.Cycling, distance: 50.6)
                    DistanceTrack(.Cycling, distance: 46.1)
                    DistanceTrack(.Walking, distance: 12.3)
                }
            }
        }
    }
}
