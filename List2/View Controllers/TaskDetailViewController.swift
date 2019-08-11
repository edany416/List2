//
//  TaskDetailViewController.swift
//  List2
//
//  Created by edan yachdav on 7/21/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var tagsTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var shadowView: ShadowView!
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var smartTagsButton: UIButton!
    
    @IBOutlet weak var keyboardBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardBar: UIView!
    @IBOutlet weak var keyboardBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardBarCollectionView: UICollectionView!
    private var tags: [Tag]?
    private var tagsToPresent: [Tag]! {
        didSet {
            keyboardBarCollectionView.reloadData()
        }
    }
    private var testFavs = [Tag]()
    private var testSmartTags = [Tag]()
    
    private var keyboardIsShowing = false
    var isInEditState: Bool = false
    private var isFavoritesSelected = false
    private var isSmartTagsSelected = false
    private var tapTracker: TapTracker!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tapGesture)
        
        keyboardBarCollectionView.dataSource = self
        keyboardBarCollectionView.delegate = self
        keyboardBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(contentDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
        tapTracker = TapTracker(tags: tags!)
        testFavs.append(tags![0])
        testSmartTags.append(tags![1])
        tagsToPresent = tags
        keyboardBarCollectionView.reloadData()
        
        smartTagsButton.titleLabel?.textAlignment = .center
        favoritesButton.titleLabel?.textAlignment = .center
        
        taskNameTextField.becomeFirstResponder()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyboardBar.isHidden = false
            keyboardBarBottomConstraint.constant = keyboardHeight
            keyboardIsShowing = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardBar.isHidden = true
        keyboardBarBottomConstraint.constant = 0
        keyboardIsShowing = false
        tagsToPresent = Array(tags!)
        isFavoritesSelected = false
        isSmartTagsSelected = false
        set(favoritesButtonColor: .white, favsText: .black, stBG: .white, stText: .black)
        self.view.layoutIfNeeded()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isInEditState {
            saveButton.isEnabled = false
        }
    }
    
    @objc func contentDidSave(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let taskName = taskNameTextField!.text
        let tags = parseTags()
        PersistanceService.instance.saveTask(taskName: taskName!, dueDate: nil, notes: nil, tags: tags)
    }
    
    private func parseTags() -> [String]? {
        if !tagsTextField.text!.isEmpty {
            let tagsString = tagsTextField.text!
            let tagsArray = (tagsString.components(separatedBy: " ")).filter{$0 != ""}
            return tagsArray
        }
        return nil
    }
    
    @IBAction func taskNameEditingDidChange(_ sender: UITextField) {
        if sender.text != nil {
            saveButton.isEnabled = !sender.text!.isEmpty
        }
    }
    @IBAction func tagsTextFieldEditingDidChange(_ sender: UITextField) {
        //THIS ONLY ACCOUNTS FOR TYPING TAGS, NOT DELETEING FROM TEXTFIELD
        if !sender.text!.isEmpty || sender.text!.last != " " {
            if let typedTags = parseTags() {
                let lastTag = typedTags.last!
                if (tags!.filter {$0.name! == lastTag}).count != 0 {
                    let isTapped = tapTracker.tapStatus(forTagNamed: lastTag)
                    if !isTapped {
                        tapTracker.setTappedStatus(forTagNamed: lastTag)
                        keyboardBarCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func updateKeyboardBar() {
        if isFavoritesSelected {
            tagsToPresent = Array(testFavs)
            set(favoritesButtonColor: #colorLiteral(red: 0.1568627451, green: 0.7333333333, blue: 0.5803921569, alpha: 1), favsText: .white, stBG: .white, stText: .black)
        } else if isSmartTagsSelected {
            tagsToPresent = Array(testSmartTags)
            set(favoritesButtonColor: .white, favsText: .black, stBG: #colorLiteral(red: 0.1568627451, green: 0.7333333333, blue: 0.5803921569, alpha: 1), stText: .white)
        } else {
            tagsToPresent = Array(tags!)
            set(favoritesButtonColor: .white, favsText: .black, stBG: .white, stText: .black)
        }
        
        if keyboardIsShowing {
            keyboardBarHeightConstraint.constant = 0.0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.keyboardBarHeightConstraint.constant = 50.0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func onTapFavorites(_ sender: UIButton) {
        if keyboardIsShowing {
            isFavoritesSelected = !isFavoritesSelected
            if isFavoritesSelected {
                isSmartTagsSelected = false
            }
            updateKeyboardBar()
        }
    }
    
    @IBAction func onTapSmartTags(_ sender: UIButton) {
        if keyboardIsShowing {
            isSmartTagsSelected = !isSmartTagsSelected
            if isSmartTagsSelected {
                isFavoritesSelected = false
            }
            updateKeyboardBar()
        }
    }
    
    private func set(favoritesButtonColor favsBG: UIColor, favsText: UIColor, stBG: UIColor, stText: UIColor) {
        favoritesButton.backgroundColor = favsBG
        favoritesButton.setTitleColor(favsText, for: .normal)
        smartTagsButton.backgroundColor = stBG
        smartTagsButton.setTitleColor(stText, for: .normal)
    }
}

//MARK - Keyboardbar collection view methods
extension TaskDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsToPresent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = keyboardBarCollectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardBarCell", for: indexPath) as! KeyboardBarCell
        let tag = tagsToPresent[indexPath.row]
        cell.title.text = tag.name
        setTapStateFor(cell: cell, fromTag: tag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = keyboardBarCollectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardBarCell", for: indexPath) as! KeyboardBarCell
        let tag = tagsToPresent[indexPath.row]
        tapTracker.setTappedStatus(for: tag)
        setTapStateFor(cell: cell, fromTag: tag)
        keyboardBarCollectionView.reloadItems(at: [indexPath])
    }
    
    private func setTapStateFor(cell: KeyboardBarCell, fromTag tag: Tag) {
        let tapStatus = tapTracker.tapStatus(for: tag)
        cell.setSelected(tapStatus)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tagsToPresent![indexPath.row]
        let tagName = tag.name! as NSString
        let sizeOfTagName = tagName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)])
        let size = CGSize(width: sizeOfTagName.width + 10, height: keyboardBarCollectionView.frame.height)
        return size
    }
}

