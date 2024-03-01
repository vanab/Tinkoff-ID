//
//  URLSchemeBuilderTests.swift
//  TinkoffID
//
//  Copyright (c) 2021 Tinkoff
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import XCTest
@testable import TinkoffID

class URLSchemeBuilderTests: XCTestCase {
    
    private var builder: URLSchemeBuilder!
    private let baseUrlString = "https://tinkoff.ru/"

    override func setUpWithError() throws {
        builder = URLSchemeBuilder(authDomains: [baseUrlString])
    }
    
    override func tearDown() {
        super.tearDown()
        builder = nil
    }
    
    func testThatBuilderProducesUrlWithCorrectBaseUrl() {
        // Given
        let expectedBaseUrl = baseUrlString
        
        // When
        let components = buildSampleUrlComponents().first!
        
        // Then
        XCTAssertEqual("\(components.scheme!)://\(components.host!)/", expectedBaseUrl)
    }
    
    func testThatBuilderProducesUrlWithCorrectQueryParameters() {
        // Given
        let launchOptions = AppLaunchOptions.stub
        
        let expectedQueryItems = [
            URLSchemeBuilder.Param.clientId: launchOptions.clientId,
            URLSchemeBuilder.Param.codeChallenge: launchOptions.payload.challenge,
            URLSchemeBuilder.Param.codeChallengeMethod: launchOptions.payload.challengeMethod,
            URLSchemeBuilder.Param.callbackUrl: launchOptions.callbackUrl
        ]
        
        // When
        let components = buildSampleUrlComponents().first!
        
        // Then
        let containsUnexpectedResults = components.queryItems?.count != expectedQueryItems.count
        let containsNonMatchedItems = expectedQueryItems.contains(where: { item in
            components.queryItems?.contains(where: {
                $0.name == item.key.rawValue && $0.value == item.value
            }) == false
        })
            
        XCTAssertFalse(containsUnexpectedResults || containsNonMatchedItems)
    }
    
    // MARK: - Private
    
    private func buildSampleUrlSchemes() -> [URL] {
        builder.buildUrlSchemes(with: .stub)
    }
    
    private func buildSampleUrlComponents() -> [URLComponents] {
        buildSampleUrlSchemes().map {
            URLComponents(
                url: $0,
                resolvingAgainstBaseURL: true
            )!
        }
    }
}
