
import UIKit

class TodoTableViewCell: TableViewCell {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var category: UIImageView!
    var toggleCompletionAction: ((TodoModel) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private let blur = 0.2
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func bind(viewModel: CellViewModel) {
        guard let viewModel = viewModel as? TodoCellViewModel else {
            return
        }
        resetUI()
        let item = viewModel.item
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.dueTime.bind(to: dateLabel.rx.text).disposed(by: disposeBag)
        viewModel.category.map { categoryName -> UIImage? in
            return UIImage(named: categoryName ?? "")
        }
        .bind(to: category.rx.image)
        .disposed(by: disposeBag)
        viewModel.isCompleted
            .map { isCompleted in
                return isCompleted ? UIImage(named: "True") : UIImage(named: "False")
            }
            .bind(to: completeButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        viewModel.isCompleted.subscribe(onNext: {
            [weak self] isCompleted in
            self?.setupForCompleted(isCompleted: isCompleted)
        }).disposed(by: disposeBag)
        completeButton.setTitle("", for: .normal)
        completeButton.rx.tap.bind{
            print("toggle start")
            viewModel.toggleComplete()
            print("toggle done")
        }.disposed(by: disposeBag)
//        setupForCompleted(todo: item)
    }
    func setupForCompleted(isCompleted:Bool){
        if isCompleted{
            titleLabel.attributedText = blurEffect(for: titleLabel)
            dateLabel.attributedText = blurEffect(for: dateLabel)
            
            category.alpha = blur
            category.backgroundColor?.withAlphaComponent(blur)
        }
    }
    private func resetUI() {
        // Reset any attributes that may have been set by previous cell usage
        titleLabel.attributedText = nil
        dateLabel.attributedText = nil
        category.alpha = 1.0
        category.backgroundColor = UIColor.clear
    }
    func blurEffect(for label:UILabel) -> NSAttributedString{
        let attributedString = NSAttributedString(
            string: label.text!,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.black.withAlphaComponent(blur),
                .foregroundColor: UIColor.black.withAlphaComponent(blur)
            ]
        )
        return attributedString
    }
    func formatTimestampToTime(_ timestamp: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: timestamp) {
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
