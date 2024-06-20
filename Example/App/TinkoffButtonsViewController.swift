//
//  UIViewController.swift
//  TinkoffIDExample
//
//  Created by Margarita Shishkina on 14.07.2022.
//  Copyright © 2022 Tinkoff. All rights reserved.
//

import UIKit
import TinkoffID

final class TinkoffButtonsViewController: UIViewController {

    // MARK: - UI

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.contentInset = .init(top: 16, left: 0, bottom: 300, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    // screen controls
    private let controlsContainer = UIStackView()
    private let normalButtonControlsContainer = UIStackView()
    private let normalButtonCustomSizeContainer = UIStackView()
    private let normalButtonCustomRadiusContainer = UIStackView()
    private let normalButtonBadgeSettingsContainer = UIStackView()

    private let compactButtonControlsContainer = UIStackView()

    // button content view
    private let contentContainer: UIView = .init()
    private var buttonView: UIControl?

    // MARK: - Properties

    // Controls Options
    private var selectedKindOption = KindOption.normal {
        didSet { updateControlsByKind() }
    }
    private var cornerRadiusOption = RadiusOption.default
    private var badgeStyleOption = BadgeOption.default
    private var selectedSizeOption = SizeOption.medium
    private var selectedColorStyleOption = ColorStyleOption.primary

    // Button Configuration
    private var advancedTitleText: String? {
        didSet { updateButton() }
    }
    private var cornerRadius: CGFloat? {
        didSet { updateButton() }
    }
    private var selectedSize: TinkoffIDButtonSize = .medium {
        didSet { updateButton() }
    }
    private var selectedColorStyle: TinkoffIDButtonColorStyle = .primary {
        didSet { updateButton() }
    }
    private var badgeStyle: BadgeStyle? = nil {
        didSet { updateButton() }
    }

    private var customNormalButtonHeight: SizeStyle = .fixed
    private var customNormalButtonWidth: SizeStyle = .fixed
    private var customCompactButtonSize: SizeStyle = .fixed

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        scrollView.addSubview(controlsContainer)
        controlsContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.leading.equalTo(scrollView.contentLayoutGuide)
            make.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        controlsContainer.axis = .vertical
        controlsContainer.spacing = 10
        controlsContainer.distribution = .equalSpacing

        scrollView.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(controlsContainer.snp.bottom).offset(20)
            make.leading.equalTo(scrollView.contentLayoutGuide)
            make.trailing.equalTo(scrollView.contentLayoutGuide)
            make.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(150)
        }
        contentContainer.layer.borderWidth = 1
        contentContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        contentContainer.layer.cornerRadius = 12

        configureCommonControls()
        configureNormalButtonControls()
        configureCompactButtonControls()
        updateControlsByKind()
        updateButton()
    }

    private func configureCommonControls() {
        configureKindSegmentControl()
        configureStyleSegmentControl()
    }

    private func updateControlsByKind() {
        switch selectedKindOption {
        case .normal:
            normalButtonControlsContainer.isHidden = false
            compactButtonControlsContainer.isHidden = true
        case .compact:
            normalButtonControlsContainer.isHidden = true
            compactButtonControlsContainer.isHidden = false
        }
    }

    private func configureNormalButtonControls() {
        controlsContainer.addArrangedSubview(normalButtonControlsContainer)
        normalButtonControlsContainer.axis = .vertical
        normalButtonControlsContainer.spacing = 10
        normalButtonControlsContainer.distribution = .equalSpacing

        configureTitleTextField()
        configureSizeSegmentControl()

        normalButtonControlsContainer.addArrangedSubview(normalButtonCustomSizeContainer)
        normalButtonCustomSizeContainer.axis = .horizontal
        normalButtonCustomSizeContainer.spacing = 20
        normalButtonCustomSizeContainer.distribution = .fillEqually

        configureNormalButtonCornerRadiusSegmentControl()
        normalButtonControlsContainer.addArrangedSubview(normalButtonCustomRadiusContainer)
        normalButtonCustomRadiusContainer.axis = .vertical
        normalButtonCustomRadiusContainer.spacing = 10
        normalButtonCustomRadiusContainer.distribution = .equalSpacing

        configureNormalButtonBadgeSegmentControl()
        normalButtonControlsContainer.addArrangedSubview(normalButtonBadgeSettingsContainer)
        normalButtonBadgeSettingsContainer.axis = .horizontal
        normalButtonBadgeSettingsContainer.spacing = 20
        normalButtonBadgeSettingsContainer.distribution = .fillEqually
    }

    private func configureCompactButtonControls() {
        controlsContainer.addArrangedSubview(compactButtonControlsContainer)
        compactButtonControlsContainer.axis = .vertical
        compactButtonControlsContainer.spacing = 10
        compactButtonControlsContainer.distribution = .equalSpacing

        configureCompactButtonSizeSliderView()
    }
}

