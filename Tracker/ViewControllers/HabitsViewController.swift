//
//  HabitsViewController.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class HabitsViewController: UIViewController {

    // MARK: -Properties

    let detailVC = HabitsDetailViewController()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()

    private lazy var uiScrollView: UIScrollView = {
        let uiScrollView = UIScrollView()
        uiScrollView.translatesAutoresizingMaskIntoConstraints = false
        uiScrollView.showsVerticalScrollIndicator = true
        uiScrollView.isScrollEnabled = true
        uiScrollView.contentMode = .center
        return uiScrollView
    }()

    private var dataSource: [RegisterCells] = []
    private var habitsArray = HabitsStore.shared.habits

    // MARK: -LifeCycle

      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Сегодня"
        print(HabitsStore.shared.habits)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainBackgroundColor
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(buttonPressed(_:))
        )
        navigationItem.rightBarButtonItem?.width = 44
        navigationItem.rightBarButtonItem?.tintColor = purpleUIColor
        setupModule()
        setupUI()
        setupCollectionView()
        self.collectionView.reloadData()
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
//        view.addSubview(uiScrollView)
//        uiScrollView.addSubview(collectionView)
        view.addSubview(collectionView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 22),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

//            collectionView.topAnchor.constraint(equalTo: uiScrollView.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: uiScrollView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: uiScrollView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: uiScrollView.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        cell.updateStatus()
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
        let element = dataSource[indexPath.row]
        switch element {
        case .collectionViewCellWith(habit: _): return CGSize(width: 343, height: 130)
        case .progressCollectionViewCell: return CGSize(width: 343, height: 60)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
            } else {
                return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0 )
            }
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = dataSource[indexPath.row]
        switch element {
        case .collectionViewCellWith(habit: let habit):
            detailVC.configure(with: habit)
            navigationController?.pushViewController(detailVC, animated: true)
        case .progressCollectionViewCell:
            return
        }
    }
}
