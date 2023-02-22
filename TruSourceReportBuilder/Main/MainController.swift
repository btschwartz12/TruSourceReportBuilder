//
//  ViewController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/9/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

//https://idmsa.apple.com/IDMSWebAuth/signin.html?path=%2Fenroll%2Fpurchase&appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757

//MARK: use core data to save the filters they used previously


import Cocoa

class MainController: NSViewController, ShowsFilter {
    
    //MARK: title box outlets
    @IBOutlet weak var aboutButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    //MARK: report type box outlets
    @IBOutlet weak var selectedTypeLabel: NSTextField!
    @IBOutlet weak var editReportTypeButton: NSButton!
    @IBOutlet weak var selectedFiltersBox: NSBox!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    //MARK: input box outlets
    @IBOutlet weak var showInputDataButtton: NSButton!
    @IBOutlet weak var requiredURLsHelpButton: NSButton!
    @IBOutlet weak var requiredURLsLabel: NSTextField!
    @IBOutlet weak var loadURLButton: NSButton!
    @IBOutlet weak var loadedURLsLabel: NSTextField!
    @IBOutlet weak var inputHelpButton: NSButton!
    @IBOutlet weak var inputBuffer: NSProgressIndicator!
    @IBOutlet weak var inputStatusLabel: NSTextField!
    
    //MARK: output box outlets
    @IBOutlet weak var showOutputDataButton: NSButton!
    @IBOutlet weak var createReportButton: NSButton!
    @IBOutlet weak var outputStatusLabel: NSTextField!
    @IBOutlet weak var uploadButton: NSButton!
    @IBOutlet weak var outputBuffer: NSProgressIndicator!
    @IBOutlet weak var outputHelpButton: NSButton!
    
    //MARK: bottom box outlets
    @IBOutlet weak var signatureLabel: NSTextField!
    @IBOutlet weak var feedbackButton: NSButton!
    
    //MARK: show info vars
    var infoTitle: String = "none"
    var infoBody: String = "no body"
    
    //MARK: report selection vars
    var selectedType : ReportType = .none
    var filters : [Filter] = []
    var presentingFilter : (Filter, IndexPath)?
    
    
    
    var num = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            
        Timer.scheduledTimer(timeInterval: 1,
               target: self,
               selector: #selector(MainController.update),
               userInfo: nil,
               repeats: true)
            
        initialize()
        // Do any additional setup after loading the view.
    }
    
   

    // @objc selector expected for Timer
    @objc func update() {
        num += 1
        feedbackButton.title = "\(num)"
        // do what should happen when timer triggers an event
    }

    override var representedObject: Any? {
        didSet {
        print("appeared")
        }
    }
}
//MARK: key functions
extension MainController {
    
    func initialize() {
        setUpScreen()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        switch identifier {
        case Segue.reportSelection.rawValue:
            print("")//print("checking conditions to go to report selection")
//        case Segue.reportDescription.rawValue:
//            print("checking conditions to go to report description")
        case Segue.filterMAIN.rawValue:
            print("checking conditions to go to filter")
        case Segue.showInfo.rawValue:
            print("checking conditions to go to show info")
//        case Segue.input.rawValue:
//            print("checking conditions to go to input")
//        case Segue.upload.rawValue:
//            print("checking conditions to go to upload")
//        case Segue.linkHelp.rawValue:
//            print("checking conditions to go to link help")
        default:
            print("error (12312)")
        }
        return true
    }
    //only used to pass data
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        let target = segue.destinationController
        switch segue.identifier! {
        case Segue.reportSelection.rawValue:
            let dest = target as! ReportSelectionController
            dest.selectedType = self.selectedType
            dest.filters = filters
//        case Segue.reportDescription.rawValue:
//            print("going to report description")
        case Segue.filterMAIN.rawValue:
            let dest = target as! FilterController
            dest.presentingFilter = presentingFilter
        case Segue.showInfo.rawValue:
            var s: String
            if let str = readLine() {
                
                s = str.replacingOccurrences(of: "\n", with: " ")
                print(s)
            }
            let showInfoController = target as! ShowInfoController
            showInfoController.titleText = infoTitle
            showInfoController.bodyText = infoBody
            print("going to show info")
//        case Segue.input.rawValue:
//            print("going to input")
//        case Segue.upload.rawValue:
//            print("going to upload")
//        case Segue.linkHelp.rawValue:
//            print("going to link help")
        default:
            print("error (1023)")
        }
    }
}
//MARK: title box events
private extension MainController {
    
