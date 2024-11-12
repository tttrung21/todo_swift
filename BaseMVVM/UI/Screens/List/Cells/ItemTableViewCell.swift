////
////  ItemTableViewCell.swift
////  BaseMVVM
////
////  Created by Lê Thọ Sơn on 4/29/20.
////  Copyright © 2020 thoson.it. All rights reserved.
////
//
//import UIKit
//
//class ItemTableViewCell: TableViewCell {
//    
//    @IBOutlet weak var category: UIImageView!
//    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var dueDate: UILabel!
//    @IBOutlet weak var completedButton: UIButton!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        selectionStyle = .none
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//    
//    override func bind(viewModel: CellViewModel) {
//        guard let viewModel = viewModel as? ItemCellViewModel else {
//            return
//        }
//        let item = viewModel.item
//        viewModel.title.bind(to: title.rx.text).disposed(by: disposeBag)
//        viewModel.dueDate.bind(to: dueDate.rx.text).disposed(by: disposeBag)
//        viewModel.category.map { categoryName -> UIImage? in
//            return UIImage(named: categoryName ?? "")
//        }
//        .bind(to: category.rx.image)
//        .disposed(by: disposeBag)
//        viewModel.isCompleted
//            .map { isCompleted in
//                return isCompleted ? UIImage(named: "True") : UIImage(named: "False")
//            }
//            .bind(to: completedButton.rx.image(for: .normal))
//            .disposed(by: disposeBag)
////        viewModel.imageUrl.map({ (string) -> URL? in
////            return URL(string: string ?? "")
////        }).bind(to: avatarImageView.rx.imageURL).disposed(by: disposeBag)
//    }
//}
