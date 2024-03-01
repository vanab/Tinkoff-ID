//
//  MockedURLSchemeBuilder.swift
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

import Foundation
@testable import TinkoffID

final class MockedURLSchemeBuilder: IURLSchemeBuilder {
    
    var nextBuildUrlSchemeResult: [URL]!
    var lastOptions: AppLaunchOptions?
    
    func buildUrlSchemes(with options: AppLaunchOptions) -> [URL] {
        lastOptions = options
        
        defer {
            nextBuildUrlSchemeResult = nil
        }
        
        return nextBuildUrlSchemeResult
    }
}
