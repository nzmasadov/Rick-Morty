import UIKit
import SnapKit

protocol FilterCharactersDelegate: AnyObject {
    func filerItems(vc: UIViewController, status: String, species: String, gender: String)
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterCharactersDelegate?
    
    var savedStatus: String? = nil
    var savedGender: String? = nil
    var savedSpecies: String? = nil
    
    private lazy var containerStackView: UIStackView = {
       let stack = UIStackView()
        
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private lazy var statusField: UITextField = {
       let field = UITextField()
        
        field.placeholder = "Status"
        field.backgroundColor = .appBackGroundColor
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 15)
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(chooseStatus), for: .allTouchEvents)
        field.text = savedStatus ?? ""
        
        return field
    }()
    
    private lazy var genderField: UITextField = {
       let field = UITextField()
        
        field.placeholder = "Gender"
        field.backgroundColor = .appBackGroundColor
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 15)
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(chooseGender), for: .allTouchEvents)
        field.text = savedGender ?? ""

        return field
    }()
    
    private lazy var speciesField: UITextField = {
       let field = UITextField()
        
        field.placeholder = "Species"
        field.backgroundColor = .appBackGroundColor
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 15)
        field.borderStyle = .roundedRect
        field.addTarget(self, action: #selector(chooseSpecies), for: .allTouchEvents)
        field.text = savedSpecies ?? ""
                
        return field
    }()
        
    private lazy var buttonsStackView: UIStackView = {
       let stack = UIStackView()
        
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private lazy var filterBtn: UIButton = {
       let btn = UIButton()
        
        btn.setTitle("Filter", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 16
        
        return btn
    }()
    
    private lazy var clearBtn: UIButton = {
       let btn = UIButton()
        
        btn.setTitle("Clear", for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 16
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackGroundColor
        
        view.addSubview(containerStackView)
        view.addSubview(buttonsStackView)
        
        containerStackView.addArrangedSubview(statusField)
        containerStackView.addArrangedSubview(genderField)
        containerStackView.addArrangedSubview(speciesField)
        
        buttonsStackView.addArrangedSubview(filterBtn)
        buttonsStackView.addArrangedSubview(clearBtn)
        setupUI()
    }
    
    override func updateViewConstraints() {
//        self.view.frame.size.height = UIScreen.main.bounds.height - 150
        self.view.frame.origin.y = UIScreen.main.bounds.height / 2
        
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        super.updateViewConstraints()
    }
    
    @objc func chooseStatus() {
        let vc = SelectViewController(type: .status)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func chooseGender() {
        let vc = SelectViewController(type: .gender)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func chooseSpecies() {
        let vc = SelectViewController(type: .species)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc func filterTapped() {
        
        delegate?.filerItems(vc: self, status: statusField.text!, species: speciesField.text!, gender: genderField.text!)
    }
    
    @objc func clearTapped() {
        statusField.text = ""
        speciesField.text = ""
        genderField.text = ""
    }
        
    private func setupUI() {
        self.isModalInPresentation = true

        statusField.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        
        genderField.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        
        speciesField.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        
        filterBtn.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
        
        clearBtn.snp.makeConstraints { make in
            make.height.equalTo(42)
        }

        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}

extension FilterViewController: SelectionTypeDelegate {
    func selectItem(name: String, type: FilterType) {
        switch type {
        case .species:
            speciesField.text = name
        case .gender:
            genderField.text = name
        case .status:
            statusField.text = name
        }
    }
}
