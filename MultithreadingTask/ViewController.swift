//
//  ViewController.swift
//  MultithreadingTask
//
//  Created by Anna Sumire on 08.11.23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        findWinnerThread()
    }
    
    func findWinnerThread() {
        let group = DispatchGroup()
        var winnerThread: String?
        
        let firstNum = generateRandomNumber()
        let secondNum = generateRandomNumber()
        
        group.enter()
        
        DispatchQueue.global().async(group: group) {
            self.factorial(n: firstNum) { result in
                print("Factorial of \(firstNum) calculated on \(Thread.current)")
                if winnerThread == nil{
                    winnerThread = "Thread 1"
                }
                group.leave()
            }
        }
        
        DispatchQueue.global().async(group: group) {
            self.factorial(n: secondNum) { result in
                print("Factorial of \(secondNum) calculated on \(Thread.current)")
                if winnerThread == nil {
                    winnerThread = "Thread 2"
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.global()) {
            print("The winner thread is \(winnerThread ?? "No Winner")")
        }
    }
    
    func generateRandomNumber() -> Int {
        return Int.random(in: 20...50)
    }
    
    func factorial(n: Int, completion: @escaping (Decimal) -> Void) {
        DispatchQueue.global().async {
            var res = Decimal(1)
            for i in 1...n {
                res *= Decimal(i)
            }
            
            DispatchQueue.main.async {
                completion(res)
            }
        }
    }
}
