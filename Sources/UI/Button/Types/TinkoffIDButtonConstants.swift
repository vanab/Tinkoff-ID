//
//  TinkoffIDButtonBuilder.swift
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

public enum TinkoffIDButtonConstants {

    public static let defaultTitle = "T-Bank"

    public static let defaultCornerRadius: CGFloat = 8

    public static let defaultColorStyle: TinkoffIDButtonColorStyle = .primary

    public static let defaultTitleFont: UIFont = .systemFont(ofSize: TinkoffIDButtonSize.medium.titleFontSize)

    public static let defaultBadgeFont: UIFont = .systemFont(ofSize: TinkoffIDButtonSize.medium.badgeFontSize)
}
