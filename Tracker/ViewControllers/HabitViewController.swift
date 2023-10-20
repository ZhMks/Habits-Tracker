//
//  HabitViewController.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class HabitViewController: UIViewController {

    // MARK: -Properties

    var selectedHabit: Habit?

    private var newCreatedHabit = Habit(name: "", date: .now, color: .clear)

    var completionHandler: ((Habit) -> Void)?

    private lazy var textLabel: UILabel = {
        let textPlaceHolder = UILabel()
        textPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        textPlaceHolder.text = "НАЗВАНИЕ"
        let fontWeight = UIFont.Weight.semibold
        textPlaceHolder.textColor = .black
        textPlaceHolder.font = UIFont.systemFont(ofSize: 13, weight: fontWeight)
        return textPlaceHolder
    }()

    private lazy var createHabitNameInput: UITextField = {
        switch state{
        case .create:
            let addTextInput = UITextField()
            addTextInput.translatesAutoresizingMaskIntoConstraints = false
            addTextInput.placeholder = "Каждый день в 8:30 утра"
            addTextInput.font = UIFont.systemFont(ofSize: 13)
            addTextInput.textColor = .systemGray2
            addTextInput.returnKeyType = .done
            addTextInput.addTarget(self, action: #selector(textChangedIn(_:)), for: .allEditingEvents)
            return addTextInput
        case .edit:
            let addTextInput = UITextField()
            addTextInput.translatesAutoresizingMaskIntoConstraints = false
            addTextInput.font = UIFont.boldSystemFont(ofSize: 13)
            addTextInput.textColor = .systemBlue
            let textField = UITextField()
            addTextInput.attributedPlaceholder = NSAttributedString(string: "\(selectedHabit!.name)",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
            addTextInput.returnKeyType = .done
            addTextInput.addTarget(self, action: #selector(textChangedIn(_:)), for: .allEditingEvents)
            return addTextInput
        }
    }()

    private lazy var chooseColorLabel: UILabel = {
        let colorPlaceHolder = UILabel()
        colorPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        colorPlaceHolder.text = "ЦВЕТ"
        let fontWeight = UIFont.Weight.semibold
        colorPlaceHolder.font = UIFont.systemFont(ofSize: 13, weight: fontWeight)
        return colorPlaceHolder
    }()

    private lazy var chooseColorButton: UIButton = {
        switch state {
        case .create:
            let chooseColorView = UIButton(type: .system)
            chooseColorView.translatesAutoresizingMaskIntoConstraints = false
            chooseColorView.backgroundColor = .orange
            chooseColorView.clipsToBounds = true
            chooseColorView.layer.cornerRadius = 16
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorPickerTapped(_:)))
            chooseColorView.addGestureRecognizer(tapGesture)
            return chooseColorView
        case .edit:
            let chooseColorView = UIButton(type: .system)
            chooseColorView.translatesAutoresizingMaskIntoConstraints = false
            chooseColorView.backgroundColor = selectedHabit?.color
            chooseColorView.clipsToBounds = true
            chooseColorView.layer.cornerRadius = 16
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorPickerTapped(_:)))
            chooseColorView.addGestureRecognizer(tapGesture)
            return chooseColorView
        }
    }()

    private lazy var timeTextLabel: UILabel = {
        let timeTextPlaceholder = UILabel()
        timeTextPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        timeTextPlaceholder.text = "ВРЕМЯ"
        let fontWeight = UIFont.Weight.semibold
        timeTextPlaceholder.textColor = .black
        timeTextPlaceholder.font = UIFont.systemFont(ofSize: 13, weight: fontWeight)
        return timeTextPlaceholder
    }()

    private lazy var timeText: UILabel = {
        switch state {
        case .create:
            let timeText = UILabel()
            timeText.translatesAutoresizingMaskIntoConstraints = false
            timeText.textColor = .black
            timeText.font = UIFont.systemFont(ofSize: 13)
            return timeText
        case .edit:
            newCreatedHabit.date = selectedHabit!.date
            let timeText = UILabel()
            timeText.translatesAutoresizingMaskIntoConstraints = false
            timeText.text = "\(selectedHabit!.dateString)"
            timeText.textColor = .black
            timeText.font = UIFont.systemFont(ofSize: 13)
            return timeText
        }
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.addTarget(self, action: #selector(datePickerTimeChanged(_:)), for: .valueChanged)
        return datePicker
    }()

    private lazy var alertButton: UIButton = {
        let alertButton = UIButton(type: .system)
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        alertButton.setTitle("Удалить привычку", for: .normal)
        alertButton.setTitleColor(.red, for: .normal)
        alertButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        alertButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return alertButton
    }()

    // MARK: -LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = mainBackgroundColor
        setupNavigationBar()

    }



    // MARK: -Functions
    private func placeSubviews() {
        view.addSubview(textLabel)
        view.addSubview(createHabitNameInput)
        view.addSubview(chooseColorLabel)
        view.addSubview(chooseColorButton)
        view.addSubview(timeTextLabel)
        view.addSubview(timeText)
        view.addSubview(datePicker)
        view.addSubview(alertButton)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(createButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(abortButtonPressed(_:)))
        let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 17) ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        let leftButtonAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: .normal)
        navigationController?.navigationBar.tintColor = purpleUIColor
        navigationItem.title = state.navTitle
    }

    private func setupUI() {
        placeSubviews()
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 21),
            textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            textLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -176),
            textLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -285),

            createHabitNameInput.heightAnchor.constraint(equalToConstant: 22),
            createHabitNameInput.widthAnchor.constraint(equalToConstant: 295),
            createHabitNameInput.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 7),
            createHabitNameInput.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),

            chooseColorLabel.topAnchor.constraint(equalTo: createHabitNameInput.bottomAnchor, constant: 15),
            chooseColorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            chooseColorLabel.widthAnchor.constraint(equalToConstant: 36),
            chooseColorLabel.heightAnchor.constraint(equalToConstant: 16),

            chooseColorButton.topAnchor.constraint(equalTo: chooseColorLabel.bottomAnchor, constant: 7),
            chooseColorButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            chooseColorButton.widthAnchor.constraint(equalToConstant: 30),

            timeTextLabel.topAnchor.constraint(equalTo: chooseColorButton.bottomAnchor, constant: 15),
            timeTextLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            timeTextLabel.widthAnchor.constraint(equalToConstant: 47),
            timeTextLabel.heightAnchor.constraint(equalToConstant: 18),

            timeText.topAnchor.constraint(equalTo: timeTextLabel.bottomAnchor, constant: 7),
            timeText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            timeText.widthAnchor.constraint(equalToConstant: 194),
            timeText.heightAnchor.constraint(equalToConstant: 22),

            datePicker.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            datePicker.widthAnchor.constraint(equalToConstant: 375),
            datePicker.heightAnchor.constraint(equalToConstant: 216),

            alertButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 219),
            alertButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 114.5),
            alertButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -113.5),
            alertButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    @objc func deleteButtonTapped(_ sender: UIButton) {
        switch state {
        case .create: break
        case .edit:
            let alertController = UIAlertController(title: "Удалить привычку",
                                                    message: "Вы хотите удалить привычку \(selectedHabit!.name)?",
                                                    preferredStyle: .alert)

            let alertActionLeft = UIAlertAction(title: "Отмена", style: .default)
            let alertActionRight = UIAlertAction(title: "Удалить", style: .default, handler: { _ in
                for habit in HabitsStore.shared.habits {
                    if habit.name == self.selectedHabit!.name {
                        HabitsStore.shared.habits.removeAll(where: { $0.name == self.selectedHabit!.name })
                        HabitsStore.shared.save()
                        deleteButtonPressed = .yes
                        self.navigationController!.dismiss(animated: true)
                    }
                }
            })

            alertActionRight.setValue(UIColor.red, forKey: "_titleTextColor")
            alertController.addAction(alertActionLeft)
            alertController.addAction(alertActionRight)
            navigationController?.present(alertController, animated: true)
        }
    }
    @objc func colorPickerTapped(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        navigationController!.present(colorPicker, animated: true)
    }

    @objc func datePickerTimeChanged(_ sender: UIDatePicker) {
        let timeStyle = DateFormatter()
        timeStyle.locale = Locale(identifier: "ru_RU")
        timeStyle.timeStyle = .short
        timeStyle.dateFormat = "HH:mm"

        // Про цвет нашел решение в интернете. Сам так и не понял как сделать строку с атрибутами.
        let attributedWithTextColor: NSAttributedString = "Каждый день в \(timeStyle.string(from: sender.date))".attributedStringWithColor(
            ["\(timeStyle.string(from: sender.date))"], color: purpleUIColor
        )

        timeText.attributedText = attributedWithTextColor
        newCreatedHabit.date = sender.date
    }

    @objc func createButtonPressed(_ sender: UIBarButtonItem) {
        switch state {
        case .create:
            let newHabit = Habit(name: newCreatedHabit.name,
                                 date: newCreatedHabit.date,
                                 color: newCreatedHabit.color)
            HabitsStore.shared.habits.append(newHabit)
            navigationController?.dismiss(animated: true)
        case .edit:
            for habit in HabitsStore.shared.habits {
                if habit.name == selectedHabit?.name {
                    if  newCreatedHabit.name.isEmpty {
                        habit.name =  selectedHabit!.name
                    } else {
                        habit.name = newCreatedHabit.name
                        completionHandler?(habit)
                    }
                    if habit.color == chooseColorButton.backgroundColor {
                        habit.color = selectedHabit!.color
                    } else {
                        habit.color = newCreatedHabit.color

                    }
                    if habit.date == newCreatedHabit.date {
                        habit.date = selectedHabit!.date
                    } else {
                        habit.date = newCreatedHabit.date
                    }
                }
                HabitsStore.shared.save()
                navigationController?.dismiss(animated: true)
            }
        }
    }


    @objc func abortButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
}


// MARK: -Extensions

extension HabitViewController: UIColorPickerViewControllerDelegate, UITextFieldDelegate {

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        newCreatedHabit.color = selectedColor
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        chooseColorButton.backgroundColor = viewController.selectedColor
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textChangedIn(_ textField: UITextField) {
        if let text = textField.text {
            createHabitNameInput.text = text
            newCreatedHabit.name = text
        }
    }
}

