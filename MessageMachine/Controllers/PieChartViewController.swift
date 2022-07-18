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


class PieChartViewController: DemoBaseViewController {
    
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
        //self.title = K.tabChartTitle
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
//        chartView.legend = l

        // entry label styling
        chartView.entryLabelColor = .white
        chartView.usePercentValuesEnabled = false

        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        messagesMachineManager.messagesRead(fromInbox:true, fromCharts: true)
        //messagesMachineManager.chartsRead(inbox: true)
        //title = K.tabChartTitle
        chartView.drawEntryLabelsEnabled = false
        //chartView.setNeedsDisplay()

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
            
            data.setValueFont(.systemFont(ofSize: 11, weight: .light))
            data.setValueTextColor(.black)
           
        DispatchQueue.main.async {
            self.chartView.data = data
            self.chartView.highlightValues(nil)
            
        }
    }
    
}


