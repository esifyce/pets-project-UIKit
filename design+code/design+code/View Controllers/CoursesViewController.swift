//
//  CoursesViewController.swift
//  design+code
//
//  Created by Sabir Myrzaev on 31.01.2022.
//

import UIKit
import Combine

class CoursesViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var iconImageView: CustomImageView!
    
    @IBOutlet var sectionsTableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var goBackButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    
    private var tokens: Set<AnyCancellable> = []

    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionsTableView.delegate = self
        sectionsTableView.dataSource = self
        
        sectionsTableView.publisher(for: \.contentSize)
            .sink { newContentSize in
                self.tableViewHeight.constant = newContentSize.height
            }
            .store(in: &tokens)
        
        // Set data for preview card
        self.iconImageView.image = course?.courseIcon
        self.bannerImage.image = course?.courseBanner
        self.backgroundImage.image = course?.courseBackground
        self.titleLabel.text = course?.courseTitle
        self.subtitleLabel.text = course?.courseSubtitle
        self.descriptionLabel.text = course?.courseDescription
        self.authorLabel.text = "Taught by \(course?.courseAuthor?.last ?? "Design+Code")"
        
        goBackButton.layer.cornerRadius = 15
        goBackButton.layer.cornerCurve = .continuous
        goBackButton.layer.masksToBounds = true
        
        // Create UIMenu
        let menu = UIMenu(title: "Course Options", options: .displayInline, children: [
            UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                // Share course
            }),
            UIAction(title: "Take Test", image: UIImage(systemName: "highlighter"), handler: { _ in
                // Take Test
            }),
            UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), handler: { _ in
                // Download course
            }),
            UIAction(title: "Forums", image: UIImage(systemName: "chevron.left.slash.chevron.right"), handler: { _ in
                // Forums course
            })
        ])
        
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = menu
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.course?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionsTableViewCell
        
        if let selectedCourse = course {
            let selectedSection = selectedCourse.sections![indexPath.row]
            
            cell.titleLabel.text = selectedSection.sectionTitle
            cell.sectionLogo.image = selectedSection.sectionIcon
            cell.descriptionlabel.text = selectedSection.sectionDescription
            cell.subtitleLabel.text = selectedSection.sectionSubtitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
