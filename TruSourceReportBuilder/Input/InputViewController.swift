//
//  InputViewController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/10/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

//MARK: tasks
/*
 I need to find a way to upload json to google sheets, and this means I need to create an API URL
 
 I need to find a way to actually be able to distribute the app
 
 Need to make sure inputted data is consistent with report type before leaving page
 
 */

import Cocoa

//MARK: links
/*
    https://docs.google.com/spreadsheets/d/18v632hMyxOtgWEe9IgI-xhe_oVzNQXpKU41NyxjzKfs/edit#gid=0
    https://hackernoon.com/3-best-ways-to-import-json-to-google-sheets-ultimate-guide-3k8s24ya
 
 https://developers.google.com/identity/sign-in/ios/start?ver=swift

 
 */

//MARK: MAKE IT SO IF YOU PRESS ENTER IT WILL LOAD
class InputViewController: NSViewController {
    
    //debugging vars
    let debugging : Bool = true
    let bigSheet : Bool = true
    let formatJSON : Bool = true
    
    //parent view controller
    var mainController : MainController = MainController()

    //outlets
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var loadButton: NSButton!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var buffer: NSProgressIndicator!
    @IBOutlet var scrollTextView: NSTextView!
    @IBOutlet weak var itemCountLabel: NSTextField!
    @IBOutlet weak var reportPopUpButton: NSPopUpButton!
    @IBOutlet weak var bufferBar: NSProgressIndicator!
    
    //status vars
    var dataLoaded: Bool { items.count > 1 }
    var selectedType : ReportType = .none
    
    //json vars
    var items : [[String:Any]] = [[:]]
    var sheetsUrl : String = ""
    var goodSheetsUrl : Bool {
        return sheetsUrl.contains("docs.google.com/spreadsheets/d/") && sheetsUrl.count > 80 && !sheetsUrl.contains("pubhtml") && sheetsUrl.contains("gid=")
    }
    //loading
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do view setup here.
    }
    
    func initialize() {
        statusLabel.stringValue = "waiting..."
        mainController = self.presentingViewController as! MainController
        urlField.isHidden = true
        bufferBar.isDisplayedWhenStopped = false
        bufferBar.startAnimation(nil)
    }
    
    @IBAction func reportHelpTouched(_ sender: Any)
    {
        if selectedType == .none {
            showNoTypeAlert()
        }
        else {
          //  performSegue(withIdentifier: Segue.description.rawValue, sender: nil)
        }
    }
    
}
//MARK: segues
extension InputViewController {
    
//    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
//        switch identifier {
//        case Segue.description.rawValue:
//            //set the chosen type, then pass it along for the description controller
//            setSelectedType()
//            if selectedType == .none {
//                urlField.isHidden = true
//                return false
//            }
//        default:
//            print("error: incorrect segue")
//        }
//        return true
//    }

//    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
//        switch segue.identifier! {
//        case Segue.description.rawValue:
//            let descriptionController = segue.destinationController as? ReportDescriptionController
//            descriptionController!.selectedType = selectedType
//            urlField.isHidden = false
//        default:
//            print("error: incorrect segue")
//        }
//    }
}
//MARK: events
extension InputViewController {
    
    @IBAction func loadTouched(_ sender: Any) {
        
        //if data is already loaded
        if dataLoaded { dismiss() }
        //if user has not selected report type
        if selectedType == .none { showNoTypeAlert(); return }
        //get url from user input
        sheetsUrl = debugging ? bigSheet ? "https://docs.google.com/spreadsheets/d/16JRhBw_DkLjeq_IS0DFAo7lpjj8BQHyDdeRh_Le4fFc/edit#gid=1669905045": "https://docs.google.com/spreadsheets/d/18v632hMyxOtgWEe9IgI-xhe_oVzNQXpKU41NyxjzKfs/edit#gid=0" : urlField.stringValue
        //checks to see if it is good url
        guard goodSheetsUrl else {
            statusLabel.stringValue = "bad url, try another"
            return
        }
        bufferBar.stopAnimation(nil)
        //now with good url, we can generate json
        generateJSON(with: sheetsUrl)
    }
    func dismiss() {
        dismiss(self)
       // mainController.sheetDidDismiss()
    }
}
//MARK: json
extension InputViewController {

