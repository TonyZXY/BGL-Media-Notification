import UIKit
import RealmSwift
import UserNotifications
import Alamofire
import SwiftyJSON
import JGProgressHUD
import SwiftKeychainWrapper


struct GameAlertResult{
    var isExpanded:Bool = false
    var coinName: String = ""
    var coinAbbName: String = ""
    var avaliable: Bool = true
    var name: [GameAlertObject] = [GameAlertObject]()
}


class GameAlertController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var token : NotificationToken?
    
    var oldAlerts = [Int:Bool]()
    var alerts:[GameAlertResult] = [GameAlertResult]()
    var status = ""
    var coinName = coinAlert()
    
    
    
    var factor:CGFloat?{
        didSet{
            
        }
    }
    
    var allAlert: [GameAlertResult]{
        get{
            var allResult = [GameAlertResult]()
            let results = try!Realm().objects(GameAlertObject.self)
            var coinNameResults = try!Realm().objects(alertCoinNames.self)
            if coinName.status{
                coinNameResults = coinNameResults.filter("coinAbbName = '" + coinName.coinAbbName + "' ")
            }
            
            for value in coinNameResults{
                var gameAlertResult = GameAlertResult()
                let specificCoins = results.filter("coinAbbName = '" + value.coinAbbName + "' ")
                gameAlertResult.isExpanded = false
                gameAlertResult.coinAbbName = value.coinAbbName
                gameAlertResult.coinName = value.coinName
                for result in specificCoins {
                    gameAlertResult.name.append(result)
                }
                allResult.append(gameAlertResult)
            }
            
            return allResult
        }
    }
    
    
    var allGameAlerts: Results<GameAlertObject> {
        get{
            return try! Realm().objects(GameAlertObject.self).sorted(byKeyPath: "dateTime", ascending: false)
        }
    }
    
    
    var email:String{
        get{
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
        }
    }
    
    var certificateToken: String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        }
    }
    
    var userID: String {
        get{
            return UserDefaults.standard.string(forKey: "user_id") ?? "null"
        }
    }
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    

    
    lazy var alertButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(textValue(name: "addAlert_alert"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewGameAlert), for: .touchUpInside)
        return button
    }()
    
    lazy var alertTableView:UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: "editAlertCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 30*factor!
        tableView.bounces = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var alertOpenButton:UIButton = {
        var button = UIButton(type:.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.red
        button.setTitle("Open Notification", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(deviceSetting), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    var alertHintLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "If you want to use alert functions, you need to go to setting page to open it, click the button and towards to setting page"
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = label.font.withSize(13)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    var alertMainHintLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Open your Notification"
        label.font = label.font.withSize(20)
        label.textColor = UIColor.white
        return label
    }()
    
    var alertHintView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var alertView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.backgroundColor = ThemeColor().blueColor()
        return view
    }()
    
    var loginView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var loginMainLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = textValue(name: "needLoginLabel")
        label.textColor = ThemeColor().whiteColor()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    var loginLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.text = textValue(name: "needLoginText")
        label.textAlignment = .center
        label.font = label.font.withSize(13)
        return label
    }()
    
    var loginButton:UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(textValue(name: "login"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        return button
    }()
    
    var safeAreaView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().blueColor()
        return view
    }()
    
    
    

    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAlert"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts = allAlert
        //        view.backgroundColor = ThemeColor().blueColor()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGameNotificationStatus), name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addAlerts), name: NSNotification.Name(rawValue: "addAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        for result in allGameAlerts{
            oldAlerts[result.id] = result.switchStatus
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkSetUpView()
        if status == "setting"{
            getNotification()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool){
        if status == "setting"{
            if checkAlertStatusChange(){
                self.sendNotification()
            }
        } else if status == "detailPage"{
            if checkAlertStatusChange(){
                sendNotification()
            }
        }
    }
    
    func getNotification(){
        if loginStatus{
            writeAlertToRealm()
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let coinImage = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        coinImage.frame = CGRect(x: 0, y: 0, width: 30*factor!, height: 30*factor!)
        coinImage.clipsToBounds = true
        coinImage.coinImageSetter(coinName: alerts[section].name[0].coinAbbName, width: 30*factor!, height: 30*factor!, fontSize: 5*factor!)
        coinImage.contentMode = UIViewContentMode.scaleAspectFit
        coinImage.translatesAutoresizingMaskIntoConstraints = false
        
        let coinLabel = UILabel()
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.textColor = ThemeColor().whiteColor()
        coinLabel.font = UIFont.regularFont(17*factor!)
        coinLabel.text = alerts[section].coinName
        
        let avaliableLabel = UILabel()
        avaliableLabel.textColor = ThemeColor().redColor()
        avaliableLabel.translatesAutoresizingMaskIntoConstraints = false
        avaliableLabel.font = UIFont.regularFont(17*factor!)
        if !alerts[section].avaliable{
            avaliableLabel.text = "Unavaliable!"
        }
        
        
        
        let button = UIButton(type:.system)
        let isExpanded = alerts[section].isExpanded
        button.setTitle(!isExpanded ? "▼":"▲", for: .normal)
        //        button.backgroundColor = ThemeColor().greenColor()
        button.contentEdgeInsets = UIEdgeInsetsMake(0, view.frame.width, 0, 0)
        button.titleLabel?.font = UIFont.regularFont(25*factor!)
        //        button.backgroundColor = ThemeColor().bglColor()
        button.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        
        sectionView.clipsToBounds = true
        sectionView.addSubview(button)
        sectionView.addSubview(coinImage)
        sectionView.addSubview(coinLabel)
        sectionView.addSubview(avaliableLabel)
        
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        //        views.translatesAutoresizingMaskIntoConstraints = false
        
        sectionView.layer.borderWidth = 0.5
        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinImage, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: avaliableLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor!)-[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-\(10*factor!)-[v0]-\(5*factor!)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coinImage,"v2":avaliableLabel]))
        
        //        avaliableLabel.rightAnchor.constraint(lessThanOrEqualTo: button.leftAnchor, constant: 10).isActive = true
        //        avaliableLabel.rightAnchor.constraint(greaterThanOrEqualTo: button.leftAnchor, constant: 10).isActive = true
        avaliableLabel.trailingAnchor.constraint(lessThanOrEqualTo: sectionView.trailingAnchor, constant: -40*factor!).isActive = true
        
        
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button,"v1":avaliableLabel]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button]))
        
        
        return sectionView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !alerts[section].isExpanded{
            return 0
        }
        return alerts[section].name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editAlertCell", for: indexPath) as! GameAlertTableCell
        
        let object = alerts[indexPath.section].name[indexPath.row]
        cell.factor = factor!
        cell.object = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertEdit = GameAlertManageController()
        alertEdit.alertObject.coinAbbName = alerts[indexPath.section].name[indexPath.row].coinAbbName
        alertEdit.alertObject.coinName = alerts[indexPath.section].name[indexPath.row].coinName
        alertEdit.alertObject.inputPrice = alerts[indexPath.section].name[indexPath.row].inputPrice
        alertEdit.alertObject.id =   alerts[indexPath.section].name[indexPath.row].id
        alertEdit.status = "Update"
        navigationController?.pushViewController(alertEdit, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 * factor!
    }
    
    
    func checkSetUpView() {
        if loginStatus{
            setUpView()
        } else{
            setUpLoginView()
        }
    }
    
    @objc func changeLanguage(){
        checkSetUpView()
        alertButton.setTitle(textValue(name: "addAlert_alert"), for: .normal)
        loginMainLabel.text = textValue(name: "needLoginLabel")
        loginLabel.text = textValue(name: "needLoginText")
        loginButton.setTitle(textValue(name: "login"), for: .normal)
    }
    
    @objc func refreshGameNotificationStatus(){
        getNotificationStatus()
    }
    
    
    @objc func login(){
        let loginPage = LoginController(usedPlace: 0)
        self.present(loginPage, animated: true, completion: nil)
    }
    
    @objc func addAlerts(){
        alerts = allAlert
        alertTableView.reloadData()
    }
    
    
    @objc func deviceSetting(){
        let alertController = UIAlertController(title: "Alert Title is here", message: "Alert Description is here", preferredStyle: .alert)
        
        // Setting button action
        let settingsAction = UIAlertAction(title: "Go to Setting", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        
        alertController.addAction(settingsAction)
        // Cancel button action
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ (_) -> Void in
            // Magic is here for cancel button
        }
        alertController.addAction(cancelAction)
        // This part is important to show the alert controller ( You may delete "self." from present )
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func handleExpandClose(button:UIButton ){
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in alerts[section].name.indices{
            let indexPath = IndexPath(row:row,section:section)
            indexPaths.append(indexPath)
        }
        let isExpanded = alerts[section].isExpanded
        alerts[section].isExpanded = !isExpanded
        
        
        button.setTitle(isExpanded ? "▼":"▲", for: .normal)
        
        if !isExpanded{
            alertTableView.insertRows(at: indexPaths, with: .fade)
        } else{
            alertTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    
    
    
    @objc func addNewGameAlert(){
        let alert = GameAlertManageController()
        if coinName.status{
            alert.coinName.status = true
            alert.coinName.coinAbbName = coinName.coinAbbName
            alert.coinName.coinName = coinName.coinName
        }
        
        navigationController?.pushViewController(alert, animated: true)
    }
    
    func checkAlertStatusChange()->Bool{
        for results in allGameAlerts{
            if results.switchStatus != oldAlerts[results.id]{
                return true
            }
        }
        return false
    }
    
    
    func sendNotification(){
        var alertStatus = [[String:Any]]()
        
        for result in allGameAlerts{
            let alert:[String:Any] = ["id":result.id,"coinName":result.coinAbbName,"price":result.inputPrice,"status":result.switchStatus,"isGreater":result.compareStatus]
            alertStatus.append(alert)
        }
        
        if alertStatus.count != 0{
            let body:[String:Any] = ["email":email,"token":certificateToken,"user_id": userID,"alerts":alertStatus]
            URLServices.fetchInstance.passServerData(urlParameters: ["game","changeAlertNotifications"], httpMethod: "POST", parameters: body) { (response, success) in
                if success{}
            }
        }
    }
    
    
    
    func getNotificationStatus(){
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
            }
            
            if settings.authorizationStatus == .denied {
                UserDefaults.standard.set(false, forKey: "NotificationSetting")
                // Notification permission was previously denied, go to settings & privacy to re-enable
            }
            
            if settings.authorizationStatus == .authorized {
                UserDefaults.standard.set(true, forKey: "NotificationSetting")
                // Notification permission was already gransnted
            }
            
            DispatchQueue.main.async {
                self.checkSetUpView()
            }
        })
    }
    
    
    func writeAlertToRealm(){
        let body:[String:Any] = ["email":email,"token":certificateToken, "user_id": userID]
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: (self.parent?.view)!)
        URLServices.fetchInstance.passServerData(urlParameters:["game","getAlertList"],httpMethod:"POST",parameters:body){(response, pass) in
            if pass{
                let responseSuccess = response["success"].bool ?? false
                if responseSuccess{
                    self.writeRealm(json:response){(pass) in
                        if pass{
                            DispatchQueue.main.async {
                                self.alerts = self.allAlert
                                self.alertTableView.reloadData()
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    hud.dismiss()
                                }
                            }
                        } else{
                            self.alerts = self.allAlert
                            self.alertTableView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                hud.dismiss()
                            }
                        }
                    }
                } else{
                    let code = response["code"].int ?? 0
                    if code == 800{
                        
                        deleteMemory()
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.textLabel.text = textValue(name: "hud_Error")
                        hud.detailTextLabel.text = textValue(name: "hud_passwordReset") // To change?
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "resetDevice_title"), comment: ""), message: NSLocalizedString(textValue(name: "resetDevice_description"), comment: ""), preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "resetDevice_confirm"), comment: ""), style: .destructive) { (_) in
                            self.checkSetUpView()
                        }
                        confirmAlertCtrl.addAction(confirmAction)
                        self.present(confirmAlertCtrl, animated: true, completion: nil)
                    } else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }
                }
            } else{
                let manager = NetworkReachabilityManager()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                if !(manager?.isReachable)! {
                    hud.textLabel.text = textValue(name: "hud_Error")
                    hud.detailTextLabel.text = "No Network" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                } else {
                    hud.textLabel.text = textValue(name: "hud_Error")
                    hud.detailTextLabel.text = "Time Out" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                }
            }
        }
    }
    
    
    func writeRealm(json:JSON,completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        if json["success"].bool!{
            for result in json["data"].array!{
                realm.beginWrite()
                let id = result["_id"].int ?? 0
                let coinName = result["from"].string ?? "null"
                let coinAbbName = result["from"].string ?? "null"
                let comparePice = result["price"].double ?? 0
                let compareStatus = result["isgreater"].int ?? 0
                let switchStatus = result["status"].bool ?? true
                
                let realmData:[Any] = [id,coinName,coinAbbName,comparePice,compareStatus,switchStatus,Date()]
                if realm.object(ofType: GameAlertObject.self, forPrimaryKey: id) == nil {
                    realm.create(GameAlertObject.self, value: realmData)
                } else {
                    realm.create(GameAlertObject.self, value: realmData, update: true)
                }
                
                if realm.object(ofType: alertCoinNames.self, forPrimaryKey: coinAbbName) == nil {
                    realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!])
                } else {
                    realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!], update: true)
                }
                try! realm.commitWrite()
                oldAlerts[id] = switchStatus
            }
            completion(true)
        } else{
            try! realm.write {
                realm.delete(realm.objects(alertObject.self))
            }
            completion(false)
        }
    }
    
    
    func setUpView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        view.addSubview(alertView)
        alertButton.titleLabel?.font = UIFont.semiBoldFont(18 * factor!)
        alertView.addSubview(alertTableView)
        alertView.addSubview(alertButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        
        alertButton.topAnchor.constraint(equalTo: alertTableView.bottomAnchor).isActive = true
        alertButton.heightAnchor.constraint(equalToConstant: 60*factor!).isActive = true
        if #available(iOS 11.0, *) {
            alertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            view.addSubview(safeAreaView)
            safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            safeAreaView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        } else {
            alertButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        
    }
    
    
    func setUpLoginView(){
        view.addSubview(loginView)
        loginLabel.font = UIFont.regularFont(13*factor!)
        loginButton.layer.cornerRadius = 20*factor!
        loginButton.titleLabel?.font = UIFont.semiBoldFont(18*factor!)
        loginMainLabel.font = UIFont.regularFont(20*factor!)
        loginView.addSubview(loginLabel)
        loginView.addSubview(loginButton)
        loginView.addSubview(loginMainLabel)
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginView]))
        
        
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(30*factor!)-[v1]-\(10*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginMainLabel]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(10*factor!)-[v1(\(50*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1(\(200 * factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginMainLabel,"v1":loginButton]))
    }
    
    func setUpNoNotificationView(){
        view.addSubview(alertHintView)
        alertMainHintLabel.font = UIFont.regularFont(20*factor!)
        alertHintLabel.font = UIFont.regularFont(13*factor!)
        alertButton.layer.cornerRadius = 15*factor!
        alertButton.titleLabel?.font = UIFont.semiBoldFont(18*factor!)
        alertHintView.addSubview(alertMainHintLabel)
        alertHintView.addSubview(alertHintLabel)
        alertHintView.addSubview(alertOpenButton)
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintView]))
        
        
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(30*factor!)-[v1]-\(10*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertMainHintLabel]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(10*factor!)-[v1(\(50*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(40*factor!)-[v1]-\(40*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertMainHintLabel,"v1":alertOpenButton]))
    }
    
    
    
    
    
    
    
    
    

    
}
