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

import UIKit

/// Формат текста в бейдже
public enum BadgeStyle {
    /// Формат: "x% кэшбэк"
    case empty(value: CGFloat)
    /// Формат: "до x% кэшбэка"
    case until(value: CGFloat)
}

/// Конфигурация кнопки
public struct TinkoffIDButtonConfiguration {

    /// Стиль кнопки
    let style: TinkoffIDButtonColorStyle
    /// Размер
    let size: TinkoffIDButtonSize
    /// Радиус скругления кнопки
    let cornerRadius: CGFloat
    /// Шрифт текста на кнопке
    let font: UIFont
    /// Шрифт текста на бейдже
    let badgeFont: UIFont

    public init(
        style: TinkoffIDButtonColorStyle = TinkoffIDButtonConstants.defaultColorStyle,
        size: TinkoffIDButtonSize = .medium,
        cornerRadius: CGFloat? = nil,
        font: UIFont? = nil,
        badgeFont: UIFont? = nil
    ) {
        self.style = style
        self.size = size
        self.cornerRadius = cornerRadius ?? TinkoffIDButtonConstants.defaultCornerRadius
        self.font = font ?? TinkoffIDButtonConstants.defaultTitleFont
        self.badgeFont = badgeFont ?? TinkoffIDButtonConstants.defaultBadgeFont
    }
}
