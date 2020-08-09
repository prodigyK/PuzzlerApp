//
//  MainViewController.swift
//  Puzze15App
//
//  Created by Konstantin Petkov on 06.08.2020.
//  Copyright © 2020 Konstantin Petkov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var amountOfPuzzles = 15
    var amountOfPuzzlesInRow = 0
    var coordArray = [[CGRect]]()
    var puzzleArray = [[Int]]()
    var timer: Timer?
    var time = 0
    var amountOfTaps = 0
    var pickerView: UIView = UIView()
    var picker = UIPickerView()
    var selectedGameSize = 1
    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var parentResultsView: UIView!
    @IBOutlet weak var parentPuzzleBox: UIView!
    @IBOutlet weak var puzzleBox: UIView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var statButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTapsLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var bestTapsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        amountOfPuzzlesInRow = Int(sqrt(Double(amountOfPuzzles + 1)))
        
        initArrays()
        setupPuzzleView()
        
        resultsView.layer.cornerRadius = 7
        parentResultsView.layer.cornerRadius = 7
        
    }
    
    @IBAction func newGamePressed() {

        cleanCurrentResultHeader()
        cleanTimer()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        let rect = CGRect(x: 0, y: view.frame.height/2-60, width: view.frame.width, height: 100)
        let startLabel = UILabel(frame: rect)
        startLabel.font = UIFont(name: "Helvetica-Bold", size: 120)
        startLabel.text = "Start"
        startLabel.textAlignment = .center
        startLabel.textColor = .white
        view.addSubview(startLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            UIView.transition(with: startLabel,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                startLabel.alpha = 0
            }, completion: { _ in
                startLabel.removeFromSuperview()
            } )
           
        }
        
       
        
    }
    
    @objc func updateTimer() {
        time += 1
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        currentTimeLabel.text = String(format:"%02i:%02i", minutes, seconds)
        
    }
    
    func cleanTimer() {
        timer?.invalidate()
        timer = nil
        time = 0
        amountOfTaps = 0
    }
    
    func cleanCurrentResultHeader() {
        currentTimeLabel.text = "00:00"
        currentTapsLabel.text = "0"
    }

    
    @IBAction func shufflePressed() {
        
        cleanTimer()
        
        var tempArray = [Int]()
        for i in 1...amountOfPuzzles {
            tempArray.append(i)
        }
        tempArray.shuffle()
        

        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       options: [],
                       animations: { [weak self] in
                        
                        
                        var count = 0
                        for i in 0..<self!.amountOfPuzzlesInRow {
                            for j in 0..<self!.amountOfPuzzlesInRow {
                                if count == self!.amountOfPuzzles {
                                    self!.puzzleArray[i][j] = 0
                                    break
                                }
                                let button = self!.view.viewWithTag(tempArray[count])
                                self!.puzzleArray[i][j] = tempArray[count]
                                button?.frame = self!.coordArray[i][j]
                                count += 1
                                
                                
                            }
                        }
                        
                        print(tempArray)
                        print(self!.puzzleArray)
                        
      })

    }
    
    @IBAction func statPressed() {
        
    }
    
    @IBAction func changeGamePressed() {
        
        pickerView = UIView(frame: CGRect(x: 0, y: view.frame.height - 210, width: view.frame.width, height: 260))
        view.addSubview(pickerView)
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 210))
        picker.delegate = self
        picker.dataSource = self
