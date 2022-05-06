//
//  ViewController.swift
//  MarineInhabitants
//
//  Created by Sabir Myrzaev on 29/4/22.
//

import UIKit

enum GenerateTable: Int {
    case column = 10
    case row = 15
}

enum percentOfHabitantsInMarine: Double {
    case penguin = 50
    case orca = 20
}

class ViewController: UIViewController {
    
    // MARK: - Property
    
    // create world filled with animals
    var worldHabitants: [(steps: Int, habitants: String)] = []
    
    var checkForEveryEighthLife = 0
    
    let column = GenerateTable.column.rawValue
    let row = GenerateTable.row.rawValue
    
    // setting flexible table
    lazy var columnLayout = FlowLayout(
        cellsPerRow: column,
        minimumInteritemSpacing: 1,
        minimumLineSpacing: 1,
        sectionInset: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0),
        numberOfItems: column
    )
    
    // MARK: - Views
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HabitantsCollectionViewCell.self, forCellWithReuseIdentifier: HabitantsCollectionViewCell.identifier)
        
        return view
    }()
    
    let restartButton: UIButton = {
        let restart = UIButton(type: .system)
        restart.setTitle("RESTART", for: .normal)
        restart.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        
        restart.backgroundColor = .white
        restart.layer.applyCornerRadiusShadow(color: .black,
                                              alpha: 0.38,
                                              x: 0, y: 3,
                                              blur: 10,
                                              spread: 0,
                                              cornerRadiusValue: 24)
        restart.addTarget(self, action: #selector(restartTapped), for: .touchUpInside)
        return restart
    }()
    
    // MARK: - Lifecycle vc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        generateMarineWorld()
    }
    
    // MARK: - Selectors
    
    @objc func collectionViewTapped() {
        print("DEBUG: collectionViewTapped")
        
        checkForEveryEighthLife += 1
        
        // calculate index values in every cell
        let upperLeftCorner = 0
        let upperRightCorner = column - 1
        let lowerLeftCorner = row * column - column
        let lowerRightCorner = row * column - 1
        let upperExceptFirstAndLast = 1 ..< column - 1
        let lowerExceptFirstAndLast = (row * column - column) + 1 ..< row * column - 1
        let leftExceptFirstAndLast = stride(from: column, to: row * column - column, by: column)
        let rightExceptFirstAndLast = stride(from: column - 1 + column, to: row * column - column, by: column)
        
        for (index, value) in worldHabitants.enumerated() {
            
            // UPPER LEFT CORNER
            if index == upperLeftCorner && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index + 1, index + column, index + column + 1])
            }
            
            // UPPER RIGHT CORNER
            if index == upperRightCorner && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index - 1, index + column, index + column - 1])
            }
            
            // LOWER LEFT CORNER
            if index == lowerLeftCorner && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index + 1, index - column, index - column + 1])
                
            }
            
            // LOWER RIGHT CORNER
            if index == lowerRightCorner && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index - 1, index - column, index - column - 1])
            }
            
            // TOP THE SQUARE EXCEPT FIRST AND LAST ELEMENT
            if upperExceptFirstAndLast.contains(index) && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index + 1, index - 1, index + column, index + column - 1, index + column + 1])
                
            }
            
            // BOTTOM THE SQUARE EXCEPT FIRST AND LAST ELEMENT
            if lowerExceptFirstAndLast.contains(index) && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index + 1, index - 1, index - column, index - column - 1, index - column + 1])
            }
            
            // LEFT THE SQUARE EXCEPT FIRST AND LAST ELEMENT
            if leftExceptFirstAndLast.contains(index) && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index - column, index + column, index + 1, index + 1 + column, index + 1 - column])
            }
            
            
            
            // RIGHT THE SQUARE EXCEPT FIRST AND LAST ELEMENT
            if rightExceptFirstAndLast.contains(index) && value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index - column, index + column, index - 1, index - 1 - column, index - 1 + column])
            }
            
            // CENTER THE SQUARE MOVE EXCEPT SIDES
            if !(rightExceptFirstAndLast).contains(index),
               !(leftExceptFirstAndLast).contains(index),
               !(lowerExceptFirstAndLast).contains(index),
               !(upperExceptFirstAndLast).contains(index),
               index != upperRightCorner,
               index != lowerRightCorner,
               index != lowerLeftCorner,
               index != upperLeftCorner,
               value.habitants != "empty" {
                moveHabitantsInMarine(loopIndex: index, ints: [index + 1, index - 1, index + column, index + column + 1, index + column - 1, index - column, index - column - 1, index - column + 1])
            }
        }
        collectionView.reloadData()
        
        if checkForEveryEighthLife == 8 {
            checkForEveryEighthLife = 0
        }
        gameOver()
    }
    
    @objc func restartTapped() {
        worldHabitants.removeAll()
        generateMarineWorld()
        checkForEveryEighthLife = 0
        collectionView.reloadData()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        view.addSubview(restartButton)
        
        // add a click to a table
        let tap = UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped))
        tap.numberOfTapsRequired = 1
        self.collectionView.addGestureRecognizer(tap)
    }
    
    private func setConstraints() {
        collectionView.apply(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, marginTop: 20, marginLeft: 20, marginBottom: 100, marginRight: 20)
        
        restartButton.centerX(inView: collectionView)
        restartButton.apply(bottom: view.safeAreaLayoutGuide.bottomAnchor, marginBottom: 30, width: 250, height: 70)
    }
    
    private func generateMarineWorld() {
        // create the array to fill in
        var fillHabitants: [(steps: Int, habitants: String)] = []
        
        // setting the field size
        let fieldSize = Double(column * row)
        // assign a percentage value for filling the world of a certain animal
        let penguinCount = Int(round(calculatePercentage(value: fieldSize, percentageVal: percentOfHabitantsInMarine.penguin.rawValue)))
        let orcaCount = Int(round(calculatePercentage(value: fieldSize, percentageVal: percentOfHabitantsInMarine.orca.rawValue)))
        // after filling with animals add empty cells
        let emptyCount = Int(fieldSize) - (penguinCount + orcaCount)
        
        // generate penguin, orca, empty
        for _ in 0 ..< penguinCount { fillHabitants.append((steps: 0, habitants: "penguin")) }
        for _ in 0 ..< orcaCount { fillHabitants.append((steps: 0, habitants: "orca")) }
        for _ in 0 ..< emptyCount { fillHabitants.append((steps: 0, habitants: "empty")) }
        
        // Mix the ready made world and pass it to the array with which we will work further
        fillHabitants.shuffled().forEach { value in worldHabitants.append(value) }
    }
    
    private func moveHabitantsInMarine(loopIndex: Int, ints: [Int]) {
        // create array for check filling the area around
        var empty = [Int]()
        var penguin = [Int]()
        
        ints.enumerated().forEach { index, value in
            var bool = false
            if worldHabitants[value].habitants == "empty" {
                bool = index < 3 ? true : value != .zero
            }
            if bool {
                empty.append(value)
            }
            // orca eat penguin
            if worldHabitants[value].habitants == "penguin" && worldHabitants[loopIndex].habitants == "orca" {
                worldHabitants[value].habitants = "orca"
                worldHabitants[value].steps = 0
                worldHabitants[loopIndex].habitants = "empty"
                worldHabitants[loopIndex].steps = 0
                penguin.append(value)
            }
        }
        
        // check steps of animals for the penguin's reproduction and the orca's death
        if worldHabitants[loopIndex].habitants == "penguin" {
            worldHabitants[loopIndex].steps += 1
        } else if worldHabitants[loopIndex].habitants == "orca" {
            worldHabitants[loopIndex].steps -= 1
        }
        
        /// The orca's  REPRODUCTION
        if checkForEveryEighthLife == 8 && worldHabitants[loopIndex].habitants == "orca" {
            worldHabitants[empty.randomElement() ?? loopIndex].habitants = "orca"
            worldHabitants[penguin.randomElement() ?? loopIndex].habitants = "orca"
        }
        
        ///  The penguin's REPRODUCTION
        if worldHabitants[loopIndex].habitants == "penguin" && worldHabitants[loopIndex].steps >= 3 {
            worldHabitants[loopIndex].steps = 0
            worldHabitants[empty.randomElement() ?? loopIndex].habitants = "penguin"
        }
        /// The orca's DEATHS
        if worldHabitants[loopIndex].habitants == "orca" && worldHabitants[loopIndex].steps <= -3 {
            worldHabitants[loopIndex].habitants = "empty"
        } else {
            worldHabitants.swapAt(loopIndex, empty.randomElement() ?? loopIndex)
        }
    }
    
    private func gameOver() {
        var checkExistOrca = false
        var checkExistPenguin = false
        worldHabitants.forEach({ if $1 == "orca" { checkExistOrca = true } })
        worldHabitants.forEach({ if $1 == "penguin" { checkExistPenguin = true } })
        
        if checkExistOrca == false {
            presentAlert(message: "Пингвины выйграли игру", title: "Победа")
        }
        
        if checkExistPenguin == false {
            presentAlert(message: "Касатки выйграли игру", title: "Поражение")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return row * column
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitantsCollectionViewCell.identifier, for: indexPath) as? HabitantsCollectionViewCell else { return UICollectionViewCell() }
        
        // Configure the cell
        cell.configure(image: worldHabitants[indexPath.row].habitants)
        
        return cell
    }
}
