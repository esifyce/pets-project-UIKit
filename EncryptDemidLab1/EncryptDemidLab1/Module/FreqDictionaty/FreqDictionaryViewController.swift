//
//  FreqDictionaryViewController.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 11.11.2023.
//

import UIKit
import SnapKit

class FreqDictionaryViewController: UIViewController {
    
    private var graphModel: GraphModel
    let frequencies: [Character: Double] = [
        "а": 0.062, "б": 0.014, "в": 0.038, "г": 0.013, "д": 0.025,
        "е": 0.072, "ё": 0.072, "ж": 0.007, "з": 0.016, "и": 0.062,
        "й": 0.010, "к": 0.028, "л": 0.035, "м": 0.026, "н": 0.053,
        "о": 0.090, "п": 0.023, "р": 0.040, "с": 0.045, "т": 0.053,
        "у": 0.021, "ф": 0.002, "х": 0.009, "ц": 0.004, "ч": 0.012,
        "ш": 0.006, "щ": 0.003, "ы": 0.016, "ь": 0.014, "ъ": 0.014,
        "э": 0.003, "ю": 0.006, "я": 0.018
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Частотный словарь"
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "book.circle"), style: .plain, target: self, action: #selector(didTapBook))
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    init(graphModel: GraphModel) {
        self.graphModel = graphModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBook() {
        let controller = FreqDictionaryViewController(graphModel: .init(graphType: "", frequencyResult: []))
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FreqDictionaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graphModel.frequencyResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let model = graphModel.frequencyResult.sorted(by: { $0.percentage > $1.percentage })[indexPath.row]
        let sortedFrequencies = frequencies.sorted(by: { $0.value > $1.value })[indexPath.row]
        cell.textLabel?.text = "\(sortedFrequencies.key):\(sortedFrequencies.value) - \(model.char):\(String(model.percentage).prefix(6)) - Count:\(model.count)"
        return cell
    }
}

extension FreqDictionaryViewController: UITableViewDelegate {
}
