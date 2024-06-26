//
//  ColumnList.swift
//  ThesisApp
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
        HStack(alignment: .center) {
            ForEach(views.indices) { index in
                if (index > 0) {
                    Rectangle()
                        .background(Color.customBlack)
                        .frame(maxHeight: 100)
                        .frame(width: 1.5)
                }
                views[index]
            }
        }
    }
}

struct ColumnList_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            VStack(spacing: 30) {
                
                Text("ColumnList with 2 Items")
                    .modifier(FontSubtitle())
                
                ColumnList {
                    InfoItem(symbol: "figure.walk", value: "13,70 km")
                    InfoItem(symbol: "bicycle", value: "150,60 km")
                    
                }
            }
        
            VStack(spacing: 30) {
                
                Text("ColumnList with 4 Items")
                    .modifier(FontSubtitle())
                
                ColumnList {
                    InfoItem(symbol: "figure.walk", value: "13,70 km")
                    InfoItem(symbol: "bicycle", value: "50,60 km")
                    InfoItem(symbol: "bicycle", value: "46,10 km")
                    InfoItem(symbol: "figure.walk", value: "12,30 km")
                }
            }
        }
    }
}