    func setUpTitleBox() {
        aboutButton.attributedTitle = NSAttributedString(string: "About", attributes:[.underlineStyle: NSUnderlineStyle.single.rawValue])
        resetButton.attributedTitle = NSAttributedString(string: "Reset", attributes:[.underlineStyle: NSUnderlineStyle.single.rawValue])
//        print("setting up title box")
    }
    @IBAction func aboutTouched(_ sender: Any)  {
        print("about button touched")
        infoTitle = "this is good app"
        infoBody = "932-457984320374598237450923847520394857324905872405987234598072345"
        performSegue(withIdentifier: Segue.showInfo.rawValue, sender: nil)
    }
    @IBAction func resetTouched(_ sender: Any)  {
        print("reset button touched")
    }
}
//MARK: report box events
extension MainController {
    
    func setUpReportBox() {
        selectedTypeLabel.stringValue = selectedType.rawValue
//        print("setting up report box")
    }
    @IBAction func editReportTouched(_ sender: Any)  {
        print("edit report button touched")
    }
    @IBAction func clearFiltersTouched(_ sender: Any) {
        guard filters.count != 0  else {
            return
        }
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to cler all filters?"
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self.view.window!) { response in
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.filters = []
                self.collectionView.reloadData()
            }
        }
    }
    func setReportInfo(withReportType reportType: ReportType, andFilters filters: [Filter]) {
        selectedTypeLabel.stringValue = reportType.rawValue
        selectedType = reportType
        self.filters = filters
        collectionView.reloadData()
    }
    func goToFilter(withFilter filter: Filter?, at index: IndexPath?) {
        if let filter = filter, let index = index {
            presentingFilter = (filter, index)
            performSegue(withIdentifier: Segue.filterMAIN.rawValue, sender: nil)
            DispatchQueue.main.async {
                self.presentingFilter = nil
            }
        }
    }
}
extension MainController : NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let filter = filters[indexPath.item]
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FilterItem"), for: indexPath) as! FilterItem
        item.showingName = filter.name != nil ? true : false
        item.viewController = self
        item.filter = filter
        item.label.stringValue = filter.description
        item.setUpLabel()
        return item
    }
}
//MARK: input box events
private extension MainController {
    
    func setUpInputBox() {
//        print("setting up input box")
        inputStatusLabel.textColor = .red
        inputStatusLabel.stringValue = "piper"
        requiredURLsLabel.stringValue = "Required URLs : piper"
        loadedURLsLabel.stringValue = "Required URLs : piper"
        inputBuffer.isDisplayedWhenStopped = false
       // inputBuffer.startAnimation(nil)
    }
    @IBAction func showInputDataTouched(_ sender: Any)  {
        print("showInputData button touched")
    }
    @IBAction func loadURLsTouched(_ sender: Any)  {
        print("loadURLs button touched")
    }
    @IBAction func requiredURLsHelpTouched(_ sender: Any)  {
        print("requiredURLsHelp button touched")
    }
    @IBAction func inputHelpTouched(_ sender: Any)  {
        print("inputHelp button touched")
    }
}
//MARK: output box events
private extension MainController {
    
    func setUpOutputBox() {
//        print("setting up output box")
        outputStatusLabel.textColor = .red
        outputStatusLabel.stringValue = "status : piper"
        outputBuffer.isDisplayedWhenStopped = false
      //  outputBuffer.startAnimation(nil)
    }
    @IBAction func showOutputDataTouched(_ sender: Any)  {
        performSegue(withIdentifier: Segue.showInfo.rawValue, sender: nil)
        print("showOutputData button touched")
    }
    @IBAction func createReportTouched(_ sender: Any)  {
        print("create report button touched")
    }
    @IBAction func uploadTouched(_ sender: Any)  {
        print("upload button touched")
    }
    @IBAction func outputHelpTouched(_ sender: Any)  {
        print("output help button touched")
    }
}
//MARK: bottom box events
private extension MainController {
    
