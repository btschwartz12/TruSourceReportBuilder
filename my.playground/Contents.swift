import Cocoa








let arr = ["Pipw", "dogg", "923810"]
print("peeper is \(arr.joined(separator: ", "))")

var dictArray : [[String:Any]] = []
if let url = URL(string: "http://gsx2json.com/api?id=1t8_XmxHay4FfgyiI9zFaJN96yJe_PttuuMNDiXsdkbE&columns=false") {
    URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
        
        guard let data = data, error == nil else {
            print(error?.localizedDescription)
            return
        }

        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let results = jsonResult["rows"] as? [[String:Any]] {
                    var dict: [String:Int] = [:]
                    results
                    for lead in results {
                        if let src = lead[""] as? String {
                            if let count = dict[src] {
                                dict[src] = count + 1
                            }
                            else {
                                dict[src] = 1
                            }
                        }
                        else {
                            if let count = dict["nil"] {
                                dict["nil"] = count + 1
                            }
                            else {
                                dict["nil"] = 1
                            }
                        }
                        
                    }
                    print(dict)
                }
            }
        } catch let parseError {
            print("JSON Error \(parseError.localizedDescription)")
        }
    }.resume()
}







//try with struct instead of int next

struct Lead {
    var age: Int
    var cost: Double
}
let lead1 = Lead(age: 20, cost: 50.9)
let lead2 = Lead(age: 40, cost: 70.0)
let lead3 = Lead(age: 30, cost: 49.6)
let lead4 = Lead(age: 35, cost: 80.9)

var leads = [lead1, lead2, lead3, lead4]

let ageMin = 34

let costMin = 75.0

let ageClosure = { (lead: Lead) -> Bool in//try wo ()
    return lead.age > ageMin
}
let costClosure = { (lead: Lead) -> Bool in
    return lead.cost > costMin
}

let closuress = [ageClosure, costClosure]

var filteredLeads: [Lead] = leads

for closure in closuress {
    filteredLeads = filteredLeads.filter(closure)
}
filteredLeads

























