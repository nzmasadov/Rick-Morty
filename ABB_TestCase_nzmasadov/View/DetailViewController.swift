//
//  DetailViewController.swift
//  ABB_TestCase_nzmasadov
//
//  Created by Test Test on 28.10.22.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    // MARK: - Variables
    
    let vm = MainVM()
    var characterItem: CharacterItem?

    private lazy var containerStackView: UIStackView = {
       let stack = UIStackView()
        
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        
        img.layer.cornerRadius = 10
        
        return img
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        lbl.textColor = UIColor.label

        return lbl
    }()

    lazy var genderLbl: UILabel = {
        let lbl = UILabel()

        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.label

        return lbl
    }()

    lazy var statusLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.label

        return lbl
    }()

    lazy var speciesLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.label

        return lbl
    }()

    lazy var typeLbl: UILabel = {
        let lbl = UILabel()
       
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.label

        return lbl
    }()
    
    lazy var originLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = UIColor.label

        return lbl
    }()

    // MARK: - Parent Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackGroundColor
        
        view.addSubview(imageView)
        view.addSubview(nameLbl)
        view.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(genderLbl)
        containerStackView.addArrangedSubview(statusLbl)
        containerStackView.addArrangedSubview(speciesLbl)
        containerStackView.addArrangedSubview(typeLbl)
        containerStackView.addArrangedSubview(originLbl)

    
        nameLbl.text = characterItem?.name ?? "-"
        genderLbl.text = "Gender: \(characterItem?.gender?.rawValue ?? "-")"
        statusLbl.text = "Status: \(characterItem?.status?.rawValue ?? "-")"
        speciesLbl.text = "Species: \(characterItem?.species?.rawValue ?? "-")"
        typeLbl.text = "Type: \(characterItem?.type ?? "-")"
        originLbl.text = "Origin: \(characterItem?.origin?.name ?? "-")"
        imageView.kf.setImage(with: URL(string: characterItem?.image ?? ""))
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appMode = vm.getPhoneMode(id: "APP_MODE")
        
        UIApplication.shared.windows.forEach { window in
            if appMode {
                window.overrideUserInterfaceStyle = .dark
            }else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    // MARK: - Functions
    @objc func onBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Constraints
extension DetailViewController {
    func setupUI() {

        self.imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.imageView.layer.shadowRadius = 10
        self.imageView.layer.shadowColor = UIColor.init(named: "textColor")?.cgColor
        self.imageView.layer.shadowOpacity = 0.5
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.view.snp.width).dividedBy(1.2)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.centerX.equalTo(self.imageView.snp.centerX)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(20)
        }
    }
}
