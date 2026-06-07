//
//  CategoryEditViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.06.2026.
//

import UIKit

final class CategoryEditViewController: UIViewController {

    enum Mode {
        case create
        case edit(title: String)

        var screenTitle: String {
            switch self {
            case .create:
                return "Новая категория"
            case .edit:
                return "Редактирование категории"
            }
        }

        var buttonTitle: String {
            switch self {
            case .create:
                return "Готово"
            case .edit:
                return "Сохранить"
            }
        }
    }

    var onSave: ((String) -> Void)?

    private let mode: Mode

    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .backgroundDayIOS
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(mode.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .grayIOS
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTextField()
        setupButton()
        setupKeyboard()

        textField.becomeFirstResponder()
        updateButtonState()
        
        textField.delegate = self
    }

    private func setupView() {
        title = mode.screenTitle
        view.backgroundColor = .backgroundColorIOS
    }

    private func setupTextField() {
        view.addSubview(textField)

        if case let .edit(title) = mode {
            textField.text = title
        }

        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    private func setupButton() {
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func textFieldChanged() {
        updateButtonState()
    }

    private func updateButtonState() {
        let hasText = !(textField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty

        doneButton.isEnabled = hasText
        doneButton.backgroundColor = hasText ? .blackDayIOS : .grayIOS
    }

    @objc private func doneButtonTapped() {
        let title = textField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !title.isEmpty else { return }

        onSave?(title)
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapView() {
        view.endEditing(true)
    }
}
