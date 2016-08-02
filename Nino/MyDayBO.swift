//
//  MyDayBO.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Nino. All rights reserved.
//

import UIKit

//Class to handle MyDay services
class MyDayBO: NSObject {
    
    /**
     Gets the cells for the MyDay screen of a given room
     
     - parameter room: The room id
     
     - returns: list of MyDayCell VOs
     */
    static func getCellsForClass(room: Int) -> (left: [MyDayCell], right: [MyDayCell]) {
        return ([alimentationSection()], [sleepSection(), hygieneSection()])
    }
    
    
    private static func alimentationSection() -> MyDayCell {
        var rows: [MyDayRow] = []
        rows.append(MyDayIntensityRow(title: "Lanche da Manhã", strings: ["bem", "pouco", "não comi"], description: "No lanche da manhã eu comi %", emptyDescription: ""))
        rows.append(MyDaySeparatorRow())
        rows.append(MyDayIntensityRow(title: "Almoço", strings: ["bem", "pouco", "não comi"], description: "No almoço eu comi %", emptyDescription: ""))
        rows.append(MyDaySeparatorRow())
        rows.append(MyDayIntensityRow(title: "Lanche da Tarde", strings: ["bem", "pouco", "não comi"], description: "No lanche da tarde eu comi %", emptyDescription: ""))
        rows.append(MyDaySeparatorRow())
        rows.append(MyDayIntensityRow(title: "Janta", strings: ["bem", "pouco", "não comi"], description: "Na janta eu comi %", emptyDescription: ""))
        rows.append(MyDaySeparatorRow())
        rows.append(MyDaySliderRow(title: "Mamadeira", unit: "ml", image: .BabyBottles, floor: 0, ceil: 200, generalDescription: "Hoje eu mamei % mamadeiras", itemDescription: "Elas foram de % mls"))
        
        return MyDayCell(title: "Minha Alimentação", icon: .Food, sections: rows)
    }
    
    private static func sleepSection() -> MyDayCell {
        var rows: [MyDayRow] = []
        rows.append(MyDayIntensityRow(title: "Quando", strings: ["manhã", "meio-dia", "tarde"], description: "Hoje dormi durante a %", emptyDescription: "Hoje não dormi"))
        rows.append(MyDaySliderRow(title: "Quantidade de sono", unit: "minutos", image: .BabyBottles, floor: 0, ceil: 180, generalDescription: "Hoje eu dormi % vezes", itemDescription: "Elas foram de % minutos"))
        return MyDayCell(title: "Meu Sono", icon: .Sleep, sections: rows)
    }
    
    private static func hygieneSection() -> MyDayCell {
        var rows: [MyDayRow] = []
        rows.append(MyDayIntensityRow(title: "Evacuação", strings: ["Normal", "Pastosa", "Diarréia"], description: "Hoje minha evacuação foi %", emptyDescription: "Hoje não evacuei"))
        rows.append(MyDaySeparatorRow())
        rows.append(MyDayIntensityRow(title: "Troca de Fralda", strings: ["1 vez", "2 vezes", "3 ou mais vezes"], description: "Hoje troquei de fralda %", emptyDescription: "Hoje não troquei de fralda"))
        return MyDayCell(title: "Minha Higiene", icon: .Hygiene, sections: rows)
    }
}
