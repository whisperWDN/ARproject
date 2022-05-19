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
    let tableArticles: [TableArticle] = tableArticleData
    var body: some View {
        HStack{
            ForEach(tableArticles){
                item in
                Button(action: {
                    addEntity = true
                    EntityName = item.name
                }, label: {
                    Image(item.name)
                        .clipShape(Circle())
                        .opacity(0.5)
                        .frame(width: 1, height: 1)
                })
            }
        }
    }
}

struct AddEntityList_Previews: PreviewProvider {
    static var previews: some View {
        AddEntityList(addEntity: , EntityName: )
    }
}
