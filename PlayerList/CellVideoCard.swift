//
//  CellVideoCard.swift
//  PlayerList
//
//  Created by SIVA on 30/01/21.
//

import UIKit
import Kingfisher

class CellVideoCard: UITableViewCell {

    private(set) lazy var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.clipsToBounds = false
        return imageView
    }()

    private(set) lazy var thumbImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24.0
        return imageView
    }()

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = .black
        return label
    }()

    private lazy var labelDescription: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = .black
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setup()
    }
    func configure(result : TrackDetail) {
        if(result.posterpath! != "") {
            self.posterImage.kf.setImage(with: URL(string: result.posterpath!), placeholder: nil)
        }
        if(result.thumbpath! != "") {
            self.thumbImage.kf.setImage(with: URL(string: result.thumbpath!), placeholder: nil)
        }
        labelTitle.text = self.convertEmaji(result.videoname)
        labelDescription.text = self.convertEmaji(result.description)
    }
    func convertEmaji(_ stringText: String?) -> String? {
        let input = stringText
        let convertedString = input
        let transform = "Any-Hex/Java" as CFString
        CFStringTransform((convertedString as! CFMutableString), nil, transform, true)
        return convertedString
    }
    func setup() {
        backgroundColor = .clear
        doLayout()
    }
    func doLayout() {
        addSubview(posterImage)
        posterImage.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.width.equalTo(ScreenSize.Width)
            maker.height.equalTo(193)
        }
        addSubview(thumbImage)
        thumbImage.snp.makeConstraints { maker in
            maker.top.equalTo(posterImage.snp.bottom).offset(10)
            maker.left.equalTo(16)
            maker.width.equalTo(48)
            maker.height.equalTo(48)
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { maker in
            maker.top.equalTo(posterImage.snp.bottom).offset(10)
            maker.left.equalTo(thumbImage.snp.right).offset(8)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 88, height: 40))
        }
        addSubview(labelDescription)
        labelDescription.snp.makeConstraints { maker in
            maker.top.equalTo(labelTitle.snp.bottom).offset(2)
            maker.left.equalTo(thumbImage.snp.right).offset(8)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 88, height: 20))
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
