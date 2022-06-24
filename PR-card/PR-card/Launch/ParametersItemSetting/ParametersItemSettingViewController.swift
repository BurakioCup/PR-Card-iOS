//
//  ParametersItemSettingViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/15.
//

import UIKit

class ParametersItemSettingViewController: UIViewController {
    
    @IBOutlet weak var firstItemTextField: UITextField!
    @IBOutlet weak var secondItemTextField: UITextField!
    @IBOutlet weak var thirdItemTextField: UITextField!
    @IBOutlet weak var fourthItemTextField: UITextField!
    @IBOutlet weak var fifthItemTextField: UITextField!
    @IBOutlet weak var toParametersEditButton: UIButton!
    var items = Array<String>(repeating: "", count:5) // レーダーチャートの項目
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstItemTextField.delegate = self
        secondItemTextField.delegate = self
        thirdItemTextField.delegate = self
        fourthItemTextField.delegate = self
        fifthItemTextField.delegate = self
        //toParametersEditButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 項目入力完了後にレーダーチャートの設定画面へ遷移
    @IBAction func toParametersEdit(_ sender: Any) {
        print(items)
        let storyboard = UIStoryboard(name: "ParametersEdit", bundle: nil)
        let parametersEditVC = storyboard.instantiateViewController(identifier: "ParametersEdit") as ParametersEditViewController
        parametersEditVC.subjects = items
        navigationController?.pushViewController(parametersEditVC, animated: true)
    }
    
    func textFieldIsvalid() {
        guard let firstItem = firstItemTextField.text else { return }
        guard let secondItem = secondItemTextField.text else { return }
        guard let thirdItem = thirdItemTextField.text else { return }
        guard let fourthItem = fourthItemTextField.text else { return }
        guard let fifthItem = fifthItemTextField.text else { return }
    }
    
    // キーボード出現時にViewを上にあげる
    @objc func keyboardWillShow(notification: NSNotification) {
        // 編集中のtextFieldを取得
        guard let firstTextField = firstItemTextField else { return }
        guard let secondTextField = secondItemTextField else { return }
        guard let thirdTextField = thirdItemTextField else { return }
        guard let fourthTextField = fourthItemTextField else { return }
        guard let fifthTextField = fifthItemTextField else { return }
        
        // キーボード、画面全体、textFieldのsizeを取得
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.size.height else { return }
        let mainBoundsSize = UIScreen.main.bounds.size
        let firstTextFieldHeight = firstTextField.frame.height
        let secondTextFieldHeight = secondTextField.frame.height
        let thirdTextFieldHeight = thirdTextField.frame.height
        let fourthTextFieldHeight = fourthTextField.frame.height
        let fifthTextFieldHeight = fifthTextField.frame.height
        
        // ① テキストフィールドの底辺より10.0下のy座標を取得
        let firstFieldPositionY = firstTextField.frame.origin.y + firstTextFieldHeight + 10.0
        let secondFieldPositionY = secondTextField.frame.origin.y + secondTextFieldHeight + 10.0
        let thirdFieldPositionY = thirdTextField.frame.origin.y + thirdTextFieldHeight + 10.0
        let fourthFieldPositionY = fourthTextField.frame.origin.y + fourthTextFieldHeight + 10.0
        let fifthFieldPositionY = fifthTextField.frame.origin.y + fifthTextFieldHeight + 10.0
        
        
        // ② キーボードの底辺のy座標を取得
        let keyboardPositionY = mainBoundsSize.height - keyboardHeight
        
        // ③キーボードをずらす
        if secondTextField.isFirstResponder {
            print("secondTextField.isFirstResponder")
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - secondFieldPositionY)
            }
        } else if thirdTextField.isFirstResponder {
            print("thirdTextField.isFirstResponder")
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - thirdFieldPositionY)
            }
        } else if fourthTextField.isFirstResponder {
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - fourthFieldPositionY)
            }
        } else if fifthTextField.isFirstResponder {
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - fifthFieldPositionY)
            }
        }
    }
    
    // キーボードが閉じられた時にViewの高さを元に戻す
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
}

extension ParametersItemSettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstItemTextField.resignFirstResponder()
        secondItemTextField.resignFirstResponder()
        thirdItemTextField.resignFirstResponder()
        fourthItemTextField.resignFirstResponder()
        fifthItemTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            items[0] = firstItemTextField.text ?? "音程"
        case 1:
            items[1] = secondItemTextField.text ?? "安定性"
        case 2:
            items[2] = thirdItemTextField.text ?? "表現力"
        case 3:
            items[3] = fourthItemTextField.text ?? "リズム"
        case 4:
            items[4] = fifthItemTextField.text ?? "演技力"
        default:
            return
        }
    }
}
