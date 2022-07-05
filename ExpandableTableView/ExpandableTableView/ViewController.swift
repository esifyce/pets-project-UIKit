//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Krasivo on 06.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Property
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    var bool = false
    
    var data = [
        ExpandableData(title: "Артериальное давление", subtitle: "20 - 40 лет 120/70-130/80", description: "Нормальным давлением принято считать АД 120 на 70, 130 на 80. Стабильное повышение АД 140 на 90 даже у пациентов старшего возраста следует рассматривать как верхнюю границу нормы, требующую принятия грамотных врачебных мер.", isExpandable: false),
        ExpandableData(title: "Артериальное давление", subtitle: "20 - 40 лет 120/70-130/80", description: "Нормальным давлением принято считать АД 120 на 70, 130 на 80. Стабильное повышение АД 140 на 90 даже у пациентов старшего возраста следует рассматривать как верхнюю границу нормы, требующую принятия грамотных врачебных мер.", isExpandable: false),
        ExpandableData(title: "Артериальное давление", subtitle: "20 - 40 лет 120/70-130/80", description: "Нормальным давлением принято считать АД 120 на 70, 130 на 80. Стабильное повышение АД 140 на 90 даже у пациентов старшего возраста следует рассматривать как верхнюю границу нормы, требующую принятия грамотных врачебных мер.", isExpandable: false)
    ]
    
    // MARK: - Views

    let tableView: UITableView = {
       let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configure()
    }
    
    private func configure() {
        
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.register(ExpandableCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        setConstraints()
    }
    
    private func setConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExpandableCell
        
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        cell.animate()
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // if selectedIndex == indexPath { return data[indexPath.row].isExpandable ? 200 : 60 }
        return data[indexPath.row].isExpandable ? 200 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data[indexPath.row].isExpandable.toggle()
        selectedIndex = indexPath
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex], with: .none)
        tableView.endUpdates()
    }
}
