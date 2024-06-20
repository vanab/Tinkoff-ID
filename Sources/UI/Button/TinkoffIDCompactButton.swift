//
//  TinkoffIDRoundButton.swift
//  TinkoffID
//
//  Copyright (c) 2022 Tinkoff
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

final class TinkoffIDCompactButton: UIButton {

    /// Высота кнопки
    private var size: CGFloat { 56 }
    
    /// Изображение
    private var image: UIImage? {
        Bundle.resourcesBundle?
            .imageNamed("idLogoL")
    }
    private lazy var imageBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()

    private let colorStyle: TinkoffIDButtonColorStyle
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearanceForCurrentState()
        }
    }
    
    init(colorStyle: TinkoffIDButtonColorStyle) {
        self.colorStyle = colorStyle
        
        super.init(frame: .zero)

        didInitialize()
    }
    
    required init?(coder: NSCoder) {
        self.colorStyle = .primary
        
        super.init(coder: coder)
        didInitialize()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: size, height: size)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2

        let maxSide = max(bounds.width, bounds.height)
        if maxSide > size {
            updateInsets()
        }

        if case .light = colorStyle {
            self.layer.borderColor = colorStyle.borderColor.cgColor
            self.layer.borderWidth = 1
        }

        if case .dark = colorStyle {
            addOutsetImageBorder()
        }
    }

    // MARK: - Private
    
    private func didInitialize() {
        configure()
        updateAppearanceForCurrentState()
    }
    
    private func configure() {

        // Image
        imageView?.contentMode = .scaleAspectFit
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill

        contentEdgeInsets = UIEdgeInsets(top: 18, left: 9, bottom: 18, right: 9)

        addSubview(imageBorder)
    }
    
    private func updateAppearanceForCurrentState() {
        backgroundColor = colorStyle.backgroundColorFor(state: state)
    }

    private func updateInsets() {
        let scaleFactorVertical: CGFloat = 18/size
        let scaleFactorHorizontal: CGFloat = 9/size
        contentEdgeInsets = UIEdgeInsets(
            top: (bounds.height * scaleFactorVertical),
            left: (bounds.width * scaleFactorHorizontal),
            bottom: (bounds.height * scaleFactorVertical),
            right: (bounds.width * scaleFactorHorizontal)
        )
    }


    private func addOutsetImageBorder() {
        imageBorder.frame.size = CGSize(
            width: imageView!.frame.width + 2 * 2,
            height: imageView!.frame.height + 2 * 2
        )
        imageBorder.center = imageView!.center
        imageBorder.layer.cornerRadius = imageBorder.frame.height/2
    }
}
