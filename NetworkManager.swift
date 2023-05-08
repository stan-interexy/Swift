import Foundation

enum NetworkError: Error {
    case urlError
    case dataError
    case decodingError
}

protocol NetworkManagerProtocol {
    func fetch<T: Codable>(endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetch<T: Codable>(endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(.urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}