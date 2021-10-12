//
//  PWViewController.swift
//  PWGena
//
//  Created by Artem Turanov on 6/5/20.
//  Copyright © 2020 Artem Turanov. All rights reserved.
//

import Cocoa

class PWViewController: NSViewController {

    @IBOutlet var passwordText: NSTextField!
    @IBOutlet var passwordLen: NSTextField!
    @IBOutlet var chkUpper: NSButton!
    @IBOutlet var chkLower: NSButton!
    @IBOutlet var chkSpecial: NSButton!
    @IBOutlet var chkNum: NSButton!
    @IBOutlet var chkClipboard: NSButton!

    
//    Replaced this call with First Responder
//    @IBAction func dismiss(_ sender: NSButton) {
//      //print("Button pressed")
//        self.view.window?.performClose(nil)
//    }
    
    @IBAction func textChanged(_ sender: Any) {
        let len = keyPresent(key: "Length") ? getKeyInt(key: "Length") : 16
        
        if (Int(passwordLen.stringValue) == nil)
        {
         passwordLen.stringValue = String (len)
        }
        
        if (Int(passwordLen.stringValue)! < 4)
        {
         passwordLen.stringValue = "4"
        }
        
        if (passwordLen.stringValue != String (len))
        {
            generatePasswordUI()
        }
        UserDefaults.standard.set(Int(passwordLen.stringValue), forKey: "Length")
    }
    
    @IBAction func upperChanged(_ sender: Any) {
        generatePasswordUI()
        UserDefaults.standard.set(stateToBool(state: chkUpper.state), forKey: "Uppercase")
    }
    
    @IBAction func lowerChanged(_ sender: Any) {
        generatePasswordUI()
        UserDefaults.standard.set(stateToBool(state: chkLower.state), forKey: "Lowercase")
    }
    
    @IBAction func specialChanged(_ sender: Any) {
        generatePasswordUI()
        UserDefaults.standard.set(stateToBool(state: chkSpecial.state), forKey: "Special")
    }
    
    @IBAction func numbersChanged(_ sender: Any) {
        generatePasswordUI()
        UserDefaults.standard.set(stateToBool(state: chkNum.state), forKey: "Numbers")
    }
    
    @IBAction func generateClick(_ sender: Any) {
        generatePasswordUI()
    }
    
    @IBAction func atuoClipboard(_ sender: Any) {
        UserDefaults.standard.set(stateToBool(state: chkClipboard.state), forKey: "AutoClipboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    override func viewDidAppear() {

        loadPreferences()
        generatePasswordUI()
    }
    
    func loadPreferences () {
        passwordLen.integerValue = keyPresent(key: "Length") ? getKeyInt(key: "Length") : 16
        
        chkUpper.state = keyPresent(key: "Uppercase") ?
            stateFromBool (state: getKeyBool(key: "Uppercase")) : NSControl.StateValue.on
        
        chkLower.state = keyPresent(key: "Lowercase") ?
            (getKeyBool(key: "Lowercase") ? NSControl.StateValue.on : NSControl.StateValue.off ) : NSControl.StateValue.on
        
        chkNum.state = keyPresent(key: "Numbers") ?
            (getKeyBool(key: "Numbers") ? NSControl.StateValue.on : NSControl.StateValue.off ) : NSControl.StateValue.on
        
        chkSpecial.state = keyPresent(key: "Special") ?
                   (getKeyBool(key: "Special") ? NSControl.StateValue.on : NSControl.StateValue.off ) : NSControl.StateValue.off
        
        chkClipboard.state = keyPresent(key: "AutoClipboard") ?
                   (getKeyBool(key: "AutoClipboard") ? NSControl.StateValue.on : NSControl.StateValue.off ) : NSControl.StateValue.off
    }
    
    func generatePasswordUI () {
        let password = generateRandomPassword(Length: Int(passwordLen.stringValue) ?? 16,
                                                 Upper: stateToBool ( state: chkUpper.state),
                                                 Lower: stateToBool ( state: chkLower.state),
                                                 Numbers: stateToBool ( state: chkNum.state),
                                                 Special: stateToBool ( state: chkSpecial.state))
           
           passwordText.stringValue = password
           
           if (stateToBool(state: chkClipboard.state))
           {
               let pasteboard = NSPasteboard.general
               pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
               pasteboard.setString(password,forType: NSPasteboard.PasteboardType.string)
               
               var clipboardItems: [String] = []
               for element in pasteboard.pasteboardItems! {
                   if let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                       clipboardItems.append(str)
                   }
               }
            }
           
           passwordText.becomeFirstResponder()
    }

}

extension PWViewController {
  // MARK: Storyboard instantiation
      static func freshController() -> PWViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("PWViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PWViewController else {
          fatalError("Why cant i find PWViewController? - Check Main.storyboard")
        }
        return viewcontroller
      }
}

func stateToBool(state: NSControl.StateValue) -> Bool
{
    if (state == NSControl.StateValue.on) {
        return true
    }
    return false
}

func stateFromBool(state: Bool) -> NSControl.StateValue
{
    if (state) {
        return NSControl.StateValue.on
    }
    return NSControl.StateValue.off
}

func keyPresent (key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

func getKeyInt (key: String) -> Int {
    return UserDefaults.standard.integer(forKey: key)
}

func getKeyBool (key: String) -> Bool {
    return UserDefaults.standard.bool(forKey: key)
}

func generateRandomPassword (Length: Int, Upper: Bool, Lower: Bool, Numbers: Bool, Special: Bool) -> String
{
    let pwLen = Length < 4 ? 4 : Length
    var result: String = ""
    var seed: [Character] = []
    let sNumbers: [Character] = ["0","1","2","3","4","5","6","7","8","9"]
    
    let sUpper:   [Character] = [ "A","B","C","D","E","F","G","H","I","J","K","L","M",
                                  "N","O","P","Q","R","S","T","U","V","W","X","Y","Z" ]
    
    let sLower:   [Character] = [ "a","b","c","d","e","f","g","h","i","j","k","l","m",
                                  "n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    let sSpecial: [Character] = [ "%","+","\\","/","!","#","$","^","?",":",".","(",")","{","}","[","]","~","-","_","." ]
    
    if (Numbers) { seed.append(contentsOf: sNumbers) }
    if (Upper)   { seed.append(contentsOf: sUpper) }
    if (Lower)   { seed.append(contentsOf: sLower) }
    if (Special) { seed.append(contentsOf: sSpecial)}
    
    let decimalCharacters =   CharacterSet.decimalDigits
    let lowercaseCharacters = CharacterSet.lowercaseLetters
    let uppercaseCharacters = CharacterSet.uppercaseLetters
    let specialCharacters =   CharacterSet.symbols
    
    while (
               ( Numbers && result.rangeOfCharacter(from: decimalCharacters) == nil ) ||
               ( Lower && result.rangeOfCharacter(from: lowercaseCharacters) == nil ) ||
               ( Upper && result.rangeOfCharacter(from: uppercaseCharacters) == nil ) ||
               ( Special && result.rangeOfCharacter(from: specialCharacters) == nil )
          )
    {
            result = ""
            for _ in 0...pwLen-1 {
                   result = result + String(seed[Int.random(in: 0 ..< seed.count)])
               }
    }
    
    return result
}
