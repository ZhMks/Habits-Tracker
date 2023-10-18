//
//  TableViewCell.swift
//  Tracker
//
//  Created by Максим Жуин on 16.10.2023.
//

import UIKit


class HabitTableViewCell: UITableViewCell {

    // MARK: -Properties
   static let id = "TableViewCell"

    private lazy var dateString: UILabel = {
        let dateString = UILabel()
        dateString.translatesAutoresizingMaskIntoConstraints = false
        return dateString
    }()

    private lazy var checkmark: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.contentMode = .center
        checkmark.image = UIImage(systemName: "checkmark")
        checkmark.clipsToBounds = true
        checkmark.isHidden = true
        return checkmark
    }()


    // MARK: -LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Functions

    func setupUI() {
        contentView.addSubview(dateString)
        contentView.addSubview(checkmark)
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            dateString.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 11),
            dateString.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            dateString.heightAnchor.constraint(equalToConstant: 22),

            checkmark.centerYAnchor.constraint(equalTo: dateString.centerYAnchor),
            checkmark.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -11)
        ])
    }

    func configure(with dates: Date, and habit: Habit) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ru_RU"
        dateFormatter.dateStyle = .long
        dateString.text = dateFormatter.string(from: dates)

        if HabitsStore.shared.dates.contains(where: { $0 == habit.date }) && HabitsStore.shared.habit(habit, isTrackedIn: habit.date){
                accessoryType = .checkmark
                tintColor = purpleUIColor
            } else {
                return
        }

    }
}

