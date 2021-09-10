//
//  HTTPMovieClient.swift
//  SwiftUI-Movies_App
//
//  Created by Arpit Dixit on 10/09/21.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

class HTTPMovieClient: ObservableObject {
    
    static let baseMoviesURL = "http://localhost:8080/movies"
    static let baseReviewsURL = "http://localhost:8080/reviews"
    
    @Published var movies = [Movie]()
    @Published var reviews = [Review]()
    
    func getAllMovie() {
        
        guard let url = URL(string: HTTPMovieClient.baseMoviesURL) else {
            fatalError("URL doesn't exist")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let movies = try? JSONDecoder().decode([Movie].self, from: data)
            if let movies = movies {
                DispatchQueue.main.async {
                    self.movies = movies
                }
            }
        }.resume()
    }
    
    func saveMovie(name: String, poster: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: HTTPMovieClient.baseMoviesURL) else {
            fatalError("URL doesn't exist")
        }
        
        let movie = Movie(title: name, poster: poster)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(movie)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                return completion(false)
            }
            
            completion(true)
        }.resume()
    }
    
    func deleteMovie(movie: Movie, completion: @escaping (Bool) -> Void) {
        guard let uuid = movie.id, let url = URL(string: HTTPMovieClient.baseMoviesURL + "/\(uuid.uuidString)") else {
            fatalError("URL doesn't exist")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                return completion(false)
            }
            
            completion(true)
        }.resume()
    }
    
    func saveReview(review: Review, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: HTTPMovieClient.baseReviewsURL) else {
            fatalError("URL doesn't exist")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(review)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                return completion(false)
            }
            
            completion(true)
        }.resume()
    }
    
    func getReviewsByMovie(movie: Movie) {
        
        guard let uuid = movie.id,
              let url = URL(string: HTTPMovieClient.baseMoviesURL + "/\(uuid.uuidString)/reviews") else {
            fatalError("URL doesn't exist")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let reviews = try? JSONDecoder().decode([Review].self, from: data)
            if let reviews = reviews {
                DispatchQueue.main.async {
                    self.reviews = reviews
                }
            }
        }.resume()
    }
}
