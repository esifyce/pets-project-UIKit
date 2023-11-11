//
//  CaesarAlghoritmViewController.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 06.10.2023.
//

import UIKit
import SnapKit

class CaesarAlghoritmViewController: UIViewController {
    
    // MARK: - Property
    
    let inputAlphabet = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    var outputAlphabet: String = ""
    var shift: Int = 3
    let frequencies: [Character: Double] = [
        "а": 0.062, "б": 0.014, "в": 0.038, "г": 0.013, "д": 0.025,
        "е": 0.072, "ё": 0.072, "ж": 0.007, "з": 0.016, "и": 0.062,
        "й": 0.010, "к": 0.028, "л": 0.035, "м": 0.026, "н": 0.053,
        "о": 0.090, "п": 0.023, "р": 0.040, "с": 0.045, "т": 0.053,
        "у": 0.021, "ф": 0.002, "х": 0.009, "ц": 0.004, "ч": 0.012,
        "ш": 0.006, "щ": 0.003, "ы": 0.016, "ь": 0.014, "ъ": 0.014,
        "э": 0.003, "ю": 0.006, "я": 0.018
    ]
    var frequencyOutputResult: [String: (count: Int, percentage: Double)] = [:]
    
    // MARK: - Views
    
    private lazy var keyTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftView = leftView
        textField.placeholder = "Запишите сдвиг"
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private lazy var generateKeyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Генерация", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let text = keyTextField.text, text.isEmpty {
                self.shift = 3
                keyTextField.text = String(self.shift)
            } else if let text = keyTextField.text, let shift = Int(text) {
                self.shift = shift
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.delegate = self
        return textView
    }()
    
    private lazy var outputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.delegate = self
        return textView
    }()
    
    private lazy var encodingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Кодирование", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let text = inputTextView.text, !text.isEmpty {
                let result = self.caesarEncrypt(text: text.lowercased(), shift: self.shift)
                self.outputTextView.text = result
                self.frequencyOutputResult = letterFrequencyAnalysis(text: self.outputTextView.text)
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var decodingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Декодирование", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let text = outputTextView.text, !text.isEmpty {
                let result = self.caesarDecrypt(encryptedText: text.lowercased(), shift: self.shift)
                self.inputTextView.text = result
            }
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var guessButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Определить", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let text = outputTextView.text, !text.isEmpty {
                let bestShift = self.decryptWithMaxLikelihood(input: text.lowercased())
                let result = self.caesarDecrypt(encryptedText: text.lowercased(), shift: bestShift)
                self.inputTextView.text = result
            }
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension CaesarAlghoritmViewController {
    func letterFrequencyAnalysis(text: String) -> [String: (count: Int, percentage: Double)] {
        var totalLetterCount = 0
        var letterFrequencyDictionary: [String: Int] = [:]

        // Counting the total number of letters
        for char in text {
            if char.isLetter {
                totalLetterCount += 1
                let charString = String(char)
                if let currentCount = letterFrequencyDictionary[charString] {
                    letterFrequencyDictionary[charString] = currentCount + 1
                } else {
                    letterFrequencyDictionary[charString] = 1
                }
            }
        }

        // Converting to percentages
        var letterAnalysisDictionary: [String: (count: Int, percentage: Double)] = [:]
        for (char, count) in letterFrequencyDictionary {
            let percentage = Double(count) / Double(totalLetterCount) * 100.0
            letterAnalysisDictionary[char] = (count: count, percentage: percentage)
        }

        return letterAnalysisDictionary
    }
    
    func caesarEncrypt(text: String, shift: Int) -> String {
        var encryptedText = ""
        
        for char in text {
            if let index = inputAlphabet.firstIndex(of: char) {
                let newIndex = (inputAlphabet.distance(from: inputAlphabet.startIndex, to: index) + shift) % inputAlphabet.count
                let newCharIndex = inputAlphabet.index(inputAlphabet.startIndex, offsetBy: newIndex)
                encryptedText.append(inputAlphabet[newCharIndex])
            } else {
                encryptedText.append(char)
            }
        }
        
        return encryptedText
    }
    
    func caesarDecrypt(encryptedText: String, shift: Int) -> String {
        var decryptedText = ""
        
        for char in encryptedText {
            if let index = inputAlphabet.firstIndex(of: char) {
                var newIndex = inputAlphabet.distance(from: inputAlphabet.startIndex, to: index) - shift
                if newIndex < 0 {
                    newIndex += inputAlphabet.count
                }
                let newCharIndex = inputAlphabet.index(inputAlphabet.startIndex, offsetBy: newIndex)
                decryptedText.append(inputAlphabet[newCharIndex])
            } else {
                decryptedText.append(char)
            }
        }
        
        return decryptedText
    }
    
    func calculateLikelihood(text: String) -> Double {
        let defaultFrequency: Double = 0.01
        
        var likelihood: Double = 0.0
        
         let lowercaseText = text.lowercased()
         
         for letter in lowercaseText {
             if let letterFrequency = frequencies[letter] {
                 likelihood += letterFrequency
             } else {
                 likelihood += defaultFrequency
             }
         }
         
         return likelihood
        
    }

    func decryptWithMaxLikelihood(input: String) -> Int {
        var maxLikelihood = 0.0
        var correct = 0
        
        for shift in 1...33 {
            let decryption = caesarDecrypt(encryptedText: input, shift: shift)
            let likelihood = calculateLikelihood(text: decryption)
            print("Сдвиг: \(shift) сумма: \(likelihood)")
            
            if likelihood > maxLikelihood {
                maxLikelihood = likelihood
                correct = shift
            }
        }
        showLikehoodAlert(number: correct)
        return correct
    }
}

