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
