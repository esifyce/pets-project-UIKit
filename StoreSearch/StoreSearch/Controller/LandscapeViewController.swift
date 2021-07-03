//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 02.07.2021.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var search: Search!
    private var firstTime = true
    private var downloads = [URLSessionDownloadTask]()
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // удаляет ограничения из основного представления
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        // удаляет ограничения для управления страницей
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        // удаляет ограничение для просмотра прокрутки
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        
        pageControl.numberOfPages = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(
            x: safeFrame.origin.x,
            y: safeFrame.size.height - pageControl.frame.size.height,
            width: safeFrame.size.width,
            height: pageControl.frame.size.height)
        if firstTime {
            firstTime = false
            
            switch search.state {
            case .notSearchedYet:
                break
            case .noResults:
                showNothingFoundLabel()
            case .loading:
                showSpinner()
            case .results(let list):
                tileButtons(list)
            }
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if case .results(let list) = search.state {
                let detailVC = segue.destination as! DetailViewController
                let searchResult = list[(sender as! UIButton).tag - 2000]
                detailVC.searchResult = searchResult
                detailVC.isPopUp = true
            }
        }
    }
    
    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseInOut]) {
            self.scrollView.contentOffset = CGPoint(
                x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage),
                y: 0)
        }
    }
    
    // MARK: - Helper methods
    
    func searchResultsReceived() {
        hideSpinner()
        switch search.state {
        case .notSearchedYet, .loading:
            break
        case .noResults:
            showNothingFoundLabel()
        case .results(let list):
            tileButtons(list)
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowDetail", sender: sender)
    }
    
    // MARK: - Private Methods
    
    private func tileButtons(_ searchResults: [SearchResult]) {
        let itemWidth: CGFloat = 94
        let itemHeight: CGFloat = 88
        var columnsPerPage = 0
        var rowsPerPage = 0
        var marginX: CGFloat = 0
        var marginY: CGFloat = 0
        
        let viewWidth = UIScreen.main.bounds.size.width
        let viewHeight = UIScreen.main.bounds.size.height
        
        // 1 Вычисляем количество необходимых столбцов
        columnsPerPage = Int(viewWidth/itemWidth)
        rowsPerPage = Int(viewHeight/itemHeight)
        
        // 2 Вычисляем, сколько места осталось по горизонтали
        marginX = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) * 0.5
        marginY = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) * 0.5
        
        // Button size
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2
        
        // Add the buttons
        var row = 0
        var column = 0
        var x = marginX
        for (index, result) in searchResults.enumerated() {
            
            // 1 В целях отладки каждой кнопке присваивается заголовок с индексом массива.
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
            button.tag = 2000 + index
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            downloadImage(for: result, andPlaceOn: button)
            // 2 определяем положение и размер кнопки
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row) * itemHeight + paddingVert,
                                  width: buttonWidth,
                                  height: buttonHeight)
            // 3 добавляем новый объект кнопки в UIScrollViewкак подпредставление.
            scrollView.addSubview(button)
            // 4 использовали x и row переменные для размещения кнопок
            row += 1
            if row == rowsPerPage {
                row = 0
                x += itemWidth
                column += 1
                if column == columnsPerPage {
                    column = 0
                    x += marginX * 2
                }
            }
        }
        
        // Set scroll view content size
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth,
                                        height: scrollView.bounds.size.height)
        print("Number of pages: \(numPages)")
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }
    
    private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
        if let url = URL(string: searchResult.imageSmall) {
            let task = URLSession.shared.downloadTask(with: url) { [weak button] url, _, error in
                if error == nil,
                   let url = url,
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let button = button {
                            button.setImage(image, for: .normal)
                        }
                    }
                }
            }
            task.resume()
            downloads.append(task)
        }
    }
    
    private func showSpinner() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = CGPoint(x: scrollView.bounds.midX + 0.5,
                                 y: scrollView.bounds.midY + 0.5)
        spinner.tag = 1000
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    private func hideSpinner() {
        view.viewWithTag(1000)?.removeFromSuperview()
    }
    
    private func showNothingFoundLabel() {
        let label = UILabel(frame: CGRect.zero)
        label.text = "Nothing Found"
        label.textColor = UIColor.label
        label.backgroundColor = UIColor.clear
        
        label.sizeToFit()
        var rect = label.frame
        rect.size.width = ceil(rect.size.width / 2) * 2
        rect.size.height = ceil(rect.size.height / 2) * 2
        label.frame = rect
        label.center = CGPoint(x: scrollView.bounds.midX,
                               y: scrollView.bounds.midY)
        view.addSubview(label)
        
    }
}

// MARK: - ScrollView delegate

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControl.currentPage = page
    }
}
