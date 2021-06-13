//
//  ViewController.swift
//  MyCars
//
//  Created by Sabir Myrzaev on 13.06.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //var context: NSManagedObjectContext!
    var selectedCar: Car!
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // идет проверка если есть данные в Core Data или нет
        getDataFromFile()
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        // текущая марка авто это и есть заголовок 0 segmentedControl
        let mark = segmentedControl.titleForSegment(at: 0)
        // используем предикат, для получения авто
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)

        do {
            let results = try context.fetch(fetchRequest)
            // получили данные об авто
            selectedCar = results[0]
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func insertDataFrom(selectedCar: Car) {
        // извлекаем элементы интерфейса
        carImageView.image = UIImage(data: selectedCar.imageData!)
        
        markLabel.text = selectedCar.mark
        modelLabel.text = selectedCar.model
        myChoiceImageView.isHidden = !(selectedCar.myChoice)
        ratingLabel.text = "Rating: \(selectedCar.rating) / 10.0"
        numberOfTripsLabel.text = "Number of trips: \(selectedCar.timesDriven)"
        
        // позволяет отобразить дату в текстовом формате
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        lastTimeStartedLabel.text = "Last time started: \(df.string(from: selectedCar.lastStarted! as Date))"
        segmentedControl.tintColor = selectedCar.tintColor as? UIColor
    }
    
    // получаем данные из plist
    func getDataFromFile() {
        // создаем запрос и указываем его предикат
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        // проверяем количество записей в core data
        var records = 0
        
        // пытаемся извлечь записи по запросу
        do {
            let count = try context.count(for: fetchRequest)
            records = count
            print("data is there already?")
        } catch {
            print(error.localizedDescription)
        }
        // проверяем количество записей
        guard records == 0 else { return }
        
        // находим путь к нашему файлу
        let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist")
        // создаем массив из контента этого файла
        let dataArray = NSArray(contentsOfFile: pathToFile!)!
        
        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            
            // извлекаем значения
            let carDictionary = dictionary as! NSDictionary
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as? NSNumber as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as? NSNumber as! Int16
            car.myChoice = carDictionary["myChoice"] as? NSNumber as! Bool
            
            // трансформируем значение из-за Data
            let imageName = carDictionary["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = image!.pngData()
            car.imageData = imageData as Data?
            
            // так как 3 цвета, используем словарь, чтобы получить конечный цвет
            let colorDictionary = carDictionary["tintColor"] as? NSDictionary
            car.tintColor = getColor(colorDictionary: colorDictionary!)
        }
    }
    
    func getColor(colorDictionary: NSDictionary) -> UIColor {
        let red = colorDictionary["red"] as! NSNumber
        let green = colorDictionary["green"] as! NSNumber
        let blue = colorDictionary["blue"] as! NSNumber
        
        return UIColor(red: CGFloat(red.floatValue)/255, green: CGFloat(green.floatValue)/255, blue: CGFloat(blue.floatValue)/255, alpha: 1.0)
    }
    
    func update(rating: String) {
        selectedCar.rating = Double(rating)!
        
        // сохраняем изменения
        do {
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            let ac = UIAlertController(title: "Wrong value", message: "Wrong input", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        let mark = sender.titleForSegment(at: sender.selectedSegmentIndex)
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        // выбираем марку
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        
        do {
            let results = try context.fetch(fetchRequest)
            selectedCar = results[0]
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - Actions
    @IBAction func startEnginePressed(_ sender: UIButton) {
        // сохраним количество поездок
        let timesDriven = selectedCar.timesDriven
        selectedCar.timesDriven = Int16(timesDriven + 1)
        selectedCar.lastStarted = Date()
        
        // сохраняем изменения
        do {
            try context.save()
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Rate it", message: "Rate this car please", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak self] action in
        
        let textField = ac.textFields?[0]
        self?.update(rating: textField!.text!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        // добавили текстовое поле в ac
        ac.addTextField {
            textField in
            // можно писать с клавиатуры только цифры
            textField.keyboardType = .numberPad
        }
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
}