// MARK: - UITextFieldDelegate

extension TinkoffButtonsViewController: UITextFieldDelegate {

    enum TextFieldIdentifier: Int {
        case titleTextField = 121
        case badgeTextField = 122
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        if let replacementRange = Range(range, in: currentText) {

            let finalText = currentText.replacingCharacters(in: replacementRange, with: string)

            switch TextFieldIdentifier(rawValue: textField.tag) {
            case .titleTextField:
                advancedTitleText = finalText

            case .badgeTextField:
                switch badgeStyleOption {
                case .default:
                    badgeStyle = nil
                case .until:
                    if let double = Double(finalText) {
                        badgeStyle = .until(value: CGFloat(double))
                    }
                case .empty:
                    if let double = Double(finalText) {
                        badgeStyle = .empty(value: CGFloat(double))
                    }
                }
            default:
                break
            }
        }
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        advancedTitleText = nil
        resignFirstResponder()
        return true
    }
}

// MARK: - Control Actions

private extension TinkoffButtonsViewController {

    // MARK: - Common Button Configuration Controls

    // MARK: Kind Control

    func configureKindSegmentControl() {
        let buttonKindSegment = UISegmentedControl(items: KindOption.allCases.map { $0.name })
        buttonKindSegment.addTarget(self, action: #selector(buttonKindSegmentedControlValueChanged(_:)), for: .valueChanged)
        buttonKindSegment.selectedSegmentIndex = selectedKindOption.rawValue
        controlsContainer.addArrangedSubview(buttonKindSegment)
    }

    @objc func buttonKindSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let kindOption = KindOption(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        selectedKindOption = kindOption
        updateButton()
    }

    // MARK: Design Style Control

    func configureStyleSegmentControl() {
        let styleSegment = UISegmentedControl(items: ColorStyleOption.allCases.map { $0.name })
        styleSegment.addTarget(self, action: #selector(styleSegmentedControlValueChanged(_:)), for: .valueChanged)
        styleSegment.selectedSegmentIndex = selectedColorStyleOption.rawValue
        controlsContainer.addArrangedSubview(styleSegment)
    }

    @objc func styleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch ColorStyleOption(rawValue: sender.selectedSegmentIndex) {
        case .primary:
            selectedColorStyleOption = .primary
            selectedColorStyle = .primary
        case .light:
            selectedColorStyleOption = .light
            selectedColorStyle = .light
        case .alternativeLight:
            selectedColorStyleOption = .alternativeLight
            selectedColorStyle = .alternativeLight
        case .dark:
            selectedColorStyleOption = .dark
            selectedColorStyle = .dark
        default:
            break
        }
    }

    // MARK: - Normal Button Configuration Controls

    // MARK: Text Field

    func configureTitleTextField() {
        let textField = UITextField()
        textField.text = nil
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.returnKeyType = .next
        textField.placeholder = "Введите текст для кнопки..."
        textField.tag = TextFieldIdentifier.titleTextField.rawValue
        normalButtonControlsContainer.addArrangedSubview(textField)
    }

    // MARK: Size Control

    func configureSizeSegmentControl() {
        let sizeSegment = UISegmentedControl(items: SizeOption.allCases.map { $0.name })
        sizeSegment.addTarget(self, action: #selector(sizeSegmentedControlValueChanged(_:)), for: .valueChanged)
        sizeSegment.selectedSegmentIndex = selectedSizeOption.rawValue
        sizeSegment.sendActions(for: .valueChanged)
        normalButtonControlsContainer.addArrangedSubview(sizeSegment)
    }

    @objc func sizeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch SizeOption(rawValue: sender.selectedSegmentIndex) {
        case .small:
            clearNormalButtonCustomSizeSliders()
            selectedSizeOption = .small
            selectedSize = .small
        case .medium:
            clearNormalButtonCustomSizeSliders()
            selectedSizeOption = .medium
            selectedSize = .medium
        case .large:
            clearNormalButtonCustomSizeSliders()
            selectedSizeOption = .large
            selectedSize = .large
        case .custom:
            selectedSizeOption = .custom
            configureNormalButtonCustomSizeSliders()
            updateButton()
        default:
            break
        }
    }

    func configureNormalButtonCustomSizeSliders() {
        configureHeightSizeSliderView()
        configureWidthSizeSliderView()
    }

    func clearNormalButtonCustomSizeSliders() {
        customNormalButtonWidth = .fixed
        customNormalButtonHeight = .fixed
        normalButtonCustomSizeContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // Custom Height Size Control

    func configureHeightSizeSliderView() {
        let slider = UISlider()
        slider.minimumValue = 30
        slider.maximumValue = 120
        slider.addTarget(self, action: #selector(heightSizeSliderValueChanged(_:)), for: .valueChanged)
        slider.value = Float(buttonView?.frame.height ?? 0)
        normalButtonCustomSizeContainer.addArrangedSubview(slider)
    }

    @objc func heightSizeSliderValueChanged(_ sender: UISlider) {
        customNormalButtonHeight = .custom(CGFloat(sender.value))
        if let buttonView {
            updateButtonConstraints(for: buttonView, customHeight: customNormalButtonHeight, customWidth: customNormalButtonWidth)
            buttonView.layoutIfNeeded()
        }
    }

    // Custom Width Size Control

    func configureWidthSizeSliderView() {
        let slider = UISlider()
        slider.minimumValue = 120
        slider.maximumValue = 375
        slider.addTarget(self, action: #selector(widthSizeSliderValueChanged(_:)), for: .valueChanged)
        slider.value = Float(buttonView?.frame.width ?? 0)
        normalButtonCustomSizeContainer.addArrangedSubview(slider)
    }

    @objc func widthSizeSliderValueChanged(_ sender: UISlider) {
        customNormalButtonWidth = .custom(CGFloat(sender.value))
        if let buttonView {
            updateButtonConstraints(for: buttonView, customHeight: customNormalButtonHeight, customWidth: customNormalButtonWidth)
            buttonView.layoutIfNeeded()
        }
    }

    // MARK: - Corner Radius

    func configureNormalButtonCornerRadiusSegmentControl() {
        let sizeSegment = UISegmentedControl(items: RadiusOption.allCases.map { $0.name })
        sizeSegment.addTarget(self, action: #selector(cornerRadiusSegmentedControlValueChanged(_:)), for: .valueChanged)
        sizeSegment.selectedSegmentIndex = RadiusOption.default.rawValue
        sizeSegment.sendActions(for: .valueChanged)
        normalButtonControlsContainer.addArrangedSubview(sizeSegment)
    }

    @objc func cornerRadiusSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch RadiusOption(rawValue: sender.selectedSegmentIndex) {
        case .default:
            cornerRadiusOption = .default
            clearCornerRadiusSliderView()
            cornerRadius = nil
        case .custom:
            cornerRadiusOption = .custom
            configureCornerRadiusSliderView()
        default:
            break
        }
    }

    func configureCornerRadiusSliderView() {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(cornerRadiusSliderValueChanged(_:)), for: .valueChanged)
        slider.value = 8
        slider.sendActions(for: .valueChanged)
        normalButtonCustomRadiusContainer.addArrangedSubview(slider)
    }

    @objc func cornerRadiusSliderValueChanged(_ sender: UISlider) {
        cornerRadius = CGFloat(sender.value)
    }

    func clearCornerRadiusSliderView() {
        normalButtonCustomRadiusContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Badge Settings

    func configureNormalButtonBadgeSegmentControl() {
        let sizeSegment = UISegmentedControl(items: BadgeOption.allCases.map { $0.name })
        sizeSegment.addTarget(self, action: #selector(badgeSegmentedControlValueChanged(_:)), for: .valueChanged)
        sizeSegment.selectedSegmentIndex = BadgeOption.default.rawValue
        sizeSegment.sendActions(for: .valueChanged)
        normalButtonControlsContainer.addArrangedSubview(sizeSegment)
    }

    @objc func badgeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch BadgeOption(rawValue: sender.selectedSegmentIndex) {
        case .default:
            badgeStyleOption = .default
            clearBadgeSliderView()
            badgeStyle = nil
        case .until:
            badgeStyleOption = .until
            clearBadgeSliderView()
            configureBadgeValueTextField()
            badgeStyle = .until(value: 5)
        case .empty:
            badgeStyleOption = .empty
            clearBadgeSliderView()
            configureBadgeValueTextField()
            badgeStyle = .empty(value: 5)
        default:
            break
        }
    }

    func configureBadgeValueTextField() {
        let textField = UITextField()
        textField.text = "5"
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.keyboardType = .numberPad
        textField.returnKeyType = .next
        textField.placeholder = "Введите процент кэшбэка..."
        textField.tag = TextFieldIdentifier.badgeTextField.rawValue
        normalButtonBadgeSettingsContainer.addArrangedSubview(textField)
    }

    func clearBadgeSliderView() {
        normalButtonBadgeSettingsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Compact Button Configuration Controls

    // MARK: Custom Size Compact Buttton

    func configureCompactButtonSizeSliderView() {
        let slider = UISlider()
        slider.minimumValue = 56
        slider.maximumValue = 150
        slider.addTarget(self, action: #selector(compactSizeSliderValueChanged(_:)), for: .valueChanged)
        slider.value = Float(56)
        compactButtonControlsContainer.addArrangedSubview(slider)
    }

    @objc func compactSizeSliderValueChanged(_ sender: UISlider) {
        customCompactButtonSize = .custom(CGFloat(sender.value))
        if let buttonView {
            updateButtonConstraints(for: buttonView, customHeight: customCompactButtonSize, customWidth: customCompactButtonSize)
            buttonView.layoutIfNeeded()
        }
    }
}

// MARK: - Update Helpers

private extension TinkoffButtonsViewController {

    private func updateButton() {
        switch selectedKindOption {
        case .normal:
            updateNormalButton()
        case .compact:
            updateCompactButton()
        }
    }

    private func updateNormalButton() {
        let button = TinkoffIDButtonBuilder.build(
            configuration: TinkoffIDButtonConfiguration(
                style: selectedColorStyle,
                size: selectedSize,
                cornerRadius: cornerRadius
            ),
            title: advancedTitleText,
            badge: badgeStyle
        )
        self.reconfigureButton(to: button)
        self.updateButtonConstraints(for: button, customHeight: customNormalButtonHeight, customWidth: customNormalButtonWidth)
        self.buttonView = button
    }

    private func updateCompactButton() {
        let button = TinkoffIDButtonBuilder.buildCompact(colorStyle: selectedColorStyle)
        self.reconfigureButton(to: button)
        self.updateButtonConstraints(for: button, customHeight: customCompactButtonSize, customWidth: customCompactButtonSize)
        self.buttonView = button
    }

    private func reconfigureButton(to control: UIControl) {
        contentContainer.subviews.forEach { $0.removeFromSuperview() }
        contentContainer.addSubview(control)
    }

    private func updateButtonConstraints(
        for control: UIControl,
        customHeight: SizeStyle = .fixed,
        customWidth: SizeStyle = .fixed
    ) {
        control.snp.remakeConstraints { make in
            make.center.equalTo(contentContainer)
            if case let .custom(height) = customHeight {
                make.height.equalTo(height)
            }
            if case let .custom(width) = customWidth {
                make.width.equalTo(width)
            }
        }
    }
}

// MARK: Types

fileprivate extension TinkoffButtonsViewController {

    enum KindOption: Int, CaseIterable {
        case normal, compact

        var name: String {
            switch self {
            case .normal: "Normal"
            case .compact: "Compact"
            }
        }
    }

    enum SizeOption: Int, CaseIterable {
        case small, medium, large, custom

        var name: String {
            switch self {
            case .small: "Small"
            case .medium: "Medium"
            case .large: "Large"
            case .custom: "Custom"
            }
        }
    }

    enum ColorStyleOption: Int, CaseIterable {
        case primary, light, alternativeLight, dark

        var name: String {
            switch self {
            case .primary: "Primary"
            case .light: "Light"
            case .alternativeLight: "Alternative Light"
            case .dark: "Dark"
            }
        }
    }

    enum RadiusOption: Int, CaseIterable {
        case `default`, custom

        var name: String {
            switch self {
            case .default: "Default Radius"
            case .custom: "Custom Radius"
            }
        }
    }

    enum BadgeOption: Int, CaseIterable {
        case `default`, until, empty

        var name: String {
            switch self {
            case .default: "No badge"
            case .until: "До X%"
            case .empty: "X%"
            }
        }
    }

    enum FontOption {
        case `default`, thirdParty, custom

        var name: String {
            switch self {
            case .default: "Default"
            case .thirdParty: "Third Party"
            case .custom: "Custom Size"
            }
        }
    }

    enum SizeStyle {
        case fixed
        case custom(CGFloat)
    }
}
