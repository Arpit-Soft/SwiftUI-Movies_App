//
//  MovieDetailsView.swift
//  MoviesApp
//
//  Created by Mohammad Azam on 6/19/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    let movie: Movie
    
    @State private var reviewTitle: String = ""
    @State private var reviewBody: String = ""
    
    @ObservedObject private var httpClient = HTTPMovieClient()
    
    private func deleteMovie() {
        HTTPMovieClient().deleteMovie(movie: movie) { success in
            if success {
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func saveReview() {
        let review = Review(title: reviewTitle, body: reviewBody, movie: movie)
        HTTPMovieClient().saveReview(review: review) { success in
            if success {
                DispatchQueue.main.async {
                    httpClient.getReviewsByMovie(movie: movie)
                }
            }
        }
    }
    
    var body: some View {
        
        Form {
            
            Image(movie.poster)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Section(header: Text("ADD A REVIEW").fontWeight(.bold)) {
                VStack(alignment: .center, spacing: 10) {
                    TextField("Enter Title",text: $reviewTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Enter Body",text: $reviewBody) .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Save") {
                        saveReview()
                    }
                }
                
            }
            
            Section(header: Text("REVIEWS").fontWeight(.bold)) {
                ForEach(httpClient.reviews, id: \.id) { review in
                    Text(review.title)
                }
            }
        }
        
        .onAppear(perform: {
            httpClient.getReviewsByMovie(movie: movie)
        })
        .navigationBarTitle(movie.title)
            
        .navigationBarItems(trailing: Button(action: {
            self.deleteMovie()
        }) {
            Image(systemName: "trash.fill")
        })
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie(title: "Birds of Prey", poster: "birds"))
    }
}
