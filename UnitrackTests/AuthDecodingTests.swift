import XCTest
@testable import Unitrack

final class AuthDecodingTests: XCTestCase {
    
    func testDecodeSuccessfulLogin() throws {
        let json = """
        {
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIzOWIyNDYwNi1hMTkzLTRjMzctODRhMi05NWVjMzQ4MDQxMTQiLCJlbWFpbCI6InN5bHVzQGdtYWlsLmNvbSIsImlhdCI6MTc3MDgzNDU0OCwiZXhwIjoxNzcxNDM5MzQ4fQ.wZLIrCnlk-OjRBna9VN2LDmwsZZ7lmjFDfKnC_NXnU0",
            "refreshToken": "c75jewim93emlid62px",
            "user": {
                "id": "39b24606-a193-4c37-84a2-95ec34804114",
                "email": "sylus@gmail.com",
                "subscriptionStatus": "FREE",
                "currencyCode": "USD"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(AuthResponse.self, from: json)
        
        XCTAssertEqual(response.token, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIzOWIyNDYwNi1hMTkzLTRjMzctODRhMi05NWVjMzQ4MDQxMTQiLCJlbWFpbCI6InN5bHVzQGdtYWlsLmNvbSIsImlhdCI6MTc3MDgzNDU0OCwiZXhwIjoxNzcxNDM5MzQ4fQ.wZLIrCnlk-OjRBna9VN2LDmwsZZ7lmjFDfKnC_NXnU0")
        XCTAssertEqual(response.refreshToken, "c75jewim93emlid62px")
        XCTAssertEqual(response.user.email, "sylus@gmail.com")
        XCTAssertEqual(response.user.subscriptionStatus, "FREE")
    }
    
    func testDecodeUnsuccessfulLogin() throws {
        let json = """
        {
            "error": "Invalid credentials"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(APIErrorResponse.self, from: json)
        
        XCTAssertEqual(response.error, "Invalid credentials")
    }
}
