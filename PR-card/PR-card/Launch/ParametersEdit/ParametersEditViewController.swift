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
    public var subjects = Array<String>(repeating: "", count:5) // レーダーチャートの項目
    var set: RadarChartDataSet!
    //ラベル
    let subject = ["国語", "英語", "数学", "理科", "社会"]
    //点数
    let array: [Double] = [80.0, 88.0, 80.0, 70.0, 30.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(subjects)
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
        
        // UISliderの最小値・最大値設定
        parametersSlider.minimumValue = 0
        parametersSlider.maximumValue = 100
        
//        let entries = [
//            RadarChartDataEntry(value: 70),
//            RadarChartDataEntry(value: 80),
//            RadarChartDataEntry(value: 50),
//            RadarChartDataEntry(value: 20),
//            RadarChartDataEntry(value: 100),
//        ]
        //let entries: [Float] = [50.0, 50.0, 50.0, 50.0, 50.0]
        
//        set = RadarChartDataSet(entries: entries, label: "")
//        set.drawFilledEnabled = true // 塗りつぶし
//        set.fillColor = .blue
//        set.valueFormatter = RadarChartValueFormatter()
//        //setChart(dataPoints: subjects, values: entries)
//        radarChartView.legend.enabled = false // 凡例非表示
//        radarChartView.data = RadarChartData(dataSet: set)
//        radarChartView.rotationEnabled = false // 回転禁止
        //レーダーチャートのy軸の最小値と最大値
        radarChartView.yAxis.axisMinimum = 0
        radarChartView.yAxis.axisMaximum = 100
        radarChartView.delegate = self
        //setChart(dataPoints: subjects, values: array)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(subjects)
        setChart(dataPoints: subjects, values: array)
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        radarChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            dataEntries.append(RadarChartDataEntry(value: values[i], data: dataPoints[i]))
        }
        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: "hoge")
        let chartData = RadarChartData(dataSet: chartDataSet)
        
        radarChartView.yAxis.labelCount = 10
        radarChartView.yAxis.axisMinimum = 0.0
        radarChartView.yAxis.axisMaximum = 100.0
        radarChartView.rotationEnabled = false
        chartDataSet.drawFilledEnabled = true
        
        radarChartView.legend.enabled = false
        
        let customFormater = CustomFormatter1()
        customFormater.labels =  subjects
        radarChartView.xAxis.valueFormatter = customFormater
        
        // データセット
        radarChartView.data = chartData
        // アニメーション
        radarChartView.animate(yAxisDuration: 2.0)
    }
    
    @IBAction func toParametersEditPreview(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ParametersEditPreview", bundle: nil)
        let parametersEditPreviewVC = storyboard.instantiateViewController(identifier: "ParametersEditPreview") as ParametersEditPreviewViewController
        navigationController?.pushViewController(parametersEditPreviewVC, animated: true)
    }
}

// 各ポイントの最後に値を表示しない
class RadarChartValueFormatter: ParametersEditViewController, IValueFormatter {
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
        //print(subjects)
        print(dataSetIndex)
        return subject[Int(value) % subject.count]
    }
}

extension ParametersEditViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.y)
        entry.y = Double(slidarNumerical)
        radarChartView.animate(yAxisDuration: 2.0)
    }
}

final class CustomFormatter1: IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let count = self.labels.count
        guard let axis = axis, count > 0 else {
            return ""
        }
        let factor = axis.axisMaximum / Double(count)
        let index = Int((value / factor).rounded())
        if index >= 0 && index < count {
            return self.labels[index]
        }
        return ""
    }
}
