//
//  HabitsDetailViewController.swift
//  Tracker
//
//  Created by Максим Жуин on 16.10.2023.
//

import UIKit

class HabitsDetailViewController: UIViewController {

    // MARK: -Properties

    var selectedHabit: Habit?

    private lazy var tableTitle: UILabel = {
        let tableTitle = UILabel()
        tableTitle.translatesAutoresizingMaskIntoConstraints = false
        tableTitle.font = UIFont.systemFont(ofSize: 13)
        tableTitle.textColor = .systemGray2
        tableTitle.text = "АКТИВНОСТЬ"
        return tableTitle
    }()

    private lazy var uiTableView: UITableView = {
        let uitableView = UITableView()
        uitableView.translatesAutoresizingMaskIntoConstraints = false
        uitableView.register(HabitTableViewCell.self, forCellReuseIdentifier: HabitTableViewCell.id)
        uitableView.isScrollEnabled = false
        uitableView.rowHeight = UITableView.automaticDimension
        uitableView.estimatedRowHeight = 60
        uitableView.backgroundColor = .clear
        return uitableView
    }()

    // MARK: -LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if deleteButtonPressed == .yes {
            navigationController?.popViewController(animated: true)
        }
        navigationController?.navigationBar.prefersLargeTitles = false
        deleteButtonPressed = .no
        uiTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainBackgroundColor
        navigationController?.navigationBar.tintColor = purpleUIColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain , target: self, action: #selector(editButtonTapped(_:)))
        setupUI()
    }

    // MARK: -Functions

    func setupUI() {
        uiTableView.delegate = self
        uiTableView.dataSource = self
        view.addSubview(uiTableView)
        view.addSubview(tableTitle)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            tableTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),

            uiTableView.topAnchor.constraint(equalTo: tableTitle.bottomAnchor, constant: 10),
            uiTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            uiTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            uiTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let habitVC = HabitViewController()
        state = .edit
        habitVC.selectedHabit = self.selectedHabit
        habitVC.completionHandler = { [weak self] habit in
            self?.title = habit.name
        }
        let navigationVC = UINavigationController(rootViewController: habitVC)
        navigationVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navigationVC, animated: true)
    }

    func configure(with habit: Habit) {
        self.selectedHabit = habit
        self.title = habit.name
    }
}

extension HabitsDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitTableViewCell.id, for: indexPath) as? HabitTableViewCell else { return UITableViewCell() }
        let dataSource = HabitsStore.shared.dates[indexPath.row]
        if let selectedHabit = selectedHabit {
            cell.configure(with: dataSource, and: selectedHabit)
            if HabitsStore.shared.habit(selectedHabit, isTrackedIn: dataSource) {
                cell.accessoryType = .checkmark
                cell.tintColor = purpleUIColor
            }
        }
        return cell
    }
}
