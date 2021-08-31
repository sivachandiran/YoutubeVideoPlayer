//
//  PlayerView.swift
//  PlayerList
//
//  Created by SIVA on 30/01/21.
//

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
    func setPreferStatusBarHidden(_ preferHidden: Bool)
    func updatePlayerView(index : Int)
}

import UIKit
import AVFoundation
class PlayerView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var video: TrackDetail!
    var arrayOfList : [TrackDetail] = []
    var videoList : [TrackDetail] = []
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var videoPlayer : AVPlayer?
    var isPlay : Bool = false
    var isMinimize : Bool = false


    let cellHeaderId = "CellHeader"
    let cellId = "CellVideoList"

    // MARK: - Lazy Properties
    private(set) lazy var minimizeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minimize"), for: .normal)
        button.addTarget(self, action: #selector(minimize(_:)), for: .touchUpInside)
        return button
    }()

    private(set) lazy var playButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "playArrow"), for: .normal)
        button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        return button
    }()

    private(set) lazy var playerview: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = false
        return view
    }()

    lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = UIView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 90
        table.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        // register cell name
        table.register(CellHeader.self, forCellReuseIdentifier: cellHeaderId)
        table.register(CellVideoList.self, forCellReuseIdentifier: cellId)
        return table
    }()

    // MARK: - Inits
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //MARK: Methods
    func setup() {
        self.backgroundColor = UIColor.clear
        
        doLayout()

//        Video.fetchVideo { [weak self] downloadedVideo in
//            guard let weakSelf = self else {
//                return
//            }
//        }
    }

    /// Adds all subviews to view hierarchy
    func doLayout() {
        addSubview(playerview)
        playerview.backgroundColor = .black
        playerview.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(211)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.minimizeGesture(_:)))
        self.playerview.addGestureRecognizer(panGesture)
        
        addSubview(playButton)
        playButton.snp.makeConstraints { maker in
            maker.top.equalTo(179/2)
            maker.left.equalTo((ScreenSize.Width - 25)/2)
            maker.width.equalTo(25)
            maker.height.equalTo(32)
        }

        addSubview(minimizeButton)
        minimizeButton.snp.makeConstraints { maker in
            maker.top.equalTo(20)
            maker.left.equalTo(20)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }

        addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(playerview.snp.bottom)
            maker.width.equalTo(ScreenSize.Width)
            maker.height.equalTo(ScreenSize.Height - 211)
        }
        self.playerview.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.playerview.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.playVideo)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("open"), object: nil)
    }
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 1
                self.tableView.alpha = 1
                self.playerview.transform = CGAffineTransform.identity
                self.delegate?.setPreferStatusBarHidden(true)
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.delegate?.setPreferStatusBarHidden(false)
                self.minimizeButton.alpha = 0
                self.tableView.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.playerview.bounds.width/4, y: -self.playerview.bounds.height/4))
                self.playerview.transform = trasform
            })
        default: break
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        self.minimizeButton.alpha = 1 - scaleFactor
        self.tableView.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.playerview.bounds.width / 4 * scaleFactor), y: -(self.playerview.bounds.height / 4 * scaleFactor)))
        self.playerview.transform = trasform
    }
    
    func convertEmaji(_ stringText: String?) -> String? {
        let input = stringText
        let convertedString = input
        let transform = "Any-Hex/Java" as CFString
        CFStringTransform((convertedString as! CFMutableString), nil, transform, true)
        return convertedString
    }

    @objc func playVideo() {
        if(self.state == .minimized) {
            self.tapPlayView()
        }
        else {
            if(self.isPlay) {
                self.isPlay = false
                self.videoPlayer?.pause()
                self.playButton.isHidden = false
            }
            else {
                self.isPlay = true
                self.videoPlayer?.play()
                self.playButton.isHidden = true
            }
        }
    }
    @objc func tapPlayView()  {
        //self.setup()
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
        
        if(self.videoPlayer == nil){
            self.videoPlayer = AVPlayer.init(url: URL(string: (self.video?.content_url)!)!)
            let playerLayer = AVPlayerLayer.init(player: self.videoPlayer)
            playerLayer.frame = self.playerview.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
            self.playerview.layer.addSublayer(playerLayer)
            if self.state != .hidden {
                self.isPlay = true
                self.videoPlayer!.play()
            }
            self.tableView.reloadData()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
          if keyPath == "rate" {
            if self.videoPlayer!.rate == 1  {
                  print("Playing")
                self.playButton.isHidden = true
              }else{
                   print("Stop")
                self.playButton.isHidden = false
              }
          }
     }

    @IBAction func minimize(_ sender: UIButton) {
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
    }
    
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                self.isPlay = false
                self.videoPlayer!.pause()
                self.videoPlayer = nil
            }
        }
    }
    
    //MARK: Delegate & dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.videoList.count == 0) ? 0 : self.videoList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 175 : 95
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellHeader") as! CellHeader
            cell.selectionStyle = .none
            cell.setup()
            cell.labelVideoTitle.text = self.video!.showname
            cell.labelViews.text = String(format: "%d views", self.video!.videoviews!)//"\(self.video!.videoviews) views"
            cell.labelTitle.text = self.convertEmaji(self.video!.videoname)
            if(self.video!.thumbpath! != "") {
                cell.thumbImage.kf.setImage(with: URL(string: self.video!.thumbpath!), placeholder: nil)
            }
            cell.thumbImage.layer.cornerRadius = 25
            cell.thumbImage.clipsToBounds = true
            cell.labelDescription.text = self.convertEmaji(self.video!.description)
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellVideoList", for: indexPath) as! CellVideoList
            cell.setup()
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            let videoDetail : TrackDetail = self.videoList[indexPath.row - 1]
            cell.labelTitle.text = self.convertEmaji(videoDetail.videoname)
            cell.labelDescription.text = self.convertEmaji(videoDetail.description)
            if(videoDetail.thumbpath! != "") {
                cell.thumbImage.kf.setImage(with: URL(string: videoDetail.thumbpath!), placeholder: nil)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.videoPlayer?.pause()
        self.videoPlayer = nil
        self.tableView.isHidden = true
        self.delegate?.updatePlayerView(index: indexPath.row)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
