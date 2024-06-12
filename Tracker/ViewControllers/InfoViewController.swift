//
//  InfoViewController.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: -Properties

    var textFieldsArray = [UILabel]()
    let sampleText = Text().makeArray()

    private lazy var uiScrollView: UIScrollView = {
            let uiScrollView = UIScrollView(frame: .zero)
            uiScrollView.translatesAutoresizingMaskIntoConstraints = false
            uiScrollView.isScrollEnabled = true
            uiScrollView.showsVerticalScrollIndicator = true
            uiScrollView.backgroundColor = .systemBackground
            uiScrollView.contentSize = CGSize(width: view.frame.width, height: 120)
            return uiScrollView
        }()

    private lazy var textLabelView: UIStackView = {
            let textLabelView = UIStackView(frame: .zero)
            textLabelView.translatesAutoresizingMaskIntoConstraints = false
            textLabelView.distribution = .fillProportionally
            textLabelView.spacing = 12.0
            textLabelView.axis = .vertical
            return textLabelView
        }()

        private lazy var titleText: UILabel =  {
            let titleText = UILabel()
            titleText.translatesAutoresizingMaskIntoConstraints = false
            let uifontWeight = UIFont.Weight.semibold
            titleText.text = "Привычка за 21 день"
            titleText.textColor = .black
            titleText.font = UIFont.systemFont(ofSize: 20, weight: uifontWeight)
            return titleText
        }()

    // MARK: -LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        title = "Информация"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: -Functions

    private func setupUI(){
        view.addSubview(titleText)
        view.addSubview(uiScrollView)
        uiScrollView.addSubview(textLabelView)
        let safeArea = view.safeAreaLayoutGuide
            createTextFields()
            addSampleText()
            layoutLabels()

            NSLayoutConstraint.activate([
                titleText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
                titleText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -141),
                titleText.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 22),

                uiScrollView.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 16),
                uiScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                uiScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
                uiScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),

                textLabelView.topAnchor.constraint(equalTo: uiScrollView.topAnchor, constant: 16),
                textLabelView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
                textLabelView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
                textLabelView.bottomAnchor.constraint(equalTo: uiScrollView.bottomAnchor, constant: -16)
            ])
        }

        private func createTextFields() {
            for _ in 0...6 {
                let textField = UILabel()
                textField.numberOfLines = 0
                textFieldsArray.append(textField)
            }
        }

        private func addSampleText() {
            for (index, text) in sampleText.enumerated() {
                textFieldsArray[index].text = text.text0
            }
        }

        private func layoutLabels() {
            let labelWidth: CGFloat = view.frame.width
            let labelHeight: CGFloat = 300
            let labelSpacing: CGFloat = 12
            var xOffset: CGFloat = 0

            for (_, label) in textFieldsArray.enumerated() {
                label.frame = CGRect(x: 0, y: xOffset, width: labelWidth, height: labelHeight)
                xOffset += labelHeight + labelSpacing
                textLabelView.addArrangedSubview(label)
            }
        }
    }

