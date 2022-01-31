//
//  FeaturedViewController.swift
//  design+code
//
//  Created by Sabir Myrzaev on 29.01.2022.
//

import UIKit
import Combine

class FeaturedViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var handbooksCollectionView: UICollectionView!
    @IBOutlet var coursesTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var featuredTitleLabel: UILabel!
    @IBOutlet var featuredSubtitleLabel: UILabel!
    @IBOutlet var feauteredDescLabel: UILabel!
    @IBOutlet var handbooksLabel: UILabel!
    @IBOutlet var courseLabel: UILabel!





    
    private var tokens: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handbooksCollectionView.delegate = self
        handbooksCollectionView.dataSource = self
        handbooksCollectionView.layer.masksToBounds = false
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
        coursesTableView.layer.masksToBounds = false
        
        coursesTableView.publisher(for: \.contentSize)
            .sink { newContentSize in
                self.tableViewHeight.constant = newContentSize.height
            }
            .store(in: &tokens)
        
        scrollView.delegate = self
        
        // Accessibility
        featuredTitleLabel.font = UIFont.preferredFont(for: .title1, weight: .bold)
        featuredTitleLabel.adjustsFontForContentSizeCategory = true
        
        featuredSubtitleLabel.font = UIFont.preferredFont(for: .footnote, weight: .bold)
        featuredSubtitleLabel.adjustsFontForContentSizeCategory = true
        
        feauteredDescLabel.font = UIFont.preferredFont(for: .footnote, weight: .regular)
        feauteredDescLabel.adjustsFontForContentSizeCategory = true
        
        handbooksLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        handbooksLabel.adjustsFontForContentSizeCategory = true
        
        courseLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        courseLabel.adjustsFontForContentSizeCategory = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? CoursesViewController, let course = sender as? Course {
            detailVC.course = course
        }
    }


}

extension FeaturedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return handbooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as! HandbookCollectionViewCell
        let handbook = handbooks[indexPath.item]
        
        cell.titleLabel.text = handbook.courseTitle
        cell.subtitleLabel.text = handbook.courseSubtitle
        cell.descriptionLabel.text = handbook.courseDescription
        cell.gradient.colors = handbook.courseGradient
        cell.logo.image = handbook.courseIcon
        cell.banner.image = handbook.courseBanner
        
        return cell
    }
}

extension FeaturedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesTableCell", for: indexPath) as! CoursesTableViewCell
        let courses = courses[indexPath.section]
        
        cell.titleLabel.text = courses.courseTitle
        cell.subtitleLabel.text = courses.courseSubtitle
        cell.descriptionlabel.text = courses.courseDescription
        cell.logo.image = courses.courseIcon
        cell.banner.image = courses.courseBanner
        cell.background.image = courses.courseBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCourse = courses[indexPath.section]
        performSegue(withIdentifier: "presentCourse", sender: selectedCourse)
    }
}

extension FeaturedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let lastScrollYPos = scrollView.contentOffset.y
        
        let percentage = lastScrollYPos / contentHeight
        
        if percentage < 0.15 {
            self.title = "Featured"
        } else if percentage <= 0.33 {
            self.title = "Handbooks"
        } else {
            self.title = "Courses"
        }
    }
}