    func setUpBottomBox() {
        signatureLabel.stringValue = "v. 1.piper Ben Schwartz"
//        print("setting up bottom box")
    }
    @IBAction func feedbackTouched(_ sender: Any)  {
        //var dictArray : [[String:Any]] = []
//        if let url = URL(string: "http://gsx2json.com/api?id=1t8_XmxHay4FfgyiI9zFaJN96yJe_PttuuMNDiXsdkbE&columns=false") {
//            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//                if let data = data {
//                    if let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        if let myArray = myDict["rows"] as? [[String:Any]] {
//                            dictArray = myArray
//                        }
//                    }
//                }
//                if let error = error {
//                    print("ERROR : \(String(describing: error))")
//                }
//            }.resume()
//        }
        print("feedback touched")
    }
}
//MARK: graphics
private extension MainController {
    
    func setUpScreen() {
        //maybe here have every method reset back to normal so i can just call this for reset button
        setUpTitleBox()
        setUpReportBox()
        setUpInputBox()
        setUpOutputBox()
        setUpBottomBox()
    }
    func makeFilters(num: Int) -> [Filter] {
        var filters : [Filter] = []
        for _ in 0...num {
            
        }
        return filters
    }
}
/*
    //child view controller
    var inputController: InputViewController?
    //outlets

    
    //data
    var items : [[String:Any]] = [[:]]
    
    //status vars
    var dataLoaded: Bool { items.count > 1 }
    var selectedType : ReportType = ReportType.none
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        print("appeared")
        }
    }
    
    func initialize() {
        resetScreen()
        
    }

    


}
//MARK: events
extension MainController {
    //if a type is not selected, output segue should not be run
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        switch identifier {
        case Segue.input.rawValue:
            return true
        case Segue.help.rawValue:
            return true
        case Segue.output.rawValue:
            if selectedType == .none {
                showNoTypeAlert()
                return false
            }
            else if !dataLoaded {
                showAlert(withTitle: "Error", andDescripton: "cannot create report: data has not been properly loaded")
                return false
            }
            return true
        default:
            print("error")
            return false
        }
    }
    //when a segue is excecuted
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.input.rawValue:
            inputController = segue.destinationController as? InputViewController
        case Segue.help.rawValue:
            _ = "intentionally contentless"
        case Segue.output.rawValue:
            let outputController = segue.destinationController as? OutputViewController
            outputController?.selectedType = selectedType
            outputController?.items = items
        default:
            print("error")
        }
    }
    //called when the user has finished reading data
    func sheetDidDismiss() {
        items = inputController!.items
        selectedType = inputController!.selectedType
        updateScreen()
    }
    
    @IBAction func resetTouched(_ sender: Any) {
        resetScreen()
    }
}
//MARK: graphics
extension MainController {
    
    func updateScreen() {
        loadURLbutton.title = "Load Different URL"
        messageLabel.textColor = NSColor(red: 70 / 255.0, green: 150 / 255.0, blue: 61 / 255.0, alpha: 1)
        messageLabel.stringValue = "load successful (items = \(items.count))"
        helpButton.isHidden = true
        selectedTypeLabel.isHidden = false
        selectedTypeLabel.stringValue = "selected report : \(selectedType)"
        outputButton.isHidden = false
    }
    func resetScreen() {
        messageLabel.textColor = .systemIndigo
        messageLabel.stringValue = "Please have a published Google Sheets URL ready"
        loadURLbutton.title = "Load URL"
        helpButton.isHidden = false
        selectedTypeLabel.isHidden = true
        outputButton.isHidden = true
        items = []
    }
    
    func showNoTypeAlert() {
        let alert = NSAlert()
        alert.messageText = "No type found"
        alert.informativeText = "Please indicate which report type you want to create"
        alert.beginSheetModal(for: self.view.window!) { response in }
    }
    func showAlert(withTitle title: String, andDescripton description: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = description
        alert.beginSheetModal(for: self.view.window!) { response in print("response = \(response)")}
    }
}

 */
