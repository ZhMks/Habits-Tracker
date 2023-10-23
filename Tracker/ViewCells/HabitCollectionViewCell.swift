//
//  HabitCollectionViewCell.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {

    // MARK: -Properties

    static let id = "HabitTableCell"
    var selectedHabit: Habit?

    var countNumber: Int = 0

    private lazy var habitTitle: UILabel = {
        let habitTitle = UILabel()
        habitTitle.textColor = .systemBlue
        let fontWeight = UIFont.Weight.semibold
        habitTitle.font = UIFont.systemFont(ofSize: 17, weight: fontWeight)
        habitTitle.translatesAutoresizingMaskIntoConstraints = false
        return habitTitle
    }()

    private lazy var habitText: UILabel = {
        let habitText = UILabel()
        habitText.textColor = .systemGray2
        habitText.text = "Каждый день в 7:30"
        habitText.font = UIFont.systemFont(ofSize: 12)
        habitText.translatesAutoresizingMaskIntoConstraints = false
        return habitText
    }()

    private lazy var counter: UILabel = {
        let counter = UILabel()
        counter.textColor = .systemGray
        counter.text = ""
        counter.font = UIFont.systemFont(ofSize: 13)
        counter.translatesAutoresizingMaskIntoConstraints = false
        return counter
    }()

    lazy var habitColorImageButton: UIButton = {
        let habitColorImage = UIButton()
        habitColorImage.layer.cornerRadius = 18
        habitColorImage.layer.borderWidth = 1
        habitColorImage.clipsToBounds = true
        habitColorImage.translatesAutoresizingMaskIntoConstraints = false
       habitColorImage.addTarget(self, action: #selector(colorImageButtonTapped(_:)), for: .touchUpInside)
        return habitColorImage
    }()

    private var checkmarkImage: UIImageView = {
        let checkmarkImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 4, height: 4))
        checkmarkImage.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImage.image = UIImage(systemName: "checkmark")
        checkmarkImage.tintColor = .white
        return checkmarkImage
    }()

    // MARK: -LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: -Functions

    private func setupUI() {
        contentView.addSubview(habitTitle)
        contentView.addSubview(habitText)
        contentView.addSubview(habitColorImageButton)
        contentView.addSubview(counter)
        contentView.addSubview(checkmarkImage)

        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            habitTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            habitTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            habitTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -103),
            habitTitle.widthAnchor.constraint(equalToConstant: 220),

            habitText.topAnchor.constraint(equalTo: habitTitle.bottomAnchor, constant: 4),
            habitText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            habitText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -68),
            habitText.heightAnchor.constraint(equalToConstant: 16),

            counter.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 92),
            counter.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            counter.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -135),
            counter.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),

            habitColorImageButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 46),
            habitColorImageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -25),
            habitColorImageButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -46),
            habitColorImageButton.widthAnchor.constraint(equalToConstant: 38),
            habitColorImageButton.heightAnchor.constraint(equalToConstant: 38),

            checkmarkImage.centerXAnchor.constraint(equalTo: habitColorImageButton.centerXAnchor),
            checkmarkImage.centerYAnchor.constraint(equalTo: habitColorImageButton.centerYAnchor)
        ])
    }

    func configureWith(_ habit: Habit) {
        habitTitle.text = habit.name
        habitColorImageButton.layer.borderColor = habit.color.cgColor
        habitText.text = habit.dateString
        habitTitle.textColor = habit.color
        self.selectedHabit = habit
        countNumber = habit.trackDates.count
        counter.text = "Счетчик: \(countNumber)"

    }

    @objc func colorImageButtonTapped(_ sender: UIButton) {
        let notification = NotificationCenter.default
        if !selectedHabit!.isAlreadyTakenToday {
            habitColorImageButton.backgroundColor = selectedHabit?.color
            HabitsStore.shared.track(selectedHabit!)
            countNumber += 1
            notification.post(Notification(name: Notification.Name(rawValue: "progress") ))
        }
    }

    func updateStatus() {
        if selectedHabit!.isAlreadyTakenToday {
            habitColorImageButton.backgroundColor = selectedHabit!.color
        }
    }
}
