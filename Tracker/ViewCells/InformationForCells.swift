//
//  InformationForCells.swift
//  Tracker
//
//  Created by Максим Жуин on 14.10.2023.
//

//
//  Models.swift
//  HabitsTracker
//
//  Created by Максим Жуин on 05.10.2023.
//

import Foundation
import UIKit


struct Text {

    var text0: String?

    func makeArray() -> [Text] {
        [
            Text(text0: """
            Прохождение этапов, за которые за 21
            день вырабатывается привычка, подчиняется следующему алгоритму:
            """
                ),

            Text(text0: """
1. Провести 1 день без обращения к старым привычкам, стараться вести
себя так, как будто цель, загаданная
в перспективу, находится на расстоянии шага.
"""
                ),
            Text(text0: "2. Выдержать 2 дня в прежнем состоянии самоконтроля."),

            Text(text0: """
3. Отметить в дневнике первую неделю изменений и подвести первые итоги —
что оказалось тяжело, что — легче,
с чем еще предстоит серьезно бороться.
"""
                ),
            Text(text0: """
4. Поздравить себя с прохождением первого серьезного порога в 21 день.
За это время отказ от дурных
наклонностей уже примет форму
осознанного преодоления и
человек сможет больше работать в сторону
принятия положительных качеств.
"""
                ),

            Text(text0: """
            5. Держать планку 40 дней.
            Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.
            """
                ),

            Text(text0: """
6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\n
Источник: psychbook.ru
"""
                )
        ]
    }
}

// Общие цвета
let mainBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
let purpleUIColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
let tabBarMainColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)

// Состояния для переключения вью создания привычки.
enum States {
    case edit
    case create

    var navTitle: String {
        switch self {
        case .edit:
            return "Править"
        case .create:
            return "Создать"
        }
    }
}

enum RegisterCells {
    case progressCollectionViewCell
    case collectionViewCellWith(habit: Habit)
}

// Переменная для показа разных вью
var state: States = .create


// Переключение кнопки "удалить", что
enum DeleteButtonPressed {
    case no
    case yes
}

// Переменная для отслеживания нажатия кнопки
var deleteButtonPressed: DeleteButtonPressed = .no

// Решение с цветом отдельной части строки. Нашел рабочий вариант на стаковерфлоу.
extension String {

    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
