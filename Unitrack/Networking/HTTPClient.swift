//
//  HTTPClient.swift
//  Unitrack
//
//  Created by Sylus Abel on 11/02/2026.
//

import Foundation

struct HTTPClient {
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }()

    private func applyHeaders(to request: inout URLRequest, requiresAuth: Bool) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if requiresAuth, let token = TokenManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    func post<T: Codable>(to url: URL, body: some Encodable, requiresAuth: Bool = true) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        request.httpBody = try encoder.encode(body)
        
        print("🔵 POST Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🔵 Response Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }

    func get<T: Codable>(from url: URL, requiresAuth: Bool = true) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        
        print("🟢 GET Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🟢 Response Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }

    func put<T: Codable>(to url: URL, body: some Encodable, requiresAuth: Bool = true) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        request.httpBody = try encoder.encode(body)
        
        print("🟠 PUT Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🟠 Response Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }

    func delete<T: Codable>(from url: URL, requiresAuth: Bool = true) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        
        print("🔴 DELETE Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🔴 Response Status: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }

    func postVoid(to url: URL, body: some Encodable, requiresAuth: Bool = true) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        request.httpBody = try encoder.encode(body)
        
        print("🔵 POST (Void) Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🔵 Response Status: \(httpResponse.statusCode)")
        if !(200...299).contains(httpResponse.statusCode) {
            if let responseString = String(data: data, encoding: .utf8) {
                print("🔵 Error Response Body: \(responseString)")
            }
            throw URLError(.badServerResponse)
        }
    }

    func putVoid(to url: URL, body: some Encodable, requiresAuth: Bool = true) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        request.httpBody = try encoder.encode(body)
        
        print("🟠 PUT (Void) Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🟠 Response Status: \(httpResponse.statusCode)")
        if !(200...299).contains(httpResponse.statusCode) {
            if let responseString = String(data: data, encoding: .utf8) {
                print("🟠 Error Response Body: \(responseString)")
            }
            throw URLError(.badServerResponse)
        }
    }

    func deleteVoid(from url: URL, requiresAuth: Bool = true) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        applyHeaders(to: &request, requiresAuth: requiresAuth)
        
        print("🔴 DELETE (Void) Request to: \(url)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("🔴 Response Status: \(httpResponse.statusCode)")
        if !(200...299).contains(httpResponse.statusCode) {
            if let responseString = String(data: data, encoding: .utf8) {
                print("🔴 Error Response Body: \(responseString)")
            }
            throw URLError(.badServerResponse)
        }
    }
}

extension Error {
    var userFriendlyMessage: String {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1011 {
            return "Server Error (-1011): The request was rejected. Check logs for details."
        }
        return self.localizedDescription
    }
}