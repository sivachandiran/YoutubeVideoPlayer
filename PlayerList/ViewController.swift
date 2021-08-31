//
//  ViewController.swift
//  PlayerList
//
//  Created by SIVA on 30/01/21.
//

import UIKit
import SnapKit
import WebServices
class ViewController: UIViewController, PlayerVCDelegate {

    var arrayOfList : [TrackDetail] = []
    var index : Int = 0
    
    @IBOutlet var playerView: PlayerView!

    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)

    let cellId = "CellVideoCard"

    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    // MARK: - Lazy Properties
    private(set) lazy var header: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.clipsToBounds = false
        return view
    }()
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Videos"
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = UIView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        // register cell name
        table.register(CellVideoCard.self, forCellReuseIdentifier: cellId)
        return table
    }()

    var isHidden = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func setPreferStatusBarHidden(_ preferHidden: Bool) {
        self.isHidden = preferHidden
    }
    
    func updatePlayerView(index : Int) {
        var arrayList : [TrackDetail] = []
        arrayList.append(contentsOf: self.arrayOfList)
        arrayList.remove(at: index)
        self.playerView.arrayOfList = self.arrayOfList
        self.playerView.video = self.arrayOfList[index]
        self.playerView.videoList = arrayList
        self.playerView.tableView.isHidden = false
        self.playerView.tapPlayView()
    }

    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
//                self.playerView.frame = CGRect(x: 0, y: 0, width: ScreenSize.Width, height: ScreenSize.Height)
                self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.hiddenOrigin
            })
        }
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }

    //MARK: Delegate methods
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playerView.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.playerView = PlayerView()
        self.playerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        self.playerView.delegate = self
        self.playerView.setup()
        self.setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }
        sceneDelegate.window?.addSubview(self.playerView)
    }
    
    /// Sets all properties and calls doLayout
    func setup() {
        doLayout()
        arrayOfList.removeAll()
        let webServices = WebServiceManager.init(apiUrl: "https://www.ventunotech.com/en/addemo/testVideoList.json", isRelease: false)
        webServices.fetchVideoList { (data, error) in
            let bandGraph_Base : VideoList_Base = try! JSONDecoder().decode(VideoList_Base.self,from: data)
            self.arrayOfList = (bandGraph_Base.tracklist?.track!)!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    /// Adds all subviews to view hierarchy
    func doLayout() {
        self.view.addSubview(header)
        self.header.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(Paddings.headerHeight)
        }
        header.addSubview(labelTitle)
        labelTitle.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.size.equalTo(Constants.titleLableSize)
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(header.snp.bottom)
            maker.bottom.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellVideoCard", for: indexPath) as! CellVideoCard
        cell.selectionStyle = .none
        cell.setup()
        cell.configure(result: self.arrayOfList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
        var arrayList : [TrackDetail] = []
        arrayList.append(contentsOf: self.arrayOfList)
        arrayList.remove(at: indexPath.row)
        self.playerView.arrayOfList = self.arrayOfList
        self.playerView.video = self.arrayOfList[indexPath.row]
        self.playerView.videoList = arrayList
        self.playerView.tapPlayView()
    }

}
private extension ViewController {

    enum Texts: String {
        case title = " Video"
    }

    struct Constants {

        private init() {}
        static let backSize = CGSize(width: 40, height: 40)
        static let titleLableSize = CGSize(width: 220, height: 30)
        static let insets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)

    }

    struct Paddings {

        private init() {}

        static let headerHeight: CGFloat = 85
        static let backLeading: CGFloat = 7
        static let backTop: CGFloat = -5
    }

}

