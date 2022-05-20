//
//  AddEntityList.swift
//  ARproject
//
//  Created by admin on 2022/5/18.
//

import SwiftUI

struct AddEntityList: View {
    @Binding var addEntity: Bool
    @Binding var EntityName: String
    @Binding var showingList :Bool
    let tableArticles: [TableArticle] = tableArticleData
    var body: some View {
        HStack(spacing:15){
            ForEach(tableArticles){
                item in
                Button(action: {
                    addEntity = true
                    EntityName = item.name
                }, label: {
                    Image(item.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .opacity(0.5)
                })
            }
            
            Button(action: {
                showingList = false
            }, label: {
                Image(systemName: "chevron.left.2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75, alignment: .center)
                    .clipShape(Circle())
                    .opacity(0.5)
            })

        }
    }
}