    func getJsonURL(sheetsURL : String) -> String? {
        let adjustedURL = sheetsURL[sheetsURL.firstIndex(of: "d")!...]
        let array = adjustedURL.components(separatedBy: "/")
        if array.count < 4 { return nil }
        var count = 3
        var sheetID = ""
        while sheetID.count < 3 {
            sheetID = array[count]
            count += 1
        }
        let jsonURL = "http://gsx2json.com/api?id=\(sheetID)&columns=false"
        return jsonURL
    }
    
    func generateJSON(with url: String) {
        startBuffer()
        //empty current data
        items = []
        

        //uses jsonurl to get data from api and store into items
        if let jsonURL = getJsonURL(sheetsURL: url) {
            if let url = URL(string: jsonURL) {
                URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                    if let data = data {
                        self.loadData(with: data) { dictArray in
                            DispatchQueue.main.async {
                                let success = dictArray.count > 1
                                if success {
                                    self.items = dictArray
                                    self.updateScreen(success: true)
                                }
                                else {
                                    self.updateScreen(success: false)
                                }
                            }
                        }
                    }
                    if let error = error {
                        print("ERROR : \(String(describing: error))")
                    }
                }.resume()
            }
        }
    }
    
    func loadData(with data: Data, completion: ([[String:Any]]) -> () ) {

        var dictArray : [[String : Any]] = [[:]]
        do {
            if let myDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let myArray = myDict["rows"] as? [[String:Any]] {
                    dictArray = myArray
                }
            }
        }
        catch {
            print("there was an error \(error)")
        }
        completion(dictArray)
    }
    
    func getDictArrayText(from dict: [[String:Any]]) -> String {
        var text = ""
        var count = 0
        for row in dict {
            count += 1
            text += "\(count) : "
            text += row.description
            text += "\n\n"
        }
        return text
    }
}
//MARK: graphics
extension InputViewController {
    
    func showNoTypeAlert() {
        let alert = NSAlert()
        alert.messageText = "No type found"
        alert.informativeText = "Please indicate which report type you want to create"
        alert.beginSheetModal(for: self.view.window!) { response in }
        
    }
    
    
    func updateScreen(success wasParsed: Bool) {
        if wasParsed {
            statusLabel.stringValue = "successfully parsed sheet"
            scrollTextView.string = formatJSON ? getDictArrayText(from: items) : items.description
            loadButton.title = "Continue"
            itemCountLabel.stringValue = "ITEMS : \(items.count)"
            stopBuffer()
        }
        else {
            statusLabel.stringValue = "failed to parse sheet"
            scrollTextView.string = ""
            itemCountLabel.stringValue = ""
            stopBuffer()
        }
        
    }
    
    func startBuffer() {
        statusLabel.stringValue = "reading..."
        buffer.startAnimation(nil)
    }
    func stopBuffer() {
        buffer.stopAnimation(nil)
    }
}
//MARK: misc
private extension InputViewController {
    
    func setSelectedType() {
        if let identifier = reportPopUpButton.item(at: reportPopUpButton.indexOfSelectedItem)?.identifier {
            switch identifier.rawValue {
            case "none":
                selectedType = .none
            case "v0.7":
                selectedType = .v0_7
            default:
                print("error (9921)")
            }
        }
        else {
            selectedType = .none
        }
    }
}
//      let semaphore = DispatchSemaphore(value: 0) // https://medium.com/@roykronenfeld/semaphores-in-swift-e296ea80f860
//      semaphore.signal()
//      semaphore.wait()
