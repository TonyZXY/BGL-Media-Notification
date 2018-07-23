////
////  testViewController.swift
////  BGLMedia
////
////  Created by Bruce Feng on 23/7/18.
////  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
////
//
//import UIKit
//
//final class LocalePickerViewController: UIViewController {
//    
//    // MARK: UI Metrics
//    
//    struct UI {
//        static let rowHeight = CGFloat(50)
//        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
//    }
//    
//    // MARK: Properties
//    
//    public typealias Selection = (LocaleInfo?) -> Swift.Void
//    
//    public enum Kind {
//        case country
//        case phoneCode
//        case currency
//    }
//    
//    fileprivate var type: Kind
//    fileprivate var selection: Selection?
//    
//    fileprivate var orderedInfo = [String: [LocaleInfo]]()
//    fileprivate var sortedInfoKeys = ["jj","hhk","jhkhkj","jj","hhk","jhkhkj","jj"]
//    fileprivate var filteredInfo: [LocaleInfo] = []
//    fileprivate var selectedInfo: LocaleInfo?
//    
//    fileprivate var searchBarIsActive: Bool = false
//    
//    fileprivate lazy var searchView: UIView = UIView()
//    
//    fileprivate lazy var searchController: UISearchController = { [unowned self] in
//        $0.searchResultsUpdater = self
//        $0.searchBar.delegate = self
//        $0.dimsBackgroundDuringPresentation = false
//        /// true if search bar in tableView header
//        $0.hidesNavigationBarDuringPresentation = true
//        $0.searchBar.searchBarStyle = .minimal
//        $0.searchBar.textField?.textColor = .black
//        $0.searchBar.textField?.clearButtonMode = .whileEditing
//        return $0
//        }(UISearchController(searchResultsController: nil))
//    
//    fileprivate lazy var tableView: UITableView = { [unowned self] in
//        $0.dataSource = self
//        $0.delegate = self
//        $0.rowHeight = UI.rowHeight
//        $0.separatorColor = UI.separatorColor
//        $0.bounces = true
//        $0.backgroundColor = nil
//        $0.tableFooterView = UIView()
//        $0.sectionIndexBackgroundColor = .clear
//        $0.sectionIndexTrackingBackgroundColor = .clear
//        return $0
//        }(UITableView(frame: .zero, style: .plain))
//    
//    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
//        $0.color = .lightGray
//        return $0
//    }(UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge))
//    
//    // MARK: Initialize
//    
//    required init(type: Kind, selection: @escaping Selection) {
//        self.type = type
//        self.selection = selection
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit {
//        // http://stackoverflow.com/questions/32675001/uisearchcontroller-warning-attempting-to-load-the-view-of-a-view-controller/
//        let _ = searchController.view
//        Log("has deinitialized")
//    }
//    
//    override func loadView() {
//        view = tableView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.addSubview(indicatorView)
//        
//        searchView.addSubview(searchController.searchBar)
//        tableView.tableHeaderView = searchView
//        
//        //extendedLayoutIncludesOpaqueBars = true
//        //edgesForExtendedLayout = .bottom
//        definesPresentationContext = true
//        
//        switch type {
//        case .country:
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "uicell")
//        case .phoneCode:
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "uicell")
//        case .currency:
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "uicell")
//        }
//        
//        updateInfo()
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        tableView.tableHeaderView?.height = 57
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.frame.size.width = searchView.frame.size.width
//        searchController.searchBar.frame.size.height = searchView.frame.size.height
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        indicatorView.center = view.center
//        preferredContentSize.height = tableView.contentSize.height
//    }
//    
//    func updateInfo() {
//        indicatorView.startAnimating()
//        
//        LocaleStore.fetch { [unowned self] result in
//            switch result {
//                
//            case .success(let orderedInfo):
//                let data: [String: [LocaleInfo]] = orderedInfo
//                /*
//                 switch self.type {
//                 case .currency:
//                 data = data.filter { i in
//                 guard let code = i.currencyCode else { return false }
//                 return Locale.commonISOCurrencyCodes.contains(code)
//                 }.sorted { $0.currencyCode < $1.currencyCode }
//                 default: break }
//                 */
//                
//                self.orderedInfo = data
//                self.sortedInfoKeys = Array(self.orderedInfo.keys).sorted(by: <)
//                
//                DispatchQueue.main.async {
//                    self.indicatorView.stopAnimating()
//                    self.tableView.reloadData()
//                }
//                
//            case .error(let error):
//                
//                DispatchQueue.main.async {
//                    
//                    let alert = UIAlertController(style: .alert, title: error.title, message: error.message)
//                    alert.addAction(title: "OK", style: .cancel) { action in
//                        self.indicatorView.stopAnimating()
//                        self.alertController?.dismiss(animated: true)
//                    }
//                    alert.show()
//                }
//            }
//        }
//    }
//    
//    func sortFilteredInfo() {
//        filteredInfo = filteredInfo.sorted { lhs, rhs in
//            switch type {
//            case .country:
//                return lhs.country < rhs.country
//            case .phoneCode:
//                return lhs.country < rhs.country
//            case .currency:
//                return lhs.country < rhs.country
//            }
//        }
//    }
//    
//    func info(at indexPath: IndexPath) -> LocaleInfo? {
//        if searchController.isActive {
//            return filteredInfo[indexPath.row]
//        }
//        let key: String = sortedInfoKeys[indexPath.section]
//        if let info = orderedInfo[key]?[indexPath.row] {
//            return info
//        }
//        return nil
//    }
//    
//    func indexPathOfSelectedInfo() -> IndexPath? {
//        guard let selectedInfo = selectedInfo else { return nil }
//        if searchController.isActive {
//            for row in 0 ..< filteredInfo.count {
//                if filteredInfo[row].country == selectedInfo.country {
//                    return IndexPath(row: row, section: 0)
//                }
//            }
//        }
//        for section in 0 ..< sortedInfoKeys.count {
//            if let orderedInfo = orderedInfo[sortedInfoKeys[section]] {
//                for row in 0 ..< orderedInfo.count {
//                    if orderedInfo[row].country == selectedInfo.country {
//                        return IndexPath(row: row, section: section)
//                    }
//                }
//            }
//        }
//        return nil
//    }
//}
//
//// MARK: - UISearchResultsUpdating
//
//extension LocalePickerViewController: UISearchResultsUpdating {
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text, searchController.isActive {
//            filteredInfo = []
//            if searchText.count > 0, let values = orderedInfo[String(searchText[searchText.startIndex])] {
//                filteredInfo.append(contentsOf: values.filter { $0.country.hasPrefix(searchText) })
//            } else {
//                orderedInfo.forEach { key, value in
//                    filteredInfo += value
//                }
//            }
//            sortFilteredInfo()
//        }
//        tableView.reloadData()
//        
//        guard let selectedIndexPath = indexPathOfSelectedInfo() else { return }
//        Log("selectedIndexPath = \(selectedIndexPath)")
//        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
//    }
//}
//
//// MARK: - UISearchBarDelegate
//
//extension LocalePickerViewController: UISearchBarDelegate {
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        
//    }
//}
//
//// MARK: - TableViewDelegate
//
//extension LocalePickerViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let info = info(at: indexPath) else { return }
//        selectedInfo = info
//        selection?(selectedInfo)
//    }
//}
//
//// MARK: - TableViewDataSource
//
//extension LocalePickerViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if searchController.isActive { return 1 }
//        return sortedInfoKeys.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchController.isActive { return filteredInfo.count }
//        if let infoForSection = orderedInfo[sortedInfoKeys[section]] {
//            return infoForSection.count
//        }
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        if searchController.isActive { return 0 }
//        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top , animated: false)
//        return sortedInfoKeys.index(of: title)!
//    }
//    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        if searchController.isActive { return nil }
//        return sortedInfoKeys
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if searchController.isActive { return nil }
//        return sortedInfoKeys[section]
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let info = info(at: indexPath) else { return UITableViewCell() }
//        
//        let cell: UITableViewCell
//        
//        switch type {
//            
//        case .country:
//            cell = tableView.dequeueReusableCell(withIdentifier: "uicell") as! UITableViewCell
//            cell.textLabel?.text = info.country
//            
//        case .phoneCode:
//            cell = tableView.dequeueReusableCell(withIdentifier: "uicell") as! UITableViewCell
//            cell.textLabel?.text = info.phoneCode
//            cell.detailTextLabel?.text = info.country
//            
//        case .currency:
//            cell = tableView.dequeueReusableCell(withIdentifier: "uicell") as! UITableViewCell
//            cell.textLabel?.text = info.currencyCode
//            cell.detailTextLabel?.text = info.country
//        }
//        
//        cell.detailTextLabel?.textColor = .darkGray
//        
//        DispatchQueue.main.async {
//            let size: CGSize = CGSize(width: 32, height: 24)
//            let flag: UIImage? = info.flag?.imageWithSize(size: size, roundedRadius: 3)
//            cell.imageView?.image = flag
//            cell.setNeedsLayout()
//            cell.layoutIfNeeded()
//        }
//        
//        if let selected = selectedInfo, selected.country == info.country {
//            cell.isSelected = true
//        }
//        
//        return cell
//    }
//}
//
//public struct LocaleInfo {
//    
//    public var locale: Locale?
//    
//    public var id: String? {
//        return locale?.identifier
//    }
//    
//    public var country: String
//    public var code: String
//    public var phoneCode: String
//    
//    public var flag: UIImage? {
//        return UIImage(named: "Countries.bundle/Images/\(code.uppercased())", in: Bundle.main, compatibleWith: nil)
//    }
//    
//    public var currencyCode: String? {
//        return locale?.currencyCode
//    }
//    
//    public var currencySymbol: String? {
//        return locale?.currencySymbol
//    }
//    
//    public var currencyName: String? {
//        guard let currencyCode = currencyCode else { return nil }
//        return locale?.localizedString(forCurrencyCode: currencyCode)
//    }
//    
//    init(country: String, code: String, phoneCode: String) {
//        self.country = country
//        self.code = code
//        self.phoneCode = phoneCode
//        
//        self.locale = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first(where: { $0.regionCode == code })
//    }
//}
//
//struct LocaleStore {
//    
//    /// Result Enum
//    ///
//    /// - Success: Returns Grouped By Alphabets Locale Info
//    /// - Error: Returns error
//    public enum GroupedByAlphabetsFetchResults {
//        case success(response: [String: [LocaleInfo]])
//        case error(error: (title: String?, message: String?))
//    }
//    
//    /// Result Enum
//    ///
//    /// - Success: Returns Array of Locale Info
//    /// - Error: Returns error
//    public enum FetchResults {
//        case success(response: [LocaleInfo])
//        case error(error: (title: String?, message: String?))
//    }
//    
//    public static func getInfo(completionHandler: @escaping (FetchResults) -> ()) {
//        let bundle = Bundle(for: LocalePickerViewController.self)
//        let path = "Countries.bundle/Data/CountryCodes"
//        
//        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
//            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
//                let error: (title: String?, message: String?) = (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")
//                return completionHandler(FetchResults.error(error: error))
//        }
//        
//        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
//            var result: [LocaleInfo] = []
//            for jsonObject in jsonObjects {
//                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
//                guard let country = countryObj["name"] as? String,
//                    let code = countryObj["code"] as? String,
//                    let phoneCode = countryObj["dial_code"] as? String else {
//                        continue
//                }
//                let new = LocaleInfo(country: country, code: code, phoneCode: phoneCode)
//                result.append(new)
//            }
//            return completionHandler(FetchResults.success(response: result))
//        }
//        
//        let error: (title: String?, message: String?) = (title: "JSON Error", message: "Couldn't parse json to Info")
//        return completionHandler(FetchResults.error(error: error))
//    }
//    
//    public static func fetch(completionHandler: @escaping (GroupedByAlphabetsFetchResults) -> ()) {
//        LocaleStore.getInfo { result in
//            switch result {
//            case .success(let info):
//                /*
//                 var header = Set<String>()
//                 info.forEach {
//                 let country = $0.country
//                 header.insert(String(country[country.startIndex]))
//                 }
//                 */
//                var data = [String: [LocaleInfo]]()
//                
//                info.forEach {
//                    let country = $0.country
//                    let index = String(country[country.startIndex])
//                    var value = data[index] ?? [LocaleInfo]()
//                    value.append($0)
//                    data[index] = value
//                }
//                
//                data.forEach { key, value in
//                    data[key] = value.sorted(by: { lhs, rhs in
//                        return lhs.country < rhs.country
//                    })
//                }
//                completionHandler(GroupedByAlphabetsFetchResults.success(response: data))
//                
//            case .error(let error):
//                completionHandler(GroupedByAlphabetsFetchResults.error(error: error))
//            }
//        }
//    }
//}
//
//
