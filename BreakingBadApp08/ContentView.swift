//
//  ContentView.swift
//  BreakingBadApp08
//
//  Created by Beatriz Enríquez on 31/01/24.
//

import SwiftUI

struct ContentView: View {
    @State var quotes = [BBModel]()
    var body: some View {
        NavigationView{
            List(quotes, id: \.self) { quote in
                VStack (alignment: .leading, spacing:10){
                    Text("Author: \(quote.author)")
                    Text("Quote: \(quote.quote)")
                }
            }.task {
                await fetchData()
            }
        }.navigationTitle("Breaking Bad: Quotes")
    }
    
    func fetchData() async{
        guard let url = URL(string:  "https://api.breakingbadquotes.xyz/v1/quotes/10") else{
            print("URL does not exists")
            return
        }
        
        do {
            let (data,_) =  try await URLSession.shared.data(from: url)
            if let decodeResponse = try? JSONDecoder().decode([BBModel].self, from:data){
                self.quotes = decodeResponse
            }
        }catch{
            print("Invalid data or failed to fetch request")
        }
    }
}

#Preview {
    ContentView()
}