// MARK: - private CaesarAlghoritmViewController

private extension CaesarAlghoritmViewController {
    func configureUI() {
        view.backgroundColor = .white
        configureNavigation()
        addViews()
        addConstraints()
    }
    
    func addViews() {
        view.addSubview(keyTextField)
        view.addSubview(generateKeyButton)
        view.addSubview(inputTextView)
        view.addSubview(encodingButton)
        view.addSubview(decodingButton)
        view.addSubview(guessButton)
        view.addSubview(outputTextView)
    }
    
    func addConstraints() {
        keyTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.trailing.equalTo(generateKeyButton.snp.leading).offset(-8)
        }
        
        generateKeyButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(90)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.top.equalTo(keyTextField.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
        
        encodingButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(16)
            make.height.equalTo(40)
            make.width.equalTo(110)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        decodingButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(16)
            make.height.equalTo(40)
            make.width.equalTo(130)
            make.leading.equalTo(encodingButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        guessButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(90)
            make.top.equalTo(inputTextView.snp.bottom).offset(16)
            make.leading.equalTo(decodingButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            
        }
        
        outputTextView.snp.makeConstraints { make in
            make.top.equalTo(decodingButton.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
    }
    
    func configureNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Цезарь"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.xyaxis.line"), style: .done, target: self, action: #selector(openGraph))
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(clearInputTextView))
        
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: #selector(clearOutputTextView))
        navigationItem.setLeftBarButtonItems([firstButton, secondButton], animated: false)
    }
    
    func showLikehoodAlert(number: Int) {
        let alertController = UIAlertController(
            title: "Успешно",
            message: "Сдвиг: \(number)",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc
    func openGraph() {
        let frequencyModels: [FrequencyModel] = frequencyOutputResult.map { (char, data) in
            return FrequencyModel(char: char, count: data.count, percentage: data.percentage)
        }
        let controller = GraphsViewController(graphModel: .init(graphType: GraphType.caesar.rawValue, frequencyResult: frequencyModels))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func clearInputTextView() {
        inputTextView.text = nil
    }
    
    @objc
    func clearOutputTextView() {
        outputTextView.text = nil
    }
}

// MARK: - UITextViewDelegate

extension CaesarAlghoritmViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text.lowercased())
        textView.text = newText
        return false
    }
}
