//
//  ViewController.swift
//  gym_ble
//
//  Created by 山下克宏 on 2022/06/06.
//

import UIKit
import CoreBluetooth

class RecieveViewController: UIViewController {

    private let gym_survice_UUID = "28b0883b-7ec3-4b46-8f64-8559ae036e4e"
    private let gym_characteristic_UUID = "2049779d-88a9-403a-9c59-c7df79e1dd7c"
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var serviceUUID : CBUUID!
    var cbCharacteristic: CBCharacteristic?
    var charcteristicUUIDs: [CBUUID]!
    var voltageLabel: UILabel!
    var distanceLabel: UILabel!
    var waveBtn1: UIButton!
    var waveBtn2: UIButton!
    var waveBtn3: UIButton!
    var waveBtn4: UIButton!
    var stopBtn: UIButton!
    var signal: String = "0"
    
    /*
     signal "0" :peripheralと接続していない状態、切断する信号
     signal "1" :peripheralと接続したことを通信
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupWaveBtn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendWave(signal: "0")
        signal = "0"
    }

    private func setup() {
        print("setup...")

        centralManager = CBCentralManager()
        centralManager.delegate = self as CBCentralManagerDelegate

        serviceUUID = CBUUID(string: gym_survice_UUID)
        charcteristicUUIDs = [CBUUID(string: gym_characteristic_UUID)]
   }
    
    private func setupWaveBtn(){
        waveBtn1 = UIButton(frame: CGRect(x: self.view.frame.width * 0.1, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.38 ,height: self.view.frame.height * 0.2))
        waveBtn1.backgroundColor = UIColor(red: 0.047, green: 0.61, blue: 0.96, alpha: 1.0)
        waveBtn1.setTitle(NSLocalizedString("440test", comment: ""), for: UIControl.State.normal)
        waveBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        waveBtn1.addTarget(self, action: #selector(RecieveViewController.onClickWave1Button(sender:)), for: .touchUpInside)
        self.view.addSubview(waveBtn1)
        
        waveBtn2 = UIButton(frame: CGRect(x: self.view.frame.width * 0.52, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.38 ,height: self.view.frame.height * 0.2))
        waveBtn2.backgroundColor = UIColor(red: 0.047, green: 0.61, blue: 0.96, alpha: 1.0)
        waveBtn2.setTitle(NSLocalizedString("超音波断続", comment: ""), for: UIControl.State.normal)
        waveBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        waveBtn2.addTarget(self, action: #selector(RecieveViewController.onClickWave2Button(sender:)), for: .touchUpInside)
        self.view.addSubview(waveBtn2)
        
        waveBtn3 = UIButton(frame: CGRect(x: self.view.frame.width * 0.1, y: self.view.frame.height * 0.41, width: self.view.frame.width * 0.38 ,height: self.view.frame.height * 0.2))
        waveBtn3.backgroundColor = UIColor(red: 0.047, green: 0.61, blue: 0.96, alpha: 1.0)
        waveBtn3.setTitle(NSLocalizedString("断続test", comment: ""), for: UIControl.State.normal)
        waveBtn3.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        waveBtn3.addTarget(self, action: #selector(RecieveViewController.onClickWave3Button(sender:)), for: .touchUpInside)
        self.view.addSubview(waveBtn3)
        
        waveBtn4 = UIButton(frame: CGRect(x: self.view.frame.width * 0.52, y: self.view.frame.height * 0.41, width: self.view.frame.width * 0.38 ,height: self.view.frame.height * 0.2))
        waveBtn4.backgroundColor = UIColor(red: 0.047, green: 0.61, blue: 0.96, alpha: 1.0)
        waveBtn4.setTitle(NSLocalizedString("stop", comment: ""), for: UIControl.State.normal)
        waveBtn4.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        waveBtn4.addTarget(self, action: #selector(RecieveViewController.onClickWave4Button(sender:)), for: .touchUpInside)
        self.view.addSubview(waveBtn4)
        
        stopBtn = UIButton(frame: CGRect(x: self.view.frame.width * 0.35, y: self.view.frame.height * 0.8, width: self.view.frame.width * 0.3 ,height: self.view.frame.height * 0.1))
        stopBtn.backgroundColor = UIColor(red: 0.047, green: 0.61, blue: 0.96, alpha: 1.0)
        stopBtn.layer.masksToBounds = true
        stopBtn.layer.cornerRadius = 5.0
        stopBtn.setTitle(NSLocalizedString("待機", comment: ""), for: UIControl.State.normal)
        stopBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        stopBtn.addTarget(self, action: #selector(RecieveViewController.onClickStopButton(sender:)), for: .touchUpInside)
        self.view.addSubview(stopBtn)
    }
    
    @objc func onClickWave1Button(sender: UIButton) {
        sendWave(signal: "2")
        signal = "2"
        }
    
    @objc func onClickWave2Button(sender: UIButton) {
        sendWave(signal: "3")
        signal = "3"
        }
    
    @objc func onClickWave3Button(sender: UIButton) {
        sendWave(signal: "5")
        signal = "5"
        }
    
    @objc func onClickWave4Button(sender: UIButton) {
        sendWave(signal: "4")
        signal = "4"
        }
    
    @objc func onClickStopButton(sender: UIButton) {
        sendWave(signal: "1")
        signal = "1"
        }
    
    private func sendWave(signal: String){
        guard let peripheral = self.peripheral else {
                return
            }
        guard let cbCharacteristic = self.cbCharacteristic else {
                return
            }
        let writeData = signal.data(using: .utf8)!
        peripheral.writeValue(writeData, for: cbCharacteristic, type: .withResponse)
    }

}

//MARK : - CBCentralManagerDelegate
extension RecieveViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")

        switch central.state {
            
        //電源ONを待って、スキャンする
        case CBManagerState.poweredOn:
            let services: [CBUUID] = [serviceUUID]
            centralManager?.scanForPeripherals(withServices: services,
                                               options: nil)
        default:
            print("centralが見つかりません")
            break
        }
    }
    
    /// ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        self.peripheral = peripheral
        centralManager?.stopScan()
        
        //接続開始
        central.connect(peripheral, options: nil)
        print("  - centralManager didDiscover")
    }
    
    /// 接続されると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
        
        print("  - centralManager didConnect")
        
    }
    
    /// 切断されると呼ばれる？
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        sendWave(signal: "0")
        signal = "0"
        print(#function)
        if error != nil {
            print(error.debugDescription)
            setup() // ペアリングのリトライ
            return
        }
    }
}

//MARK : - CBPeripheralDelegate
extension RecieveViewController: CBPeripheralDelegate {
    
    /// サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        //キャリアクタリスティク探索開始
        if let service = peripheral.services?.first {
            print("Searching characteristic...")
            peripheral.discoverCharacteristics(charcteristicUUIDs,
                                               for: service)
        }
    }
    
    /// キャリアクタリスティク発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }

        print("service.characteristics.count: \(service.characteristics!.count)")
        for characteristics in service.characteristics! {
            if(characteristics.uuid == CBUUID(string: gym_characteristic_UUID)) {
                self.cbCharacteristic = characteristics
                print("cbCharacteristic did discovered!")
            }
        }
        
        if(self.cbCharacteristic != nil) {
            startReciving()
            sendWave(signal: "1")
            signal = "1"
        }
        print("  - Characteristic didDiscovered")

    }
    
    private func startReciving() {
        guard let cbCharacteristic = cbCharacteristic else {
            return
        }
        peripheral.setNotifyValue(true, for: cbCharacteristic)
        print("Start monitoring the message from Arduino.\n\n")
    }


    /// データ送信時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        if error != nil {
            print(error.debugDescription)
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print(#function)
    }
    
    /// データ更新時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)

        if error != nil {
            print(error.debugDescription)
            return
        }
    }
}
