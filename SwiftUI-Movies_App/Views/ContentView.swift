//
//  ContentView.swift
//  SwiftUI-Movies_App
//
//  Created by Arpit Dixit on 09/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let screenSize = UIScreen.main.bounds
    
    @ObservedObject private var httpClient = HTTPMovieClient()
    
    var body: some View {
        
        NavigationView {
            List(httpClient.movies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailsView(movie: movie)) {
                    VStack {
                        Image(movie.poster)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(movie.title)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .font(.system(size: 25))
                            .cornerRadius(10.0)
                    }
                }
            }
            .fullscreen()
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Movies")
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = true
            }){
                Image(systemName: "plus")
            })
            .onAppear(perform: {
                httpClient.getAllMovie()
            })
        }
        .sheet(isPresented: $isPresented, onDismiss: {
                httpClient.getAllMovie()
        }, content: {
            AddMovieView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
