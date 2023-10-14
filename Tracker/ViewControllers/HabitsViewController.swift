//
//  HabitsViewController.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class HabitsViewController: UIViewController {

    // MARK: -Properties

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var dataSource: [RegisterCells] = []
    private var habitsArray = HabitsStore.shared.habits


    // MARK: -LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(buttonPressed(_:))
        )
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem?.width = 44
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
        title = "Сегодня"
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainBackgroundColor
        navigationController?.navigationBar.isHidden = false
        print(HabitsStore.shared.habits)
        setupModule()
        setupUI()
        setupCollectionView()
    }

    // MARK: -Functions
    @objc func buttonPressed(_ sender: UIBarButtonItem) {
        state = .create
        let habitVC = HabitViewController()
        let navigationVC = UINavigationController(rootViewController: habitVC)
        navigationVC.modalPresentationStyle = .fullScreen
        navigationController!.present(navigationVC, animated: true)
    }

    private func setupUI() {
        view.addSubview(collectionView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 22),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentMode = .center
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 12
        collectionView.backgroundColor = .clear
    }

    private func setupModule() {
        dataSource = [RegisterCells.progressCollectionViewCell]

        for habit in habitsArray {
            dataSource.append(RegisterCells.collectionViewCellWith(habit: habit))
        }
    }

    private func prepareCollectionViewCell(collectionCell: Habit, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.id, for: indexPath) as? HabitCollectionViewCell else { return UICollectionViewCell() }
        cell.configureWith(collectionCell)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        return cell
    }

    private func prepareProgressCollectionViewCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as? ProgressCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        return cell
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = dataSource[indexPath.row]
        switch element {
        case .collectionViewCellWith(habit: let habit): return prepareCollectionViewCell(collectionCell: habit, for: indexPath)
        case .progressCollectionViewCell: return prepareProgressCollectionViewCell(for: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 343, height: 343)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
            } else {
                return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0 )
            }
        }


}
