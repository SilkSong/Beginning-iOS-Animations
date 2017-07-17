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
    //Create & set up helper label
    let auxLabel = duplicateLabel(label: label)
    auxLabel.text = text

    auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    auxLabel.alpha = 0
    view.addSubview(auxLabel)
    
    //Fade out & translate real label
    UIView.animate(
      withDuration: 0.5,
      delay: 0.0,
      options: .curveEaseIn,
      animations: {
        label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        label.alpha = 0
      },
      completion: nil
    )
    
    //Fade in & translate helper label
    UIView.animate(
      withDuration: 0.25,
      delay: 0.2,
      options: .curveEaseIn,
      animations: {
        auxLabel.transform = .identity
        auxLabel.alpha = 1.0
      },
      completion: {_ in
        //Update real label & remove helper label
        label.text = text
        label.alpha = 1.0
        label.transform = .identity
        auxLabel.removeFromSuperview()
      }
    )
  }
  
  func cubeTransition(
    label: UILabel,
    text: String
  ) {
    //TODO: Animate me!!
    
    //Create & set up a helper label
    let auxLabel = duplicateLabel(label: label)
    auxLabel.text = text
    
    let auxLabelOffset = label.frame.size.height / 2
    
    let scale = CGAffineTransform(scaleX: 1.0, y: 0.1)
    let translate = CGAffineTransform(translationX: 0.0, y: auxLabelOffset)
    auxLabel.transform = scale.concatenating(translate)
    label.superview?.addSubview(auxLabel)
    
    UIView.animate(
        withDuration: 0.5,
        delay: 0,
        options: .curveEaseIn,
        animations: {
            //Scale and translate the real label up
            //Scale and translate the helper label down
            auxLabel.transform = .identity
            label.transform = scale.concatenating(translate.inverted())
        },
        completion: { _ in
            //Update the real label's text and reset its transform
            //Remove the helper label
            label.text = auxLabel.text
            label.transform = .identity
            
            auxLabel.removeFromSuperview()
        }
    )
    
  }
  
  //MARK: custom methods
  
  func changeFlight(to data: FlightData, animated: Bool = false) {
    
    // populate the UI with the next flight's data
    summary.text = data.summary
    flightNr.text = data.flightNr
    gateNr.text = data.gateNr

    
    // animate the UI
    if animated {
      fade(
        toImage: UIImage(named: data.weatherImageName)!,
        showEffects: data.showWeatherEffects
      )

      let offsetDeparting = CGPoint(
        x: data.showWeatherEffects ? -80.0 : 80,
        y: 0.0
      )
      
      let offsetArriving = CGPoint(
        x: 0.0,
        y: data.showWeatherEffects ? 50.0 : -50
      )
      
      moveLabel(
        label: departingFrom,
        text: data.departingFrom,
        offset: offsetDeparting
      )
      
      moveLabel(
        label: arrivingTo,
        text: data.arrivingTo,
        offset: offsetArriving
      )
    
     cubeTransition(label: flightStatus, text: data.flightStatus)
      
    } else {
      bgImageView.image = UIImage(named: data.weatherImageName)
      snowView.isHidden = !data.showWeatherEffects
      
      departingFrom.text = data.departingFrom
      arrivingTo.text = data.arrivingTo
        flightStatus.text = data.flightStatus
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
