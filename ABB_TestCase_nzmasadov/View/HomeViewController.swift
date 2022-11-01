//
//  AppViewController.swift
//  ABB_TestCase_nzmasadov
//
//  Created by Test Test on 28.10.22.
//

import Foundation
import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: Variables
    
    var name: String? = nil
    var status: String? = nil
    var species: String? = nil
    var gender: String? = nil
    
    private lazy var vm = MainVM()
    private var charactersData: CharacterData?
    private var info: Info?
    private var characterItems: [CharacterItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    // MARK: UI Components
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .default
        search.sizeToFit()
        search.searchTextField.placeholder = "Search..."
        search.isTranslucent = false
        search.backgroundImage = UIImage()
        search.backgroundColor = .appBackGroundColor
        
        self.view.addSubview(search)
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.bounces = true
        collection.alwaysBounceVertical = true
        collection.backgroundColor = .appBackGroundColor
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = .init(top: 10, left: 15, bottom: 0, right: 15)
        collection.delegate = self
        collection.dataSource = self
        
        self.view.addSubview(collection)
        return collection
    }()
    
    // MARK: Pattern Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)
        
        vm.fetchFilteredCharacters(name: self.name, page: currentPage, status: self.status, species: self.species, gender: self.gender) { [weak self] chData in
            
            self?.info = chData.info
            guard let characterItems = chData.results else {return}
            characterItems.forEach({ item in
                self?.characterItems.append(item)
            })
        }
        
        searchBar.searchTextField.textPublisher().debounce(for: 0.5, scheduler: DispatchQueue.main).sink { _ in
            self.searchCharacters()
        }.store(in: &cancellables)
        
        hideKeyboard()
        setupUI()
    }
    
    private func searchCharacters() {
        let trimmedText = searchBar.searchTextField.text?.filter({ !$0.isWhitespace}) ?? ""
        vm.fetchFilteredCharacters(name: trimmedText, page: self.currentPage, status: self.status, species: self.species, gender: self.gender) { chData in
            self.info = chData.info
            self.characterItems = chData.results ?? []
        }
    }
    
    @objc func refreshCharacters() {
        collectionView.refreshControl?.beginRefreshing()
        self.characterItems = []
        self.currentPage = 1

        vm.fetchFilteredCharacters(name: nil, page: currentPage, status: nil, species: nil, gender: nil) { [weak self] chData in
            
            self?.info = chData.info
            guard let characterItems = chData.results else {return}
            characterItems.forEach({ item in
                self?.characterItems.append(item)
            })
        }
        collectionView.refreshControl?.endRefreshing()
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func changeAppMode() {
        var isDarkMode = UserDefaults.standard.bool(forKey: "APP_MODE")
        isDarkMode.toggle()
        
        UIApplication.shared.windows.forEach { window in
            if isDarkMode {
                window.overrideUserInterfaceStyle = .dark
            }else {
                window.overrideUserInterfaceStyle = .light
            }
        }
        vm.savePhoneMode(id: "APP_MODE", isDark: isDarkMode)
    }
    
    @objc func moveFilterVC() {
        let vc = FilterViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackGroundColor
        navigationItem.title = "Rick & Morty"
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "darkMode"), style: .plain, target: self, action: #selector(changeAppMode)),
            UIBarButtonItem(image: UIImage(named: "filterBold"), style: .plain, target: self, action: #selector(moveFilterVC))
        ]
        
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "\(CharacterCell.self)")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchHeader")
        
        let appMode = vm.getPhoneMode(id: "APP_MODE")
        
        UIApplication.shared.windows.forEach { window in
            if appMode {
                window.overrideUserInterfaceStyle = .dark
            }else {
                window.overrideUserInterfaceStyle = .light
            }
        }
        
        let safeView = view.safeAreaLayoutGuide.snp
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.right.equalTo(safeView.right)
            make.left.equalTo(safeView.left)
            make.bottom.equalTo(safeView.bottom)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CharacterCell.self)", for: indexPath) as! CharacterCell
        
        cell.configure(character: self.characterItems[indexPath.row])
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let vc = DetailViewController()
       vc.characterItem = self.characterItems[indexPath.row]
       vc.modalPresentationStyle = .overFullScreen
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width / 2) - 20, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let searchBarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeader", for: indexPath)
        
        searchBarHeader.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(48)
        }
        updateHeight(height: 48, radius: 16)
        return searchBarHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if info?.next != nil && indexPath.row == characterItems.count - 1 {
            currentPage += 1
            
            vm.fetchFilteredCharacters(name: self.name, page: currentPage, status: self.status, species: self.species, gender: self.gender) { [weak self] chData in
                
                self?.info = chData.info
                guard let characterItems = chData.results else {return}
                characterItems.forEach({ item in
                    self?.characterItems.append(item)
                })
            }
        }
    }
}

private extension UIImage {
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension HomeViewController {
    
    private func updateHeight(height: CGFloat, radius: CGFloat = 8.0) {
        let image: UIImage? = UIImage.imageWithColor(color: UIColor.lightGray.withAlphaComponent(0.2), size: CGSize(width: 1, height: height))
        searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.searchBar.subviews {
            for subSubViews in subview.subviews {
                subSubViews.backgroundColor = .appBackGroundColor
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.backgroundColor = .appBackGroundColor
                            textField.clipsToBounds = true
                            textField.layer.cornerRadius = radius
                        }
                    }
                }
            }
        }
    }
}

extension HomeViewController: FilterCharactersDelegate {
    func filerItems(vc: UIViewController, status: String, species: String, gender: String) {
        vc.dismiss(animated: true)
        
        self.characterItems = []
        if status != "" {
            self.status = status
        }else {
            self.status = nil
        }
        
        if species != "" {
            self.species = species
        }else {
            self.species = nil
        }
        
        if gender != "" {
            self.gender = gender
        }else {
            self.gender = nil
        }

        self.currentPage = 1
        
        vm.fetchFilteredCharacters(name: self.name, page: currentPage, status: self.status, species: self.species, gender: self.gender) { [weak self] chData in
            
            self?.info = chData.info
            guard let characterItems = chData.results else {return}
            characterItems.forEach({ item in
                self?.characterItems.append(item)
            })
        }
    }
}
