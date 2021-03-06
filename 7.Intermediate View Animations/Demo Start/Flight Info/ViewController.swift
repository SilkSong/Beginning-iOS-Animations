/*
* Copyright (c) 2014-2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore


//MARK: ViewController
class ViewController: UIViewController {
  
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNr: UILabel!
  @IBOutlet var gateNr: UILabel!
  @IBOutlet var departingFrom: UILabel!
  @IBOutlet var arrivingTo: UILabel!
  @IBOutlet var planeImage: UIImageView!
  
  @IBOutlet var flightStatus: UILabel!
  @IBOutlet var statusBanner: UIImageView!
  
  var snowView: SnowView!
  
  //MARK: animations
  func fade(
    toImage: UIImage,
    showEffects: Bool
    ) {
    //Create & set up helper view
    let overlayView = UIImageView(frame: bgImageView.frame)
    overlayView.image = toImage
    overlayView.alpha = 0.0
    overlayView.center.y += 20
    overlayView.bounds.size.width = bgImageView.bounds.width * 1.3
    bgImageView.superview?.insertSubview(
      overlayView,
      aboveSubview: bgImageView
    )
    
    UIView.animate(
      withDuration: 0.5,
      animations: {
        //Fade helper view in
        overlayView.alpha = 1.0
        overlayView.center.y -= 20
        overlayView.bounds.size = self.bgImageView.bounds.size
      }, completion: { _ in
        //Update background view & remove helper view
        self.bgImageView.image = toImage
        overlayView.removeFromSuperview()
      }
    )
    
    UIView.animate(
      withDuration: 1.0,
      delay: 0.0,
      options: [.curveEaseOut],
      animations: {
        self.snowView.alpha = showEffects ? 1.0 : 0.0
      },
      completion: nil
    )
  }
  
  func moveLabel(
    label: UILabel,
    text: String,
    offset: CGPoint
  ) {
    //TODO: Fancy animation goes here
  }
  
  func cubeTransition(
    label: UILabel,
    text: String
  ) {
    //TODO: Animate me!!
  }
  
  //MARK: custom methods
  
  func changeFlight(to data: FlightData, animated: Bool = false) {
    
    // populate the UI with the next flight's data
    summary.text = data.summary
    flightNr.text = data.flightNr
    gateNr.text = data.gateNr
    flightStatus.text = data.flightStatus
    departingFrom.text = data.departingFrom
    arrivingTo.text = data.arrivingTo

    
    // animate the UI
    if animated {
      fade(
        toImage: UIImage(named: data.weatherImageName)!,
        showEffects: data.showWeatherEffects
      )
    } else {
      bgImageView.image = UIImage(named: data.weatherImageName)
      snowView.isHidden = !data.showWeatherEffects
    }
    
    // schedule next flight
    delay(seconds: 3.0) {
      self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
    }
  }
  
  //MARK: view controller methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //adjust ui
    summary.addSubview(summaryIcon)
    summaryIcon.center.y = summary.frame.size.height/2
    
    //add the snow effect layer
    snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
    let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
    
    //start rotating the flights
    changeFlight(to: londonToParis, animated: false)
  }

  
  //MARK: utility methods
  func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
  }
  
  func duplicateLabel(label: UILabel) -> UILabel {
    let auxLabel = UILabel(frame: label.frame)
    auxLabel.font = label.font
    auxLabel.textAlignment = label.textAlignment
    auxLabel.textColor = label.textColor
    auxLabel.backgroundColor = label.backgroundColor
    return auxLabel
  }
}