let dataStr = "WwogIHsKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiMTQuMzI2MTk3MTgzMDk4NTkxIiwKICAgICJ0b3RhbFJldmVudWUiIDogIjEwMTcuMTYiLAogICAgImxlYWRDb3VudCIgOiA3MSwKICAgICJzdGF0ZSIgOiAiTUkiCiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICIyNTk1LjAyIiwKICAgICJsZWFkQ291bnQiIDogMTc5LAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxNC40OTczMTg0MzU3NTQxOSIsCiAgICAic3RhdGUiIDogIkZMIgogIH0sCiAgewogICAgInJldmVudWVQZXJMZWFkIiA6ICI4LjcyIiwKICAgICJzdGF0ZSIgOiAiU0QiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMTM5LjUyIiwKICAgICJsZWFkQ291bnQiIDogMTYKICB9LAogIHsKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiNy43NDM0MjY1NzM0MjY1NjciLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMjIxNC42MTk5OTk5OTk5OTgiLAogICAgImxlYWRDb3VudCIgOiAyODYsCiAgICAic3RhdGUiIDogIk1EIgogIH0sCiAgewogICAgImxlYWRDb3VudCIgOiAzMDYsCiAgICAic3RhdGUiIDogIkNBIiwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiOS45MzI5NzM4NTYyMDkxNDUiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMzAzOS40ODk5OTk5OTk5OTg0IgogIH0sCiAgewogICAgInN0YXRlIiA6ICJQQSIsCiAgICAidG90YWxSZXZlbnVlIiA6ICIxNDQwLjE3OTk5OTk5OTk5OTgiLAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxMi40MTUzNDQ4Mjc1ODYyMDUiLAogICAgImxlYWRDb3VudCIgOiAxMTYKICB9LAogIHsKICAgICJ0b3RhbFJldmVudWUiIDogIjE0NjMuNjUiLAogICAgImxlYWRDb3VudCIgOiAxMDcsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEzLjY3ODk3MTk2MjYxNjgyMiIsCiAgICAic3RhdGUiIDogIklOIgogIH0sCiAgewogICAgInN0YXRlIiA6ICJNQSIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjkuNjgyMTczOTEzMDQzNDc2IiwKICAgICJ0b3RhbFJldmVudWUiIDogIjg5MC43NTk5OTk5OTk5OTk5IiwKICAgICJsZWFkQ291bnQiIDogOTIKICB9LAogIHsKICAgICJsZWFkQ291bnQiIDogNTEsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEzLjkyNDExNzY0NzA1ODgyMyIsCiAgICAic3RhdGUiIDogIkdBIiwKICAgICJ0b3RhbFJldmVudWUiIDogIjcxMC4xMyIKICB9LAogIHsKICAgICJ0b3RhbFJldmVudWUiIDogIjMxNy4wMyIsCiAgICAic3RhdGUiIDogIlVUIiwKICAgICJsZWFkQ291bnQiIDogMjMsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEzLjc4MzkxMzA0MzQ3ODI2IgogIH0sCiAgewogICAgInRvdGFsUmV2ZW51ZSIgOiAiNDkyLjkwMDAwMDAwMDAwMDE1IiwKICAgICJzdGF0ZSIgOiAiQ1QiLAogICAgInJldmVudWVQZXJMZWFkIiA6ICI3LjE0MzQ3ODI2MDg2OTU2OCIsCiAgICAibGVhZENvdW50IiA6IDY5CiAgfSwKICB7CiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjcuMjE5NTkxODM2NzM0Njk1IiwKICAgICJ0b3RhbFJldmVudWUiIDogIjM1My43NjAwMDAwMDAwMDAwNSIsCiAgICAibGVhZENvdW50IiA6IDQ5LAogICAgInN0YXRlIiA6ICJJRCIKICB9LAogIHsKICAgICJ0b3RhbFJldmVudWUiIDogIjgxNC42NzAwMDAwMDAwMDAyIiwKICAgICJsZWFkQ291bnQiIDogNTQsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjE1LjA4NjQ4MTQ4MTQ4MTQ4NSIsCiAgICAic3RhdGUiIDogIldJIgogIH0sCiAgewogICAgInRvdGFsUmV2ZW51ZSIgOiAiMTUxMS4xMzAwMDAwMDAwMDA4IiwKICAgICJzdGF0ZSIgOiAiVkEiLAogICAgImxlYWRDb3VudCIgOiAxMDEsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjE0Ljk2MTY4MzE2ODMxNjg0IgogIH0sCiAgewogICAgInJldmVudWVQZXJMZWFkIiA6ICIxNC41MDYxMjA2ODk2NTUxNzgiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMTY4Mi43MTAwMDAwMDAwMDA3IiwKICAgICJsZWFkQ291bnQiIDogMTE2LAogICAgInN0YXRlIiA6ICJUWCIKICB9LAogIHsKICAgICJzdGF0ZSIgOiAiTkoiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMjUzOS42MjAwMDAwMDAwMDQiLAogICAgImxlYWRDb3VudCIgOiAyOTYsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjguNTc5Nzk3Mjk3Mjk3MzExIgogIH0sCiAgewogICAgImxlYWRDb3VudCIgOiAxMiwKICAgICJ0b3RhbFJldmVudWUiIDogIjUzLjExIiwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiNC40MjU4MzMzMzMzMzMzMzMiLAogICAgInN0YXRlIiA6ICJEQyIKICB9LAogIHsKICAgICJsZWFkQ291bnQiIDogMTE5LAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxNC44OTg0MDMzNjEzNDQ1NDQiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMTc3Mi45MTAwMDAwMDAwMDA4IiwKICAgICJzdGF0ZSIgOiAiTkMiCiAgfSwKICB7CiAgICAic3RhdGUiIDogIklMIiwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiMTIuOTA3MTcxNzE3MTcxNzEyIiwKICAgICJsZWFkQ291bnQiIDogOTksCiAgICAidG90YWxSZXZlbnVlIiA6ICIxMjc3LjgwOTk5OTk5OTk5OTUiCiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICI4MC4xMiIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjYuMTYzMDc2OTIzMDc2OTI0IiwKICAgICJsZWFkQ291bnQiIDogMTMsCiAgICAic3RhdGUiIDogIk5NIgogIH0sCiAgewogICAgInJldmVudWVQZXJMZWFkIiA6ICIxNS42MDY1IiwKICAgICJsZWFkQ291bnQiIDogNDAsCiAgICAic3RhdGUiIDogIkxBIiwKICAgICJ0b3RhbFJldmVudWUiIDogIjYyNC4yNiIKICB9LAogIHsKICAgICJzdGF0ZSIgOiAiTU8iLAogICAgImxlYWRDb3VudCIgOiA0OCwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiMTMuOTQzMzMzMzMzMzMzMzMiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiNjY5LjI3OTk5OTk5OTk5OTkiCiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICIyOTcuMSIsCiAgICAic3RhdGUiIDogIk1TIiwKICAgICJsZWFkQ291bnQiIDogMjIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEzLjUwNDU0NTQ1NDU0NTQ1NiIKICB9LAogIHsKICAgICJzdGF0ZSIgOiAiTVQiLAogICAgImxlYWRDb3VudCIgOiAyOSwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiMTEuMTk2NTUxNzI0MTM3OTMzIiwKICAgICJ0b3RhbFJldmVudWUiIDogIjMyNC43MDAwMDAwMDAwMDAwNSIKICB9LAogIHsKICAgICJ0b3RhbFJldmVudWUiIDogIjc3NC4zIiwKICAgICJzdGF0ZSIgOiAiS1MiLAogICAgImxlYWRDb3VudCIgOiA1MSwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiMTUuMTgyMzUyOTQxMTc2NDciCiAgfSwKICB7CiAgICAic3RhdGUiIDogIk9LIiwKICAgICJ0b3RhbFJldmVudWUiIDogIjM1NC45MSIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjE0Ljc4NzkxNjY2NjY2NjY2OCIsCiAgICAibGVhZENvdW50IiA6IDI0CiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICIxMTY4LjIxMDAwMDAwMDAwMDMiLAogICAgInN0YXRlIiA6ICJDTyIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjE0LjQyMjM0NTY3OTAxMjM0OSIsCiAgICAibGVhZENvdW50IiA6IDgxCiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICIyNDYuOTMiLAogICAgInN0YXRlIiA6ICJJQSIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEyLjk5NjMxNTc4OTQ3MzY4NCIsCiAgICAibGVhZENvdW50IiA6IDE5CiAgfSwKICB7CiAgICAic3RhdGUiIDogIk5FIiwKICAgICJ0b3RhbFJldmVudWUiIDogIjIwMC41NSIsCiAgICAibGVhZENvdW50IiA6IDEzLAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxNS40MjY5MjMwNzY5MjMwNzgiCiAgfSwKICB7CiAgICAibGVhZENvdW50IiA6IDcyLAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxMi4yMjQ0NDQ0NDQ0NDQ0NDgiLAogICAgInN0YXRlIiA6ICJOViIsCiAgICAidG90YWxSZXZlbnVlIiA6ICI4ODAuMTYwMDAwMDAwMDAwMiIKICB9LAogIHsKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiNi40MDIyMTA1MjYzMTU3ODgiLAogICAgImxlYWRDb3VudCIgOiA5NSwKICAgICJzdGF0ZSIgOiAiTU4iLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiNjA4LjIwOTk5OTk5OTk5OTgiCiAgfSwKICB7CiAgICAibGVhZENvdW50IiA6IDgsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjguODk3NDk5OTk5OTk5OTk5IiwKICAgICJ0b3RhbFJldmVudWUiIDogIjcxLjE3OTk5OTk5OTk5OTk5IiwKICAgICJzdGF0ZSIgOiAiTkQiCiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICI4NjYuOTIwMDAwMDAwMDAwMSIsCiAgICAic3RhdGUiIDogIkFMIiwKICAgICJsZWFkQ291bnQiIDogNzMsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjExLjg3NTYxNjQzODM1NjE2NSIKICB9LAogIHsKICAgICJsZWFkQ291bnQiIDogOCwKICAgICJ0b3RhbFJldmVudWUiIDogIjE2LjYiLAogICAgInN0YXRlIiA6ICJBSyIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjIuMDc1IgogIH0sCiAgewogICAgInRvdGFsUmV2ZW51ZSIgOiAiMjYzLjYiLAogICAgInJldmVudWVQZXJMZWFkIiA6ICI4Ljc4NjY2NjY2NjY2NjY2NyIsCiAgICAibGVhZENvdW50IiA6IDMwLAogICAgInN0YXRlIiA6ICJNRSIKICB9LAogIHsKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiOC4zNDczMzMzMzMzMzMzMzEiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMzc1LjYyOTk5OTk5OTk5OTk0IiwKICAgICJsZWFkQ291bnQiIDogNDUsCiAgICAic3RhdGUiIDogIk5IIgogIH0sCiAgewogICAgInJldmVudWVQZXJMZWFkIiA6ICIxMi4xMjUzMjI1ODA2NDUxNjEiLAogICAgImxlYWRDb3VudCIgOiA2MiwKICAgICJ0b3RhbFJldmVudWUiIDogIjc1MS43NyIsCiAgICAic3RhdGUiIDogIktZIgogIH0sCiAgewogICAgInRvdGFsUmV2ZW51ZSIgOiAiNDI2LjAzMDAwMDAwMDAwMDEiLAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxNC42OTA2ODk2NTUxNzI0MTciLAogICAgInN0YXRlIiA6ICJTQyIsCiAgICAibGVhZENvdW50IiA6IDI5CiAgfSwKICB7CiAgICAibGVhZENvdW50IiA6IDcwLAogICAgInJldmVudWVQZXJMZWFkIiA6ICI4LjQzMzcxNDI4NTcxNDI4NiIsCiAgICAidG90YWxSZXZlbnVlIiA6ICI1OTAuMzYiLAogICAgInN0YXRlIiA6ICJPUiIKICB9LAogIHsKICAgICJ0b3RhbFJldmVudWUiIDogIjQxLjc5MDAwMDAwMDAwMDAwNiIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjQuNjQzMzMzMzMzMzMzMzM0IiwKICAgICJzdGF0ZSIgOiAiUkkiLAogICAgImxlYWRDb3VudCIgOiA5CiAgfSwKICB7CiAgICAibGVhZENvdW50IiA6IDQzLAogICAgInJldmVudWVQZXJMZWFkIiA6ICIxMS40NjY5NzY3NDQxODYwNDciLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiNDkzLjA4MDAwMDAwMDAwMDA0IiwKICAgICJzdGF0ZSIgOiAiQVoiCiAgfSwKICB7CiAgICAidG90YWxSZXZlbnVlIiA6ICIxNTA4LjQwOTk5OTk5OTk5OTkiLAogICAgImxlYWRDb3VudCIgOiAxMTMsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEzLjM0ODc2MTA2MTk0NjkiLAogICAgInN0YXRlIiA6ICJPSCIKICB9LAogIHsKICAgICJzdGF0ZSIgOiAiV0EiLAogICAgInJldmVudWVQZXJMZWFkIiA6ICI1Ljg2MjI3MjcyNzI3MjcyNTUiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMjU3LjkzOTk5OTk5OTk5OTk0IiwKICAgICJsZWFkQ291bnQiIDogNDQKICB9LAogIHsKICAgICJ0b3RhbFJldmVudWUiIDogIjIzNi4yMyIsCiAgICAic3RhdGUiIDogIldWIiwKICAgICJsZWFkQ291bnQiIDogMTYsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjE0Ljc2NDM3NSIKICB9LAogIHsKICAgICJsZWFkQ291bnQiIDogNTQsCiAgICAidG90YWxSZXZlbnVlIiA6ICI3NzIuODkiLAogICAgInN0YXRlIiA6ICJUTiIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjE0LjMxMjc3Nzc3Nzc3Nzc3NyIKICB9LAogIHsKICAgICJsZWFkQ291bnQiIDogMTQsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjEyLjA5Mjg1NzE0Mjg1NzE0NSIsCiAgICAidG90YWxSZXZlbnVlIiA6ICIxNjkuMzAwMDAwMDAwMDAwMDQiLAogICAgInN0YXRlIiA6ICJXWSIKICB9LAogIHsKICAgICJzdGF0ZSIgOiAiREUiLAogICAgImxlYWRDb3VudCIgOiAxNywKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiNy44MzA1ODgyMzUyOTQxMTgiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMTMzLjEyIgogIH0sCiAgewogICAgInN0YXRlIiA6ICJOWSIsCiAgICAicmV2ZW51ZVBlckxlYWQiIDogIjYuOTY3MDQ2NzgzNjI1NzM5IiwKICAgICJsZWFkQ291bnQiIDogMzQyLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiMjM4Mi43MzAwMDAwMDAwMDI3IgogIH0sCiAgewogICAgImxlYWRDb3VudCIgOiAxMywKICAgICJzdGF0ZSIgOiAiSEkiLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiNDkuNDEiLAogICAgInJldmVudWVQZXJMZWFkIiA6ICIzLjgwMDc2OTIzMDc2OTIzMDciCiAgfSwKICB7CiAgICAibGVhZENvdW50IiA6IDEsCiAgICAic3RhdGUiIDogIlZUIiwKICAgICJyZXZlbnVlUGVyTGVhZCIgOiAiNy42NyIsCiAgICAidG90YWxSZXZlbnVlIiA6ICI3LjY3IgogIH0sCiAgewogICAgInJldmVudWVQZXJMZWFkIiA6ICIxMi43NjI2MTkwNDc2MTkwNDciLAogICAgInRvdGFsUmV2ZW51ZSIgOiAiNTM2LjAzIiwKICAgICJsZWFkQ291bnQiIDogNDIsCiAgICAic3RhdGUiIDogIkFSIgogIH0KXQ=="

let data = NSData(base64Encoded: dataStr, options: NSData.Base64DecodingOptions())! as Data

let str = String(data: data, encoding: String.Encoding.utf8)!

let clipboard = NSPasteboard.general

//var ss = clipboard.string(forType: .string)
//print(ss!)
//


clipboard.declareTypes([.string], owner: nil)

if clipboard.setString(str, forType: .string) {
    print("success")
}
else {
    print("unsuccessful")
}



//copy base64 string to use
//get data from base64 and try copying data to clipboard to paste in sheets
//if not just copy base64 to clipboard and figure out how to make hyperlink to a converter, then have it use that json for stuff
