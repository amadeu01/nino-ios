//
//  RowMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 09/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RowMechanism: NSObject {

    static func getRowsWithID(id: Int) -> [String: AnyObject] {
        switch id {
        case 0:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Lanche da Manhã", "buttons": self.food()]], "description": "No lanche da manhã eu %1.item.", "emptyDescription": ""]
        case 1:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Almoço", "buttons": self.food()]], "description": "No almoço eu %1.item.", "emptyDescription": ""]
        case 2:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Lanche da Tarde", "buttons": self.food()]], "description": "No lanche da tarde eu %1.item.", "emptyDescription": ""]
        case 3:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Jantar", "buttons": self.food()]], "description": "No jantar eu %1.item.", "emptyDescription": ""]
        case 4:
            return ["cells": [["type": CellType.Slider.rawValue, "title": "Mamadeira", "floor": 0, "ceil": 200, "unity": "ml", "image": MyDaySliderIcon.BabyBottles.rawValue]], "description": "Hoje eu mamei %1.count mamadeira(s).<each> Uma de %1.item.</each>", "emptyDescription": "Hoje eu não mamei."]
        case 5:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Quando", "buttons": self.sleep()], ["type": CellType.Slider.rawValue, "title": "Tempo Dormido", "floor": 0, "ceil": 180, "unity": "minutos", "image": MyDaySliderIcon.BabyBottles.rawValue]], "description": "Hoje eu dormi %1.count vez(es).<each> Dormi %2.item durante a %1.item.</each>", "emptyDescription": "Hoje eu não dormi."]
        case 6:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Evacuação", "buttons": self.evacuation()]], "description": "Hoje %1.item.", "emptyDescription": "Hoje não evacuei."]
        case 7:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Troca de Fralda", "buttons": self.diaper()]], "description": "Hoje %1.item.", "emptyDescription": "Hoje não troquei de fralda."]
            //TODO: commentaries cell
//        case 8:
//            return
        default:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": "Lanche da Manhã", "buttons": self.food()]], "description": "No lanche da manhã eu %1.item.", "emptyDescription": ""]
        }
    }
    
    private static func getButton(title: String, preffix: String, suffix: String) -> [String: String] {
        return ["title": title, "preffix": preffix, "suffix": suffix]
    }
    
    private static func food() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton("bem", preffix: "comi ", suffix: ""))
        dict.append(self.getButton("pouco", preffix: "comi ", suffix: ""))
        dict.append(self.getButton("não comi", preffix: "", suffix: ""))
        return dict
    }
    
    private static func evacuation() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton("normal", preffix: "minha evacuação foi ", suffix: ""))
        dict.append(self.getButton("pastosa", preffix: "minha evacuação foi ", suffix: ""))
        dict.append(self.getButton("diarréia", preffix: "eu tive ", suffix: ""))
        return dict
    }
    
    private static func sleep() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton("manhã", preffix: "dormi durante a ", suffix: ""))
        dict.append(self.getButton("meio-dia", preffix: "dormi ao ", suffix: ""))
        dict.append(self.getButton("tarde", preffix: "dormi durante a ", suffix: ""))
        return dict
    }
    
    private static func diaper() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton("1 vez", preffix: "troquei de fralda ", suffix: ""))
        dict.append(self.getButton("2 vezes", preffix: "troquei de fralda ", suffix: ""))
        dict.append(self.getButton("3 ou mais", preffix: "troquei de fralda ", suffix: "vezes"))
        return dict
    }
}
