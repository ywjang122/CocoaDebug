//
//  Example
//  man.li
//
//  Created by man.li on 11/11/2018.
//  Copyright © 2020 man.li. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    var reachEndDefault: Bool = true
    var reachEndColor: Bool = true
    var reachEndWeb: Bool = true
    
    var firstInDefault: Bool = true
    var firstInColor: Bool = true
    var firstInWeb: Bool = true
    
    var selectedSegmentIndex: Int = 0
    var selectedSegment_0: Bool = false
    var selectedSegment_1: Bool = false
    var selectedSegment_2: Bool = false
    
    var defaultReloadDataFinish: Bool = true
    var colorReloadDataFinish: Bool = true
    var webReloadDataFinish: Bool = true
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var deleteItem: UIBarButtonItem!
    
    @IBOutlet weak var defaultTableView: UITableView!
    @IBOutlet weak var defaultSearchBar: UISearchBar!
    var defaultModels: [_OCLogModel] = [_OCLogModel]()
    var defaultCacheModels: Array<_OCLogModel>?
    var defaultSearchModels: Array<_OCLogModel>?
    
    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var colorSearchBar: UISearchBar!
    var colorModels: [_OCLogModel] = [_OCLogModel]()
    var colorCacheModels: Array<_OCLogModel>?
    var colorSearchModels: Array<_OCLogModel>?
    
    @IBOutlet weak var webTableView: UITableView!
    @IBOutlet weak var webSearchBar: UISearchBar!
    var webModels: [_OCLogModel] = [_OCLogModel]()
    var webCacheModels: Array<_OCLogModel>?
    var webSearchModels: Array<_OCLogModel>?
    
    
    
    //MARK: - tool
    //搜索逻辑
    func searchLogic(_ searchText: String = "") {
        
        if selectedSegmentIndex == 0
        {
            guard let defaultCacheModels = defaultCacheModels else {return}
            defaultSearchModels = defaultCacheModels
            
            if searchText == "" {
                defaultModels = defaultCacheModels
            } else {
                guard let defaultSearchModels = defaultSearchModels else {return}
                
                for _ in defaultSearchModels {
                    if let index = self.defaultSearchModels?.firstIndex(where: { (model) -> Bool in
                        return !model.content.lowercased().contains(searchText.lowercased())//忽略大小写
                    }) {
                        self.defaultSearchModels?.remove(at: index)
                    }
                }
                defaultModels = self.defaultSearchModels ?? []
            }
        }
        else if selectedSegmentIndex == 1
        {
            guard let colorCacheModels = colorCacheModels else {return}
            colorSearchModels = colorCacheModels
            
            if searchText == "" {
                colorModels = colorCacheModels
            } else {
                guard let colorSearchModels = colorSearchModels else {return}
                
                for _ in colorSearchModels {
                    if let index = self.colorSearchModels?.firstIndex(where: { (model) -> Bool in
                        return !model.content.lowercased().contains(searchText.lowercased())//忽略大小写
                    }) {
                        self.colorSearchModels?.remove(at: index)
                    }
                }
                colorModels = self.colorSearchModels ?? []
            }
        }
        else
        {
            guard let webCacheModels = webCacheModels else {return}
            webSearchModels = webCacheModels
            
            if searchText == "" {
                webModels = webCacheModels
            } else {
                guard let webSearchModels = webSearchModels else {return}
                
                for _ in webSearchModels {
                    if let index = self.webSearchModels?.firstIndex(where: { (model) -> Bool in
                        return !model.content.lowercased().contains(searchText.lowercased())//忽略大小写
                    }) {
                        self.webSearchModels?.remove(at: index)
                    }
                }
                webModels = self.webSearchModels ?? []
            }
        }
    }
    
    //MARK: - private
    func reloadLogs(needScrollToEnd: Bool = false, needReloadData: Bool = true) {
        
        if selectedSegmentIndex == 0
        {
            if defaultReloadDataFinish == false {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
                if self?.defaultSearchBar.isHidden == true {
                    self?.defaultSearchBar.isHidden = false
                }
            }
            
            
            defaultTableView.isHidden = false
            colorTableView.isHidden = true
            webTableView.isHidden = true
            
            if needReloadData == false && defaultModels.count > 0 {return}
            
            if let arr = _OCLogStoreManager.shared().defaultLogArray {
                defaultModels = arr as! [_OCLogModel]
            }
            
            self.defaultCacheModels = self.defaultModels
            
            self.searchLogic(CocoaDebugSettings.shared.logSearchWordDefault ?? "")
            
            dispatch_main_async_safe { [weak self] in
                self?.defaultReloadDataFinish = false
                self?.defaultTableView.reloadData {
                    self?.defaultReloadDataFinish = true
                }
                
                if needScrollToEnd == false {return}
                
                //table下滑到底部
                guard let count = self?.defaultModels.count else {return}
                if count > 0 {
                    guard let firstInDefault = self?.firstInDefault else {return}
                    self?.defaultTableView.tableViewScrollToBottom(animated: !firstInDefault)
                    self?.firstInDefault = false
                }
            }
        }
        else if selectedSegmentIndex == 1
        {
            if colorReloadDataFinish == false {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
                if self?.colorSearchBar.isHidden == true {
                    self?.colorSearchBar.isHidden = false
                }
            }
            
            
            defaultTableView.isHidden = true
            colorTableView.isHidden = false
            webTableView.isHidden = true
            
            if needReloadData == false && colorModels.count > 0 {return}
            
            if let arr = _OCLogStoreManager.shared().colorLogArray {
                colorModels = arr as! [_OCLogModel]
            }
            
            self.colorCacheModels = self.colorModels
            
            self.searchLogic(CocoaDebugSettings.shared.logSearchWordColor ?? "")
            
            dispatch_main_async_safe { [weak self] in
                self?.colorReloadDataFinish = false
                self?.colorTableView.reloadData {
                    self?.colorReloadDataFinish = true
                }
                
                if needScrollToEnd == false {return}
                
                //table下滑到底部
                guard let count = self?.colorModels.count else {return}
                if count > 0 {
                    guard let firstInColor = self?.firstInColor else {return}
                    self?.colorTableView.tableViewScrollToBottom(animated: !firstInColor)
                    self?.firstInColor = false
                }
            }
        }
        else
        {
            if webReloadDataFinish == false {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
                if self?.webSearchBar.isHidden == true {
                    self?.webSearchBar.isHidden = false
                }
            }
            
            
            defaultTableView.isHidden = true
            colorTableView.isHidden = true
            webTableView.isHidden = false
            
            if needReloadData == false && webModels.count > 0 {return}
            
            if let arr = _OCLogStoreManager.shared().webLogArray {
                webModels = arr as! [_OCLogModel]
            }
            
            self.webCacheModels = self.webModels
            
            self.searchLogic(CocoaDebugSettings.shared.logSearchWordWeb ?? "")
            
            dispatch_main_async_safe { [weak self] in
                self?.webReloadDataFinish = false
                self?.webTableView.reloadData {
                    self?.webReloadDataFinish = true
                }
                
                if needScrollToEnd == false {return}
                
                //table下滑到底部
                guard let count = self?.webModels.count else {return}
                if count > 0 {
                    guard let firstInWeb = self?.firstInWeb else {return}
                    self?.webTableView.tableViewScrollToBottom(animated: !firstInWeb)
                    self?.firstInWeb = false
                }
            }
        }
    }
    
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(didTapView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        deleteItem.tintColor = Color.mainGreen
        segmentedControl.tintColor = Color.mainGreen
        
        if UIScreen.main.bounds.size.width == 320 {
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], for: .normal)
        } else {
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        }
        
        //notification
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLogs_notification), name: NSNotification.Name(rawValue: "refreshLogs_CocoaDebug"), object: nil)

        
        defaultTableView.tableFooterView = UIView()
        defaultTableView.delegate = self
        defaultTableView.dataSource = self
