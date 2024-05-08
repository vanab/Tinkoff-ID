//
//  UIViewController.swift
//  TinkoffIDExample
//
//  Created by Margarita Shishkina on 14.07.2022.
//  Copyright © 2022 Tinkoff. All rights reserved.
//

import UIKit
import TinkoffID

class TinkoffButtonsViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        setupButtons()
    }

    private func setupButtons() {
        let buttonSmallDark = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(style: .dark, size: .small)
        )
        stackView.addArrangedSubview(createLabel(with: "Small, black"))
        stackView.addArrangedSubview(buttonSmallDark)
        stackView.setCustomSpacing(15, after: buttonSmallDark)

        let buttonSmall = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(),
            title: "Войти с "
        )
        stackView.addArrangedSubview(createLabel(with: "Small, custom title"))
        stackView.addArrangedSubview(buttonSmall)
        stackView.setCustomSpacing(15, after: buttonSmall)

        let buttonMedium = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(style: .alternativeLight, size: .medium)
        )
        stackView.addArrangedSubview(createLabel(with: "Medium, gray"))
        stackView.addArrangedSubview(buttonMedium)
        stackView.setCustomSpacing(15, after: buttonMedium)

        let whiteMedium = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(style: .light, size: .medium)
        )
        stackView.addArrangedSubview(createLabel(with: "Medium, white"))
        stackView.addArrangedSubview(whiteMedium)
        stackView.setCustomSpacing(15, after: whiteMedium)

        let buttonLarge = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(
                style: .dark,
                size: .large,
                font: UIFont(name: "Noteworthy", size: 15)!
            ),
            title: "Войти с "
        )

        stackView.addArrangedSubview(createLabel(with: "Large, black, custom font"))
        stackView.addArrangedSubview(buttonLarge)
        stackView.setCustomSpacing(15, after: buttonLarge)

        let buttonSmallBadge = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(size: .small),
            badge: .empty(value: 5)
        )
        stackView.addArrangedSubview(createLabel(with: "Small, badge"))
        stackView.addArrangedSubview(buttonSmallBadge)
        stackView.setCustomSpacing(15, after: buttonSmallBadge)

        let buttonCustomSizeBadge = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(style: .alternativeLight, cornerRadius: 20),
            badge: .empty(value: 5.20)
        )
        stackView.addArrangedSubview(createLabel(with: "Custom size, badge, gray, corner radius 20"))
        stackView.addArrangedSubview(buttonCustomSizeBadge)
        stackView.setCustomSpacing(15, after: buttonCustomSizeBadge)
        buttonCustomSizeBadge.heightAnchor.constraint(equalToConstant: 80).isActive = true
        buttonCustomSizeBadge.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true

        let buttonBadge = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(style: .light),
            badge: .until(value: 5.15)
        )
        stackView.addArrangedSubview(createLabel(with: "badge, white"))
        stackView.addArrangedSubview(buttonBadge)
        stackView.setCustomSpacing(15, after: buttonBadge)

        let compactButton = TinkoffIDButtonBuilder.buildCompact()
        stackView.addArrangedSubview(createLabel(with: "Compact button"))
        stackView.addArrangedSubview(compactButton)
        stackView.setCustomSpacing(15, after: compactButton)

        let compactButtonLight = TinkoffIDButtonBuilder.buildCompact(colorStyle: .light)
        stackView.addArrangedSubview(createLabel(with: "Compact button, white, custom size"))
        stackView.addArrangedSubview(compactButtonLight)
        compactButtonLight.heightAnchor.constraint(equalToConstant: 70).isActive = true
        compactButtonLight.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }

    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = text
        return label
    }
}
