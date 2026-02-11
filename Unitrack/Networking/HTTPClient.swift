//
//  HTTPClient.swift
//  Unitrack
//
//  Created by Sylus Abel on 11/02/2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case serverError(String)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from the server."
        case .serverError(let message):
            return message
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

struct HTTPClient {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private func handleResponse<T: Codable>(_ data: Data, _ response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } else {
            // Try to decode backend error message
            if let apiError = try? decoder.decode(APIErrorResponse.self, from: data),
               let message = apiError.error ?? apiError.message {
                throw APIError.serverError(message)
            }
            throw APIError.serverError("Server returned status code \(httpResponse.statusCode)")
        }
    }

    func post<T: Codable>(to url: URL, body: some Encodable) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data, response)
    }

    func get<T: Codable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data, response)
    }

    func put<T: Codable>(to url: URL, body: some Encodable) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data, response)
    }

    func delete<T: Codable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data, response)
    }
}