//        defaultTableView.rowHeight = UITableViewAutomaticDimension
        defaultSearchBar.delegate = self
        defaultSearchBar.text = CocoaDebugSettings.shared.logSearchWordDefault
        defaultSearchBar.isHidden = true
        //抖动bug
        defaultTableView.estimatedRowHeight = 0
        defaultTableView.estimatedSectionHeaderHeight = 0
        defaultTableView.estimatedSectionFooterHeight = 0
        
        
        
        colorTableView.tableFooterView = UIView()
        colorTableView.delegate = self
        colorTableView.dataSource = self
//        colorTableView.rowHeight = UITableViewAutomaticDimension
        colorSearchBar.delegate = self
        colorSearchBar.text = CocoaDebugSettings.shared.logSearchWordColor
        colorSearchBar.isHidden = true
        //抖动bug
        colorTableView.estimatedRowHeight = 0
        colorTableView.estimatedSectionHeaderHeight = 0
        colorTableView.estimatedSectionFooterHeight = 0
        
        
        
        webTableView.tableFooterView = UIView()
        webTableView.delegate = self
        webTableView.dataSource = self
//        webTableView.rowHeight = UITableViewAutomaticDimension
        webSearchBar.delegate = self
        webSearchBar.text = CocoaDebugSettings.shared.logSearchWordWeb
        webSearchBar.isHidden = true
        //抖动bug
        webTableView.estimatedRowHeight = 0
        webTableView.estimatedSectionHeaderHeight = 0
        webTableView.estimatedSectionFooterHeight = 0
        
        
        
        //segmentedControl
        selectedSegmentIndex = CocoaDebugSettings.shared.logSelectIndex 
        segmentedControl.selectedSegmentIndex = selectedSegmentIndex
        
        if selectedSegmentIndex == 0 {
            selectedSegment_0 = true
        } else if selectedSegmentIndex == 1 {
            selectedSegment_1 = true
        } else {
            selectedSegment_2 = true
        }
        
        reloadLogs(needScrollToEnd: true, needReloadData: true)

        
        
        //hide searchBar icon
        let textFieldInsideSearchBar = defaultSearchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.leftViewMode = .never
        textFieldInsideSearchBar.leftView = nil
        textFieldInsideSearchBar.backgroundColor = .white
        textFieldInsideSearchBar.returnKeyType = .default

        let textFieldInsideSearchBar2 = colorSearchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar2.leftViewMode = .never
        textFieldInsideSearchBar2.leftView = nil
        textFieldInsideSearchBar2.backgroundColor = .white
        textFieldInsideSearchBar2.returnKeyType = .default

        let textFieldInsideSearchBar3 = webSearchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar3.leftViewMode = .never
        textFieldInsideSearchBar3.leftView = nil
        textFieldInsideSearchBar3.backgroundColor = .white
        textFieldInsideSearchBar3.returnKeyType = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        defaultSearchBar.resignFirstResponder()
        colorSearchBar.resignFirstResponder()
        webSearchBar.resignFirstResponder()
    }
    
    deinit {
        //notification
        NotificationCenter.default.removeObserver(self)
    }

    
    //MARK: - target action
    @IBAction func didTapDown(_ sender: Any) {
        if selectedSegmentIndex == 0
        {
            defaultTableView.tableViewScrollToBottom(animated: true)
            defaultSearchBar.resignFirstResponder()
            reachEndDefault = true
        }
        else if selectedSegmentIndex == 1
        {
            colorTableView.tableViewScrollToBottom(animated: true)
            colorSearchBar.resignFirstResponder()
            reachEndColor = true
        }
        else
        {
            webTableView.tableViewScrollToBottom(animated: true)
            webSearchBar.resignFirstResponder()
            reachEndWeb = true
        }
    }
    
    @IBAction func didTapUp(_ sender: Any) {
        if selectedSegmentIndex == 0
        {
            defaultTableView.tableViewScrollToHeader(animated: true)
            defaultSearchBar.resignFirstResponder()
            reachEndDefault = false
        }
        else if selectedSegmentIndex == 1
        {
            colorTableView.tableViewScrollToHeader(animated: true)
            colorSearchBar.resignFirstResponder()
            reachEndColor = false
        }
        else
        {
            webTableView.tableViewScrollToHeader(animated: true)
            webSearchBar.resignFirstResponder()
            reachEndWeb = false
        }
    }
    
    
    @IBAction func resetLogs(_ sender: Any) {
        if selectedSegmentIndex == 0
        {
            defaultModels = []
            defaultCacheModels = []
//            defaultSearchBar.text = nil
            defaultSearchBar.resignFirstResponder()
//            CocoaDebugSettings.shared.logSearchWordDefault = nil
            
            _OCLogStoreManager.shared().resetDefaultLogs()
            
            dispatch_main_async_safe { [weak self] in
                self?.defaultTableView.reloadData()
            }
        }
        else if selectedSegmentIndex == 1
        {
            colorModels = []
            colorCacheModels = []
//            colorSearchBar.text = nil
            colorSearchBar.resignFirstResponder()
//            CocoaDebugSettings.shared.logSearchWordColor = nil
            
            _OCLogStoreManager.shared().resetColorLogs()
            
            dispatch_main_async_safe { [weak self] in
                self?.colorTableView.reloadData()
            }
        }
        else
        {
            webModels = []
            webCacheModels = []
//            webSearchBar.text = nil
            webSearchBar.resignFirstResponder()
//            CocoaDebugSettings.shared.logSearchWordWeb = nil
            
            _OCLogStoreManager.shared().resetWebLogs()
            
            dispatch_main_async_safe { [weak self] in
                self?.webTableView.reloadData()
            }
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        CocoaDebugSettings.shared.logSelectIndex = selectedSegmentIndex
        
        if selectedSegmentIndex == 0 {
            colorSearchBar.resignFirstResponder()
            webSearchBar.resignFirstResponder()
        } else if selectedSegmentIndex == 1 {
            defaultSearchBar.resignFirstResponder()
            webSearchBar.resignFirstResponder()
        } else {
            defaultSearchBar.resignFirstResponder()
            colorSearchBar.resignFirstResponder()
        }
        
        if selectedSegmentIndex == 0 && selectedSegment_0 == false {
            selectedSegment_0 = true
            reloadLogs(needScrollToEnd: true, needReloadData: true)
            return
        }
        
        if selectedSegmentIndex == 1 && selectedSegment_1 == false {
            selectedSegment_1 = true
            reloadLogs(needScrollToEnd: true, needReloadData: true)
            return
        }
        
        if selectedSegmentIndex == 2 && selectedSegment_2 == false {
            selectedSegment_2 = true
            reloadLogs(needScrollToEnd: true, needReloadData: true)
            return
        }
        
        reloadLogs(needScrollToEnd: false, needReloadData: false)
    }
    
    @objc func didTapView() {
        if selectedSegmentIndex == 0 {
            defaultSearchBar.resignFirstResponder()
        } else if selectedSegmentIndex == 1 {
            colorSearchBar.resignFirstResponder()
        } else {
            webSearchBar.resignFirstResponder()
        }
    }
    
    
    //MARK: - notification
    @objc func refreshLogs_notification() {
        dispatch_main_async_safe { [weak self] in
            if self?.selectedSegmentIndex == 0 {
                self?.reloadLogs(needScrollToEnd: self?.reachEndDefault ?? true, needReloadData: true)
            } else if self?.selectedSegmentIndex == 1 {
                self?.reloadLogs(needScrollToEnd: self?.reachEndColor ?? true, needReloadData: true)
            } else {
                self?.reloadLogs(needScrollToEnd: self?.reachEndWeb ?? true, needReloadData: true)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension LogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == defaultTableView {
            return defaultModels.count
        } else if tableView == colorTableView {
            return colorModels.count
        } else {
            return webModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell
        
        if tableView == defaultTableView
        {
            //否则偶尔crash
            if indexPath.row >= defaultModels.count {
                return UITableViewCell()
            }
            
            cell.model = defaultModels[indexPath.row]
        }
        else if tableView == colorTableView
        {
            //否则偶尔crash
            if indexPath.row >= colorModels.count {
                return UITableViewCell()
            }
            
            cell.model = colorModels[indexPath.row]
        }
        else
        {
            //否则偶尔crash
            if indexPath.row >= webModels.count {
                return UITableViewCell()
            }
            
            cell.model = webModels[indexPath.row]
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension LogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var logTitleString = ""
        var model: _OCLogModel

        if tableView == defaultTableView
        {
            defaultSearchBar.resignFirstResponder()
            logTitleString = "Log"
            model = defaultModels[indexPath.row]
            reachEndDefault = false
            
            if let index = defaultModels.firstIndex(where: { (model_) -> Bool in
                return model_.isSelected == true
            }) {
                defaultModels[index].isSelected = false
            }
        }
        else if tableView == colorTableView
        {
            colorSearchBar.resignFirstResponder()
            logTitleString = "Color"
            model = colorModels[indexPath.row]
            reachEndColor = false
            
            if let index = colorModels.firstIndex(where: { (model_) -> Bool in
                return model_.isSelected == true
            }) {
                colorModels[index].isSelected = false
            }
        }
        else
        {
            webSearchBar.resignFirstResponder()
            logTitleString = "Web"
            model = webModels[indexPath.row]
            reachEndWeb = false
            
            if let index = webModels.firstIndex(where: { (model_) -> Bool in
                return model_.isSelected == true
            }) {
                webModels[index].isSelected = false
            }
        }
        
        model.isSelected = true

        let vc = JsonViewController.instanceFromStoryBoard()
        vc.editType = .log
        vc.logTitleString = logTitleString
        vc.logModel = model
        navigationController?.pushViewController(vc, animated: true)
        
        vc.justCancelCallback = {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var model: _OCLogModel
        
        if tableView == defaultTableView {
            model = defaultModels[indexPath.row]
        } else if tableView == colorTableView {
            model = colorModels[indexPath.row]
        } else {
            model = webModels[indexPath.row]
        }
        
        
        if let height = model.str?.height(with: UIFont.boldSystemFont(ofSize: 12), constraintToWidth: UIScreen.main.bounds.size.width) {
            return (height + 34) > 5000 ? 5000 : (height + 34)
        }
        
        return 0
    }
    
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == defaultTableView
        {
            let model = defaultModels[indexPath.row]
            var title = "Tag"
            if model.isTag == true {title = "UnTag"}
            
            let left = UIContextualAction(style: .normal, title: title) { [weak self] (action, sourceView, completionHandler) in
                model.isTag = !model.isTag
                self?.dispatch_main_async_safe { [weak self] in
                    self?.defaultTableView.reloadData()
                }
                completionHandler(true)
            }
            
            defaultSearchBar.resignFirstResponder()
            left.backgroundColor = "#007aff".hexColor
            return UISwipeActionsConfiguration(actions: [left])
        }
        else if tableView == colorTableView
        {
            let model = colorModels[indexPath.row]
            var title = "Tag"
            if model.isTag == true {title = "UnTag"}
            
            let left = UIContextualAction(style: .normal, title: title) { [weak self] (action, sourceView, completionHandler) in
                model.isTag = !model.isTag
                self?.dispatch_main_async_safe { [weak self] in
                    self?.colorTableView.reloadData()
                }
                completionHandler(true)
            }
            
            colorSearchBar.resignFirstResponder()
            left.backgroundColor = "#007aff".hexColor
            return UISwipeActionsConfiguration(actions: [left])
        }
        else
        {
            let model = webModels[indexPath.row]
            var title = "Tag"
            if model.isTag == true {title = "UnTag"}
            
            let left = UIContextualAction(style: .normal, title: title) { [weak self] (action, sourceView, completionHandler) in
                model.isTag = !model.isTag
                self?.dispatch_main_async_safe { [weak self] in
                    self?.webTableView.reloadData()
                }
                completionHandler(true)
            }
            
            webSearchBar.resignFirstResponder()
            left.backgroundColor = "#007aff".hexColor
            return UISwipeActionsConfiguration(actions: [left])
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == defaultTableView
        {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
                guard let models = self?.defaultModels else {return}
                
                let model: _OCLogModel = models[indexPath.row]
                _OCLogStoreManager.shared().removeLog(model)
                
                self?.defaultModels.remove(at: indexPath.row)
                _ = self?.defaultCacheModels?.firstIndex(of: model).map { self?.defaultCacheModels?.remove(at: $0) }
                _ = self?.defaultSearchModels?.firstIndex(of: model).map { self?.defaultSearchModels?.remove(at: $0) }
                
                self?.dispatch_main_async_safe { [weak self] in
                    self?.defaultTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                completionHandler(true)
            }
            
            defaultSearchBar.resignFirstResponder()
            return UISwipeActionsConfiguration(actions: [delete])
        }
        else if tableView == colorTableView
        {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
                guard let models = self?.colorModels else {return}
                
                let model: _OCLogModel = models[indexPath.row]
                _OCLogStoreManager.shared().removeLog(model)
                
                self?.colorModels.remove(at: indexPath.row)
                _ = self?.colorCacheModels?.firstIndex(of: model).map { self?.colorCacheModels?.remove(at: $0) }
                _ = self?.colorSearchModels?.firstIndex(of: model).map { self?.colorSearchModels?.remove(at: $0) }
                
                self?.dispatch_main_async_safe { [weak self] in
                    self?.colorTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                completionHandler(true)
            }
            
            colorSearchBar.resignFirstResponder()
            return UISwipeActionsConfiguration(actions: [delete])
        }
        else
        {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
                guard let models = self?.webModels else {return}
                
                let model: _OCLogModel = models[indexPath.row]
                _OCLogStoreManager.shared().removeLog(model)
                
                self?.webModels.remove(at: indexPath.row)
                _ = self?.webCacheModels?.firstIndex(of: model).map { self?.webCacheModels?.remove(at: $0) }
                _ = self?.webSearchModels?.firstIndex(of: model).map { self?.webSearchModels?.remove(at: $0) }
                
                self?.dispatch_main_async_safe { [weak self] in
                    self?.webTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                completionHandler(true)
            }
            
            webSearchBar.resignFirstResponder()
            return UISwipeActionsConfiguration(actions: [delete])
        }
    }
    
    //MARK: - only for ios8/ios9/ios10, not ios11
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == defaultTableView
        {
            if (editingStyle == .delete) {
                
                let model: _OCLogModel = defaultModels[indexPath.row]
                _OCLogStoreManager.shared().removeLog(model)
                
                self.defaultModels.remove(at: indexPath.row)
                _ = self.defaultCacheModels?.firstIndex(of: model).map { self.defaultCacheModels?.remove(at: $0) }
                _ = self.defaultSearchModels?.firstIndex(of: model).map { self.defaultSearchModels?.remove(at: $0) }
                
                self.dispatch_main_async_safe { [weak self] in
                    self?.defaultTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        else if tableView == colorTableView
        {
            if (editingStyle == .delete) {
                
                let model: _OCLogModel = colorModels[indexPath.row]
                _OCLogStoreManager.shared().removeLog(model)
                
                self.colorModels.remove(at: indexPath.row)
                _ = self.colorCacheModels?.firstIndex(of: model).map { self.colorCacheModels?.remove(at: $0) }
                _ = self.colorSearchModels?.firstIndex(of: model).map { self.colorSearchModels?.remove(at: $0) }
                
                self.dispatch_main_async_safe { [weak self] in
                    self?.colorTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        else
        {
            if (editingStyle == .delete) {
                
                let model: _OCLogModel = webModels[indexPath.row]
                _OCLogStoreManager.shared().removeLog(model)
                
                self.webModels.remove(at: indexPath.row)
                _ = self.webCacheModels?.firstIndex(of: model).map { self.webCacheModels?.remove(at: $0) }
                _ = self.webSearchModels?.firstIndex(of: model).map { self.webSearchModels?.remove(at: $0) }
                
                self.dispatch_main_async_safe { [weak self] in
                    self?.webTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

//MARK: - UIScrollViewDelegate
extension LogViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == defaultTableView {
            defaultSearchBar.resignFirstResponder()
        } else if scrollView == colorTableView {
            colorSearchBar.resignFirstResponder()
        } else {
            webSearchBar.resignFirstResponder()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == defaultTableView {
            reachEndDefault = false
        } else if scrollView == colorTableView {
            reachEndColor = false
        } else {
            reachEndWeb = false
        }
    }
}

//MARK: - UISearchBarDelegate
extension LogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar == defaultSearchBar
        {
            CocoaDebugSettings.shared.logSearchWordDefault = searchText
            searchLogic(searchText)
            
            dispatch_main_async_safe { [weak self] in
                self?.defaultTableView.reloadData()
            }
        }
        else if searchBar == colorSearchBar
        {
            CocoaDebugSettings.shared.logSearchWordColor = searchText
            searchLogic(searchText)
            
            dispatch_main_async_safe { [weak self] in
                self?.colorTableView.reloadData()
            }
        }
        else
        {
            CocoaDebugSettings.shared.logSearchWordWeb = searchText
            searchLogic(searchText)
            
            dispatch_main_async_safe { [weak self] in
                self?.webTableView.reloadData()
            }
        }
    }
}
