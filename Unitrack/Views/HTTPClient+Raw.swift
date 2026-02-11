import Foundation

extension HTTPClient {
    // Sends a POST request and returns the raw Data response.
    func postData(to url: URL, body: some Encodable) async throws -> Data {
        // Reuse the existing generic method by decoding into Data.self if available,
        // otherwise, if your implementation doesn't support Data decoding, 
        // you should implement this by constructing a URLRequest and performing it.
        // Here we assume the generic method can return Data when requested.
        let data: Data = try await self.post(to: url, body: body)
        return data
    }

    // Sends a GET request and returns the raw Data response.
    func getData(from url: URL) async throws -> Data {
        let data: Data = try await self.get(from: url)
        return data
    }

    // Sends a PUT request and returns the raw Data response.
    func putData(to url: URL, body: some Encodable) async throws -> Data {
        let data: Data = try await self.put(to: url, body: body)
        return data
    }

    // Sends a DELETE request and returns the raw Data response.
    func deleteData(from url: URL) async throws -> Data {
        let data: Data = try await self.delete(from: url)
        return data
    }
}
