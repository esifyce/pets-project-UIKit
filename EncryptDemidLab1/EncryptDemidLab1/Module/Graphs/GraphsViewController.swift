//
//  GraphsViewController.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 06.10.2023.
//

import UIKit
import DGCharts
import SnapKit

final class GraphsViewController: UIViewController {
    
    // MARK: - Property
    
    private lazy var chartView = {
        LineChartView()
    }()
    
    private var graphModel: GraphModel
    private var graphModelManager = GraphModelManager()
    private var monoDataSet: LineChartDataSet = LineChartDataSet()
    private var cesuarDataSet: LineChartDataSet = LineChartDataSet()
    private var tritDataSet: LineChartDataSet = LineChartDataSet()

    // MARK: - Views
    
    private lazy var dictLabel: UILabel = {
       let label = UILabel()
        label.text = "Частотные словари:"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var monoDict: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "character.book.closed"), for: .normal)
        button.setTitle("Моноалфавит", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.addAction(UIAction(handler: { [weak self] _ in
            if let monoData = self?.graphModelManager.obtainMonoGraphModel() {
                let controller = FreqDictionaryViewController(graphModel: monoData)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var cesuarDict: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Цезарь", for: .normal)
        button.setImage(.init(systemName: "text.book.closed"), for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.addAction(UIAction(handler: { [weak self] _ in
            if let caesarData = self?.graphModelManager.obtainCesuarGraphModel() {
                let controller = FreqDictionaryViewController(graphModel: caesarData)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var tritDict: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Тритемиус", for: .normal)
        button.setImage(.init(systemName: "book.closed"), for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.addAction(UIAction(handler: { [weak self] _ in
            if let tritemiusData = self?.graphModelManager.obtainTritemiusGraphModel() {
                let controller = FreqDictionaryViewController(graphModel: tritemiusData)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(graphModel: GraphModel) {
        self.graphModel = graphModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
        configureNav()
        
        chartView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300)
        chartView.center = view.center
        view.addSubview(chartView)
        
        chartView.delegate = self
        updateLineChartData()
        hideTopData()
        showOnlyLeftYAxis()
    }
}

// MARK: - private methods

private extension GraphsViewController {
    
    func configureUI() {
        view.addSubview(dictLabel)
        view.addSubview(monoDict)
        view.addSubview(cesuarDict)
        view.addSubview(tritDict)
        
        dictLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        monoDict.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(dictLabel.snp.bottom).offset(8)
        }
        
        cesuarDict.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(monoDict.snp.bottom).offset(8)
        }
        
        tritDict.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(cesuarDict.snp.bottom).offset(8)
        }
    }
    
    func configureNav() {
        navigationItem.title = "График"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "gobackward"), style: .plain, target: self, action: #selector(resetZoom))
    }
    
    func updateMonoData(_ graphModel: GraphModel) {
        let sortedData = graphModel.frequencyResult.sorted { $0.percentage > $1.percentage }

        var dataEntries: [ChartDataEntry] = []
        
        for (index, entry) in sortedData.enumerated() {
            let chartEntry = ChartDataEntry(x: Double(index), y: entry.percentage)
            dataEntries.append(chartEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Моно")
        dataSet.colors = [NSUIColor.blue]
        dataSet.mode = .linear
        dataSet.drawCirclesEnabled = true
        dataSet.drawCircleHoleEnabled = true
        dataSet.circleRadius = 4.0
        dataSet.circleHoleRadius = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        monoDataSet = dataSet
    }
    
    func updateTritemiusData(_ graphModel: GraphModel) {
        let sortedData = graphModel.frequencyResult.sorted { $0.percentage > $1.percentage }

        var dataEntries: [ChartDataEntry] = []
        
        for (index, entry) in sortedData.enumerated() {
            let chartEntry = ChartDataEntry(x: Double(index), y: entry.percentage)
            dataEntries.append(chartEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Тритемиус")
        dataSet.colors = [NSUIColor.purple]
        dataSet.mode = .horizontalBezier
        dataSet.drawCirclesEnabled = true
        dataSet.drawCircleHoleEnabled = true
        dataSet.circleRadius = 4.0
        dataSet.circleHoleRadius = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        tritDataSet = dataSet
    }
    
    func updateCesuarData(_ graphModel: GraphModel) {
        let sortedData = graphModel.frequencyResult.sorted { $0.percentage > $1.percentage }
        
        var dataEntries: [ChartDataEntry] = []
        
        for (index, entry) in sortedData.enumerated() {
            let chartEntry = ChartDataEntry(x: Double(index), y: entry.percentage)
            dataEntries.append(chartEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Цезарь")
        dataSet.colors = [NSUIColor.red]
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = true
        dataSet.drawCircleHoleEnabled = true
        dataSet.circleRadius = 4.0
        dataSet.circleHoleRadius = 2.0
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        cesuarDataSet = dataSet
    }
    
    func updateLineChartData() {
        switch GraphType(rawValue: graphModel.graphType) {
        case .mono:
            graphModelManager.saveMonoGraphModel(graphModel)
            updateMonoData(graphModel)
            if let caesarData = graphModelManager.obtainCesuarGraphModel() {
                updateCesuarData(caesarData)
            }
            
            if let tritemiusData = graphModelManager.obtainTritemiusGraphModel() {
                updateTritemiusData(tritemiusData)
            }
        case .caesar:
            graphModelManager.saveCesuarGraphModel(graphModel)
            updateCesuarData(graphModel)
            
            if let monoData = graphModelManager.obtainMonoGraphModel() {
                updateMonoData(monoData)
            }
            
            if let tritemiusData = graphModelManager.obtainTritemiusGraphModel() {
                updateTritemiusData(tritemiusData)
            }
        case .tritemius:
            graphModelManager.saveTritemiusGraphModel(graphModel)
            updateTritemiusData(graphModel)
            
            if let monoData = graphModelManager.obtainMonoGraphModel() {
                updateMonoData(monoData)
            }
            
            if let caesarData = graphModelManager.obtainCesuarGraphModel() {
                updateCesuarData(caesarData)
            }
        case .none:
            break
        }
        
        let data = LineChartData(dataSets: [monoDataSet, cesuarDataSet, tritDataSet])
        chartView.data = data
    }
    
    @objc private func resetZoom() {
        chartView.fitScreen()
    }
    
    func hideTopData() {
        chartView.xAxis.enabled = false
    }
    
    func showOnlyLeftYAxis() {
        chartView.rightAxis.enabled = false
    }
}

// MARK: - ChartViewDelegate

extension GraphsViewController: ChartViewDelegate {
    
}
