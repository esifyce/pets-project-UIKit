//
//  CommentCell.swift
//  MVC-N
//
//  Created by Sabir Myrzaev on 18.06.2021.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    func configure(with comment: Comment) {
        self.label.text = comment.name
        self.textView.text = comment.body
    }
}