//        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .orange
        picker.selectRow(selectedGameSize, inComponent: 0, animated: true)
        pickerView.addSubview(picker)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        toolBar.sizeToFit()
        toolBar.backgroundColor = .brown
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hidePickerDone))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(hidePickerCancel))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.barStyle = .black
        pickerView.addSubview(toolBar)

        
    }
    
    @objc func hidePickerDone() {
        selectNewPuzzleSize(selectedGameSize)
        pickerView.removeFromSuperview()
    }

    @objc func hidePickerCancel() {
        pickerView.removeFromSuperview()
    }

    
    func initArrays() {
        coordArray = Array(repeating: Array(repeating: CGRect(), count: amountOfPuzzlesInRow), count: amountOfPuzzlesInRow)
        puzzleArray = Array(repeating: Array(repeating: 0, count: amountOfPuzzlesInRow), count: amountOfPuzzlesInRow)
    }
    
    func cleanPuzzleView() {
        
    }
    
    func setupPuzzleView() {
        parentPuzzleBox.layer.cornerRadius = 7
        puzzleBox.layer.cornerRadius = 7
        
        let interval = 2
        let puzzleBoxWidth = puzzleBox.frame.size.width
        let puzzleWidth = Int((Int(puzzleBoxWidth) - (amountOfPuzzlesInRow * interval + interval)) / amountOfPuzzlesInRow)
        
        var offsetX = interval+1
        var offsetY = interval+1
        var count = 1
        for i in 0..<amountOfPuzzlesInRow {
            for j in 0..<amountOfPuzzlesInRow {
                                
                let frame = CGRect(x: offsetX, y: offsetY, width: puzzleWidth, height: puzzleWidth)
                
                print("count: \(count)")
                if count == amountOfPuzzles+1 {
                    coordArray[i][j] = frame
                    puzzleArray[i][j] = 0
                    break
                }
                
                coordArray[i][j] = frame
                puzzleArray[i][j] = count
                let button = UIButton(frame: frame)
                button.setTitle(String(count), for: .normal)
                button.backgroundColor = .brown
                button.layer.cornerRadius = 7
                button.tag = count
                button.titleLabel?.font = UIFont(name: "Helvetica", size: 35)
                button.addTarget(self, action: #selector(puzzleHandler(_:)), for: .touchUpInside)
                puzzleBox.addSubview(button)
                
                
                offsetX += puzzleWidth + interval
                count += 1
            }
            offsetX = interval+1
            offsetY += puzzleWidth + interval
        }
        print(coordArray)
        print(puzzleArray)
    }
    
    @objc func puzzleHandler(_ sender: UIButton) {
        guard var position = getPuzzlePosition(for: sender.tag) else { return }
        guard var zeroPosition = getZeroPosition() else { return }

        if checkIfZeroIsNear(position, zeroPosition) {
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [],
                           animations: { [weak self] in
                            
                            let zeroRect = self?.coordArray[zeroPosition.0][zeroPosition.1]
                            sender.frame = zeroRect!
                            self?.puzzleArray[zeroPosition.0][zeroPosition.1] = sender.tag
                            self?.puzzleArray[position.0][position.1] = 0
                            
                            self!.amountOfTaps += 1
                            self!.currentTapsLabel.text = String(self!.amountOfTaps)
                            
                            
            })
            if checkIfFinish() {
                cleanTimer()
                showCongratulations()
            }
            return
        }
        if checkIfZeroInLine(position, zeroPosition) {
            
            var puzzles = [Int]()
            if position.x == zeroPosition.x {
                if position.y > zeroPosition.y {
                    for i in zeroPosition.y+1...position.y {
                        puzzles.append(puzzleArray[position.x][i])
                    }
                } else {
                    for i in (position.y...zeroPosition.y-1).reversed() {
                        puzzles.append(puzzleArray[position.x][i])
                    }
                }
            } else {
                if position.x > zeroPosition.x {
                    for i in zeroPosition.x+1...position.x {
                        puzzles.append(puzzleArray[i][position.y])
                    }
                } else {
                    for i in (position.x...zeroPosition.x-1).reversed() {
                        puzzles.append(puzzleArray[i][position.y])
                    }
                }
            }
            
            
            UIView.animate(withDuration: 0.2,
                            delay: 0,
                            options: [],
                            animations: { [weak self] in
                                
                                
                                for puzzle in puzzles {
                                    position = self!.getPuzzlePosition(for: puzzle) ?? (0, 0)
                                    zeroPosition = self!.getZeroPosition() ?? (0, 0)
                                    
                                    let zeroRect = self?.coordArray[zeroPosition.0][zeroPosition.1]
                                    let puzzleButton = self!.view.viewWithTag(puzzle)
                                    puzzleButton!.frame = zeroRect!
                                    self?.puzzleArray[zeroPosition.0][zeroPosition.1] = puzzle
                                    self?.puzzleArray[position.0][position.1] = 0
                                }
                                
                                self!.amountOfTaps += 1
                                self!.currentTapsLabel.text = String(self!.amountOfTaps)
                                
                             
            })
            if checkIfFinish() {
                cleanTimer()
                showCongratulations()
            }
        }
    }
    
    func getPuzzlePosition(for tag: Int) -> (x: Int, y: Int)? {
        for i in 0..<amountOfPuzzlesInRow {
            for j in 0..<amountOfPuzzlesInRow {
                
                if puzzleArray[i][j] == tag {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    func getZeroPosition() -> (x: Int, y: Int)? {
        for i in 0..<amountOfPuzzlesInRow {
            for j in 0..<amountOfPuzzlesInRow {
                
                if puzzleArray[i][j] == 0 {
                    return (i, j)
                }
            }
        }
        return nil
    }
    
    func checkIfZeroIsNear(_ position: (x: Int, y: Int), _ zeroPosition: (x: Int, y: Int)) -> Bool {
        
        if ((position.y - 1 == zeroPosition.y) && (position.x == zeroPosition.x)) ||
            ((position.y + 1 == zeroPosition.y) && (position.x == zeroPosition.x)) {
            return true
        }
        if ((position.x - 1 == zeroPosition.x) && (position.y == zeroPosition.y)) ||
            ((position.x + 1 == zeroPosition.x) && (position.y == zeroPosition.y)){
            return true
        }
        
        return false
    }
    
    func checkIfZeroInLine(_ position: (x: Int, y: Int), _ zeroPosition: (x: Int, y: Int)) -> Bool {
    
        if position.x == zeroPosition.x || position.y == zeroPosition.y {
            return true
        }
        return false
    }
    
    func selectNewPuzzleSize(_ size: Int) {
        for i in 1...amountOfPuzzles {
                   let button = self.view.viewWithTag(i)
                   button?.removeFromSuperview()
                   button?.isHidden = true
               }
               
               switch size {
               case 0:
                   amountOfPuzzles = 8
                   break
               case 1:
                   amountOfPuzzles = 15
                   break
               case 2:
                   amountOfPuzzles = 24
                   break
               case 3:
                   amountOfPuzzles = 35
                   break
               default:
                   amountOfPuzzles = 15
               }
               
               amountOfPuzzlesInRow = Int(sqrt(Double(amountOfPuzzles + 1)))
               
               initArrays()
               setupPuzzleView()
    }
    
    func checkIfFinish() -> Bool {
        guard timer != nil else { return false }
        
        var count = 1
        for x in 0..<amountOfPuzzlesInRow {
            for y in 0..<amountOfPuzzlesInRow {
                if count == amountOfPuzzles+1 && puzzleArray[x][y] == 0 {
                    break
                }
                if puzzleArray[x][y] != count {
                    return false
                }
                count += 1
            }
        }
        return true
    }
    
    func showCongratulations() {
        let alert = UIAlertController(title: "Congratulations", message: "Great job!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerData.getPickerData().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return PickerData.getPickerData()[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGameSize = row
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
       
    
}
