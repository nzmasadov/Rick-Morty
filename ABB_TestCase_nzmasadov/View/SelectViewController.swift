import UIKit

protocol SelectionTypeDelegate: AnyObject {
    func selectItem(name: String, type: FilterType)
}

class SelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var type: FilterType!
    
    var genderItems = ["Female", "Male", "unknown", "Genderless"]
    var speciesItems = ["Alien", "Human", "Mythological Creature", "Disease", "Animal", "Cronenberg", "Humanoid", "unknown", "Poopybutthole", "Robot"]
    var statusItems = ["Alive", "Dead", "unknown"]
    
    weak var delegate: SelectionTypeDelegate?
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        
        view.addSubview(picker)
        return picker
    }()
    
    private lazy var doneButton: UIButton = {
       let btn = UIButton()
        
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        view.addSubview(btn)
        return btn
    }()
    
    
    convenience init(type: FilterType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc func doneTapped() {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        
        switch type {
        case .gender:
            delegate?.selectItem(name: genderItems[selectedIndex], type: .gender)
        case .species:
            delegate?.selectItem(name: speciesItems[selectedIndex], type: .species)
        case .status:
            delegate?.selectItem(name: statusItems[selectedIndex], type: .status)
        default:
            break
        }
        self.dismiss(animated: true)
    }
    
    override func updateViewConstraints() {
//        self.view.frame.size.height = UIScreen.main.bounds.height - 150
//        self.view.frame.origin.y =  450
        self.view.frame.origin.y = UIScreen.main.bounds.height / 2
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        super.updateViewConstraints()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .gender:
            return genderItems.count
        case .species:
            return speciesItems.count
        case .status:
            return statusItems.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch type {
        case .gender:
            return genderItems[row]
        case .species:
            return speciesItems[row]
        case .status:
            return statusItems[row]
        default:
            return ""
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackGroundColor
        isModalInPresentation = true

        pickerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-15)
        }
    }
}
