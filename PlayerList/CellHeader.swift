//
//  CellHeader.swift
//  PlayerList
//
//  Created by SIVA on 30/01/21.
//

import UIKit

class CellHeader: UITableViewCell {

    lazy var labelVideoTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = .black
        return label
    }()

    lazy var labelViews: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = .black
        return label
    }()

    lazy var labelLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }()

    lazy var thumbImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = 24.0
        return imageView
    }()

    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = .black
        return label
    }()

    lazy var labelDescription: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "HelveticaNeue", size: 13)
        label.textColor = .black
        return label
    }()
    lazy var labelEndLine: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    func setup() {
        backgroundColor = .clear
        doLayout()
//        arrayOfList.removeAll()
    }
    func doLayout() {
        
        addSubview(labelVideoTitle)
        labelVideoTitle.snp.makeConstraints { maker in
            maker.top.equalTo(24)
            maker.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 40, height: 20))
        }
        addSubview(labelViews)
        labelViews.snp.makeConstraints { maker in
            maker.top.equalTo(labelVideoTitle.snp.bottom).offset(2)
            maker.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 40, height: 20))
        }
        addSubview(labelLine)
        labelLine.snp.makeConstraints { maker in
            maker.top.equalTo(labelViews.snp.bottom).offset(10)
            maker.left.equalTo(safeAreaLayoutGuide.snp.left)
            maker.size.equalTo(CGSize(width: ScreenSize.Width, height: 1))
        }

        addSubview(thumbImage)
        thumbImage.snp.makeConstraints { maker in
            maker.top.equalTo(labelLine.snp.bottom).offset(10)
            maker.left.equalTo(16)
            maker.width.equalTo(48)
            maker.height.equalTo(48)
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { maker in
            maker.top.equalTo(labelLine.snp.bottom).offset(10)
            maker.left.equalTo(thumbImage.snp.right).offset(8)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 88, height: 40))
        }
        addSubview(labelDescription)
        labelDescription.snp.makeConstraints { maker in
            maker.top.equalTo(labelTitle.snp.bottom).offset(2)
            maker.left.equalTo(thumbImage.snp.right).offset(8)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 88, height: 35))
        }
        addSubview(labelEndLine)
        labelEndLine.snp.makeConstraints { maker in
            maker.top.equalTo(174)
            maker.left.equalTo(safeAreaLayoutGuide.snp.left)
            maker.size.equalTo(CGSize(width: ScreenSize.Width, height: 1))
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
