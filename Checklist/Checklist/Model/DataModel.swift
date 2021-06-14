//
//  DataModel.swift
//  Checklist
//
//  Created by Sabir Myrzaev on 14.06.2021.
//

import Foundation

class DataModel {
    
    var lists = [ChecklistData]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    // этот метод получает текущее значение «ChecklistItemID» UserDefaults, добавляет к нему 1 и записывает обратно в UserDefaults
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID+1, forKey: "ChecklistItemID")
        return itemID
    }
    // MARK: - Load&Save Func
    func saveChecklists() {

        let encoder = PropertyListEncoder()

        do {
            // кодирует массив items который можно записать в файл
            let data = try encoder.encode(lists)
            // записываем данные в файл, используя путь к файлу
            try data.write (to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadChecklists() {
        // помещаем результаты в path
        let path = dataFilePath()
        // пробуем выгрузить данные в новый объект
        if let data = try? Data(contentsOf: path) {
        // если файл Checklists.plist найден, вы загрузите всё в массив и создаем экземпляр декодера
            let decoder = PropertyListDecoder()
            do {
                // загружаем сохранненые данные, первый передаваемый параметр decode
                lists = try decoder.decode([ChecklistData].self, from: data)
                sortChecklists()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - UserDefaults
    func registerDefaults() {
        let dictionary = [
            "ChecklistIndex": -1,
            "FirstTime": true
        ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    // создаем новый Checklistобъект и добавляем его в массив
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = ChecklistData(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    // Метод сравнивает две строки имен, игнорируя при этом нижний регистр против верхнего регистра
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    // MARK: - Путь к папке сохранения
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
}


