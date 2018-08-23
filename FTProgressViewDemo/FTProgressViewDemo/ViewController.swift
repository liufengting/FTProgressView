//
//  ViewController.swift
//  FTProgressViewDemo
//
//  Created by liufengting on 2018/8/23.
//  Copyright © 2018年 liufengting. All rights reserved.
//

import UIKit
import FTProgressView

class ViewController: UIViewController {

    var progress: CGFloat = 0.0
    var progressView: CustomProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        self.progressView = Bundle.main.loadNibNamed("CustomProgressView", owner: nil, options: nil)?.first as? CustomProgressView
        progressView?.frame = CGRect(x: 100, y: 100, width: 100, height: 100);
        progressView?.progress = self.progress;
        
        
//        self.progressView.progressFillColor = UIColor.cyan.withAlphaComponent(0.1)
//        self.progressView.progressStrokeColor = UIColor.green
//        self.progressView.trackFillColor = UIColor.yellow.withAlphaComponent(0.1)
//        self.progressView.trackStrokeColor = UIColor.red
//        self.progressView.isClockwise = true
        
        self.view.addSubview(progressView!)

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.progress += 0.05;
            self.progressView?.progressLabel.text = "\(Int(self.progress * 100))%"
            self.progressView?.setProgress(progress: self.progress, animated: true);

            if self.progress > 1.0 {
                timer.invalidate()
                self.progressView?.progressLabel.text = "Done!"
            }
        };

        
    }

}

