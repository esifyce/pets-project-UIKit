//
//  MonoAlghoritmViewController.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 06.10.2023.
//

import UIKit
import SnapKit

class MonoAlghoritmViewController: UIViewController {
    
    // MARK: - Property
    
    let inputAlphabet = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    var outputAlphabet: String = ""
    var frequencyOutputResult: [String: (count: Int, percentage: Double)] = [:]
    
    // MARK: - Views
    
    private lazy var keyTextField: UITextField = {
       let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftView = leftView
        textField.placeholder = "Сгенерируйте ключ"
        textField.leftViewMode = .always
        textField.isHidden = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private lazy var generateKeyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Генерация", for: .normal)
        button.isHidden = true
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.outputAlphabet = self.generateCipherAlphabet(inputAlphabet: inputAlphabet)
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
                let result = self.encryptText(text: text.lowercased(), cipherAlphabet: self.outputAlphabet)
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
                let result = self.decryptText(encryptedText: text.lowercased(), cipherAlphabet: self.outputAlphabet)
                self.inputTextView.text = result
            }
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GraphModelManager.shared.clearMemory()
        configureUI()
        self.outputAlphabet = self.generateCipherAlphabet(inputAlphabet: inputAlphabet)
    }
}

// MARK: - Alghoritm methods

extension MonoAlghoritmViewController {
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
            let percentage = Double(count) / Double(totalLetterCount)
            letterAnalysisDictionary[char] = (count: count, percentage: percentage)
        }

        return letterAnalysisDictionary
    }
    
    func generateCipherAlphabet(inputAlphabet: String) -> String {
          let reversedCipherAlphabet = String(inputAlphabet.reversed())
          return reversedCipherAlphabet
      }

    func encryptText(text: String, cipherAlphabet: String) -> String {
        var encryptedText = ""
        
        for char in text.lowercased() {
            if let index = inputAlphabet.firstIndex(of: char) {
                encryptedText.append(cipherAlphabet[index])
            } else {
                encryptedText.append(char)
            }
        }
        
        return encryptedText
    }

    func decryptText(encryptedText: String, cipherAlphabet: String) -> String {
        var decryptedText = ""
        
        for char in encryptedText {
            if let index = cipherAlphabet.firstIndex(of: char) {
                decryptedText.append(inputAlphabet[index])
            } else {
                decryptedText.append(char)
            }
        }
        
        return decryptedText
    }
}

// MARK: - private MonoAlghoritmViewController

private extension MonoAlghoritmViewController {
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
            make.width.equalTo(130)
            make.centerX.equalToSuperview().offset(-80)
            make.centerY.equalToSuperview()
        }
        
        decodingButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(16)
            make.height.equalTo(40)
            make.width.equalTo(130)
            make.centerX.equalToSuperview().offset(80)
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
        navigationItem.title = "Моноалфавит"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.xyaxis.line"), style: .done, target: self, action: #selector(openGraph))
        
        let firstButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(clearInputTextView))
        
        let secondButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .done, target: self, action: #selector(clearOutputTextView))
        navigationItem.setLeftBarButtonItems([firstButton, secondButton], animated: false)
        
    }
    
    // MARK: - Selectors
    
    @objc
    func openGraph() {
        let frequencyModels: [FrequencyModel] = frequencyOutputResult.map { (char, data) in
            return FrequencyModel(char: char, count: data.count, percentage: data.percentage)
        }
        let controller = GraphsViewController(graphModel: .init(graphType: GraphType.mono.rawValue, frequencyResult: frequencyModels))
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

extension MonoAlghoritmViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text.lowercased())
        textView.text = newText
        return false
    }
}
