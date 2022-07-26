//
//  MessageChartsController.swift
//  MessageMachine
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 15/07/22.
//


#if canImport(UIKit)
import UIKit
#endif
import Charts

class PieChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var chartView: PieChartView!
    @IBOutlet weak var btnInbox: UIButton!
    @IBOutlet weak var btnSent: UIButton!
    
    var messagesMachineManager = MessagesMachineManager()
    
    //Get data for the chart when touch button
    @IBAction func btnTouch(_ sender: UIButton) {
        sender.titleLabel?.text == K.btnInboxLabel ? messagesMachineManager.messagesRead(fromInbox:true, fromCharts: true) : messagesMachineManager.messagesRead(fromInbox:false, fromCharts: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesMachineManager.dataChartDelegate = self
        btnInbox.setTitle(K.btnInboxLabel, for: .normal)
        btnSent.setTitle(K.btnSentLabel, for: .normal)
        
        // Do any additional setup after loading the view.
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = UIFont.systemFont(ofSize: 16)
        
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.usePercentValuesEnabled = false
        
        chartView.entryLabelFont = .systemFont(ofSize: 18, weight: .light)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        messagesMachineManager.messagesRead(fromInbox:true, fromCharts: true)
        chartView.drawEntryLabelsEnabled = false
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "Number of Messages\nby category")
        
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 18)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        
        
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.holeColor = nil
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
//        chartView.legend = l
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        messagesMachineManager.stopAllTimers()
    }
    
}

extension PieChartViewController: DataChartDelegate{
    
    func didUpdateChart(_ messagesMachineManager: MessagesMachineManager, messages: [Message]) {
        
        var entries = [PieChartDataEntry]()
        let grouped = Dictionary(grouping: messages, by:{$0.category}).sorted(by:{ $0.0 < $1.0 })
        
        grouped.forEach {
            entries.append(PieChartDataEntry(value: Double($0.value.count), label: K.FStore.MessageConfiguration.categories[$0.key]))
        }
        
        let set = PieChartDataSet(entries: entries, label: K.chartConventions)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 18, weight: .light))
        data.setValueTextColor(.black)
        
        DispatchQueue.main.async {
            self.chartView.data = data
            self.chartView.highlightValues(nil)
            
        }
    }
    
}


