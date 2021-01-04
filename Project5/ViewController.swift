//
//  ViewController.swift
//  Project5
//
//  Created by Carmen Morado on 11/9/20.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(restartGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }

        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        
        if let savedTitle = defaults.object(forKey: "title") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                title = try jsonDecoder.decode(String.self, from: savedTitle)
            }
            
            catch {
                print("Unable to save the data")
            }
        }

        if let savedWords = defaults.object(forKey: "usedWords") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                usedWords = try jsonDecoder.decode([String].self, from: savedWords)
            }
            
            catch {
                print("Unable to save the data")
            }
        }
        
        if title == "" || title == nil {
            title = allWords.randomElement()
            saveCurrentWord()
            tableView.reloadData()
        }

    }
    
    func startGame() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        UserDefaults.standard.synchronize()
        title = allWords.randomElement()
        saveCurrentWord()
        usedWords.removeAll(keepingCapacity: true)
        saveAllEntries()
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        let ac = UIAlertController(title: "Restart the game?", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.startGame()
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        saveCurrentWord()
        saveAllEntries()
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    saveAllEntries()

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                }
                
                else {
                        errorTitle = "Word not recognised"
                        errorMessage = "You can't just make them up, you know!"
                        showErrorMessage(title: errorTitle, message: errorMessage)
                }
            }
            
            else {
                    errorTitle = "Word used already"
                    errorMessage = "Be more original!"
                    showErrorMessage(title: errorTitle, message: errorMessage)
            }
        }
        
        else {
                guard let title = title?.lowercased() else { return }
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title)"
                showErrorMessage(title: errorTitle, message: errorMessage)
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if word.count > 2 && word != title?.lowercased() && misspelledRange.location == NSNotFound {
            return true
        }
        else {
            return false
        }
    }
    
    func showErrorMessage(title: String, message: String) -> Void {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
    }
    
    func saveAllEntries() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(usedWords) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "usedWords")
        } else {
            print("Failed to save the entries.")
        }
    }
        
    func saveCurrentWord() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(title) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "title")
        } else {
            print("Failed to save the current word.")
        }
    }

}

