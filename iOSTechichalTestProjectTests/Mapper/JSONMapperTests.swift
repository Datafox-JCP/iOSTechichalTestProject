//
//  JSONMapperTests.swift
//  iOSTechichalTestProjectTests
//
//  Created by Juan Hernandez Pazos on 08/09/22.
//

import Foundation
import XCTest
@testable import iOSTechichalTestProject

class JSONMapperTests: XCTestCase {
    
    func test_with_valid_json_sucessfully_decodes() {
        
        XCTAssertNoThrow(try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self), "Mapper shouldn't throw an error")
        
        let userResponse = try? StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        XCTAssertNotNil(userResponse, "User responde shouldn't be nil")
        
        XCTAssertEqual(userResponse?.page, 1, "Page  number should be 1")
        XCTAssertEqual(userResponse?.perPage, 6, "Page  number should be 6")
        XCTAssertEqual(userResponse?.total, 12, "Total should be 12")
        XCTAssertEqual(userResponse?.totalPages, 2, "Total pages should be 2")
        
        XCTAssertEqual(userResponse?.data.count, 6, "The total number of users should be 6")
    }
    
    func test_with_missing_file_error_thrown() {
        
    }
    
    func test_with_invalid_json_error_thrown() {
        
    }
}
