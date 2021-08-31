//
//  CellVideoList.swift
//  PlayerList
//
//  Created by SIVA on 30/01/21.
//

import UIKit

class CellVideoList: UITableViewCell {

    lazy var thumbImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.tintColor = .white
        imageView.clipsToBounds = true
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
    }

    func setup() {
        backgroundColor = .clear
        doLayout()
//        arrayOfList.removeAll()
    }
    func doLayout() {
        
        addSubview(thumbImage)
        thumbImage.snp.makeConstraints { maker in
            maker.top.equalTo(10)
            maker.left.equalTo(10)
            maker.width.equalTo(124)
            maker.height.equalTo(65)
        }
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { maker in
            maker.top.equalTo(18)
//            maker.top.equalTo(thumbImage.snp.top).offset(-8)
            maker.left.equalTo(156)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 166, height: 40))
        }
        addSubview(labelDescription)
        labelDescription.snp.makeConstraints { maker in
            maker.top.equalTo(labelTitle.snp.bottom).offset(2)
            maker.left.equalTo(156)
            maker.size.equalTo(CGSize(width: ScreenSize.Width - 166, height: 20))
        }
        addSubview(labelEndLine)
        labelEndLine.snp.makeConstraints { maker in
            maker.top.equalTo(94)
            maker.left.equalTo(safeAreaLayoutGuide.snp.left)
            maker.size.equalTo(CGSize(width: ScreenSize.Width, height: 1))
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
