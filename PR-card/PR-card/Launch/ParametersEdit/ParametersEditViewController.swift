//
//  ParametersEditViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/09.
//

import Charts
import UIKit

class ParametersEditViewController: UIViewController {

    @IBOutlet weak var radarChartView: RadarChartView!
    @IBOutlet weak var parametersSlider: UISlider!
    var slidarNumerical: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
        
        // UISliderの最小値・最大値設定
        parametersSlider.minimumValue = 0
        parametersSlider.maximumValue = 100
        
        let entries = [
            RadarChartDataEntry(value: 70),
            RadarChartDataEntry(value: 80),
            RadarChartDataEntry(value: 50),
            RadarChartDataEntry(value: 20),
            RadarChartDataEntry(value: 100),
        ]
        
        let set = RadarChartDataSet(entries: entries, label: "")
        set.drawFilledEnabled = true // 塗りつぶし
        set.fillColor = .blue
        set.valueFormatter = RadarChartValueFormatter()
        radarChartView.legend.enabled = false // 凡例非表示
        radarChartView.data = RadarChartData(dataSet: set)
        radarChartView.rotationEnabled = false // 回転禁止
        //レーダーチャートのy軸の最小値と最大値
        radarChartView.yAxis.axisMinimum = 0
        radarChartView.yAxis.axisMaximum = 100
        radarChartView.delegate = self
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //左横画面に変更
        if(UIDevice.current.orientation.rawValue == 4) {
            UIDevice.current.setValue(4, forKey: "orientation")
            return .landscapeLeft
        } else {
            //左横画面以外の処理
            //右横画面に変更させる。
            UIDevice.current.setValue(3, forKey: "orientation")
            return .landscapeRight
        }
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        print(Int(sender.value))
        slidarNumerical = Int(sender.value)
    }
    
    // 各ポイントの最後に値を表示しない
    public class RadarChartValueFormatter: NSObject, IValueFormatter{
        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
            return ""
        }
    }
}

extension ParametersEditViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.y)
        entry.y = Double(slidarNumerical)
    }
}
