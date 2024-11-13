import UIKit
import RxSwift

class AddTaskViewController: ViewController<AddTaskViewModel,AddTaskNavigator> {
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let datePickerAlertController = UIAlertController(title: "Select date", message: nil, preferredStyle: .actionSheet)
    let timePickerAlertController = UIAlertController(title: "Select time", message: nil, preferredStyle: .actionSheet)
    var listButtons = [UIButton]()

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var categoryGoal: UIButton!
    @IBOutlet weak var categoryEvent: UIButton!
    @IBOutlet weak var categoryTask: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var notes: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupDateAndTimePicker()
        setUpAlertController()
        // Do any additional setup after loading the view.
    }
    override func setupUI() {
        super.setupUI()
        listButtons = [categoryTask,categoryEvent,categoryGoal]
        backButton.setTitle("", for: .normal)
        categoryGoal.setTitle("", for: .normal)
        categoryTask.setTitle("", for: .normal)
        categoryEvent.setTitle("", for: .normal)
        listButtons.forEach { 
            button in
            button.adjustsImageWhenHighlighted = false
            button.adjustsImageWhenDisabled = false
        }
        saveButton.isEnabled = taskTitle.text != nil

    }
    override func setupListener() {
        super.setupListener()
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateView.addGestureRecognizer(dateTapGesture)
        let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(showTimePicker))
        timeView.addGestureRecognizer(timeTapGesture)
        backButton.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.viewModel.backToHome()
        }.disposed(by: disposeBag)
        
        categoryTask.rx.tap.bind { [weak self] in self?.viewModel.handleButtonTap("CategoryTask")
        }.disposed(by: disposeBag)
        
        categoryEvent.rx.tap.bind { [weak self] in self?.viewModel.handleButtonTap("CategoryEvent")
        }.disposed(by: disposeBag)
        
        categoryGoal.rx.tap.bind { [weak self] in self?.viewModel.handleButtonTap("CategoryGoal")
        }.disposed(by: disposeBag)
        viewModel.selectedButton.subscribe(onNext: { [weak self] selectedButton in
            self?.updateButtonStates(selectedButton)}).disposed(by: disposeBag)
//        saveButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        saveButton.rx.tap.bind { [weak self] in
            
            guard let self = self else { return }
            let title = self.taskTitle.text ?? ""
            let dueDate = self.dateTextField.text ?? ""
            let dueTime = self.timeTextField.text
            let notes = self.notes.text
            self.viewModel.createItem(with: title, dueDate: dueDate,dueTime: dueTime, notes: notes)
            .subscribe(
                    onSuccess: { _ in
                        print("Task created successfully")
                        DispatchQueue.main.async{
                            self.showAlert(
                                title: "Success",
                                message: "Task created successfully",
                                completion: { _ in
                                    self.viewModel.backToHome()
                                }
                            )
                        }
//                        DispatchQueue.main.async{
//                            self.viewModel.backToHome()
//                        }
                    },
                    onError: { error in
                        print("error 1")
                        DispatchQueue.main.async{
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                ).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    private func updateButtonStates(_ selectedButton: String?) {
        for button in listButtons {
            button.alpha = (button == selectedCategoryButton(for: selectedButton) || selectedCategoryButton(for: selectedButton) == nil) ? 1.0 : 0.2
        }
    }
    private func selectedCategoryButton(for category: String?) -> UIButton?{
        switch category{
        
        case "CategoryTask":
                return categoryTask
        case "CategoryGoal":
            return categoryGoal
        case "CategoryEvent":
            return categoryEvent
        default:
            return nil
        }
    }
    @objc func addTodo(){
        
    }
}
//Date and time picker
extension AddTaskViewController{
    func setupDateAndTimePicker(){
        datePicker.datePickerMode = .date
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
            timePicker.preferredDatePickerStyle = .wheels
        }
    }
    @objc func showDatePicker() {
            self.present(datePickerAlertController, animated: true, completion: nil)
        }

        @objc func showTimePicker() {
            self.present(timePickerAlertController, animated: true, completion: nil)
        }
        
        @objc func timeChanged() {
            let formatter = DateFormatter()
            formatter.dateFormat = Configs.DateFormart.time
            timeTextField.text = formatter.string(from: timePicker.date)
        }
        
        @objc func dateChanged() {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateTextField.text = formatter.string(from: datePicker.date)
        }
    func setUpAlertController () {
            timePickerAlertController.view.addSubview(timePicker)
            timePicker.isHidden = false
            
            datePickerAlertController.view.addSubview(datePicker)
            datePicker.isHidden = false
            
            NSLayoutConstraint.activate([
                datePicker.centerXAnchor.constraint(equalTo: datePickerAlertController.view.centerXAnchor),
                datePickerAlertController.view.heightAnchor.constraint(equalToConstant: 500),
                datePicker.bottomAnchor.constraint(equalTo: datePickerAlertController.view.centerYAnchor, constant: 100),
                timePicker.centerXAnchor.constraint(equalTo: timePickerAlertController.view.centerXAnchor),
                timePickerAlertController.view.heightAnchor.constraint(equalToConstant: 500),
                timePicker.bottomAnchor.constraint(equalTo: timePickerAlertController.view.centerYAnchor, constant: 100)
            ])
            let dateConfirmAction = UIAlertAction(title: "Confirm", style: .default){ _ in
                self.dateChanged()
            }
            let dateCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            datePickerAlertController.addAction(dateConfirmAction)
            datePickerAlertController.addAction(dateCancelAction)
            
            let timeConfirmAction = UIAlertAction(title: "Confirm", style: .default){ _ in
                self.timeChanged()
            }
            let timeCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            timePickerAlertController.addAction(timeConfirmAction)
            timePickerAlertController.addAction(timeCancelAction)
        }
}

