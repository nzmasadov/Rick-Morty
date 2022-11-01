import UIKit
import Kingfisher
import SnapKit

class CharacterCell: UICollectionViewCell {

    lazy var imageView : UIImageView = {
        let imgView = UIImageView()

        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 16
        imgView.contentMode = .scaleAspectFill
        addSubview(imgView)
        return imgView
    }()
    
    private lazy var nameLbl: UILabel = {
        let label = UILabel()

        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        addSubview(label)
        return label
    }()
    
    private lazy var genderLbl: UILabel = {
        let label = UILabel()

        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        addSubview(label)
        return label
    }()
    
    private lazy var spicesView : UIView = {
        let view = UIView()

        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFill
        
        imageView.addSubview(view)
        return view
    }()
    
    private lazy var spicesLbl: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)

        spicesView.addSubview(label)
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        backgroundColor = .appBackGroundColor
        clipsToBounds = true
        layer.cornerRadius = 8
        
        imageView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(170)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalTo(imageView.snp.left).offset(5)
            make.right.equalTo(imageView.snp.right).offset(-2)
        }
                
        genderLbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(5)
            make.left.equalTo(nameLbl.snp.left)
        }
        
        spicesView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
        
        spicesLbl.snp.makeConstraints { make in
            make.centerY.equalTo(spicesView.snp.centerY)
            make.left.equalToSuperview().offset(7)
            make.right.equalToSuperview().offset(-7)
        }
    }
    
    func configure(character: CharacterItem) {
        
        imageView.kf.setImage(with: URL(string: character.image ?? ""))
        nameLbl.text = character.name
        genderLbl.text = "Gender: \(character.gender?.rawValue ?? "")"
        spicesLbl.text = character.species?.rawValue ?? "" 

        switch character.status {
        case .dead:
            spicesView.backgroundColor = .systemRed
        case .alive:
            spicesView.backgroundColor = .systemGreen
        case .unknown:
            spicesView.backgroundColor = .gray
        default:
            spicesView.backgroundColor = .systemBlue
        }
    }
}
