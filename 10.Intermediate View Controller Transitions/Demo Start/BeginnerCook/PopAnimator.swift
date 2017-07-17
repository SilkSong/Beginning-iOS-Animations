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


class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  let duration = 1.0
  var originFrame = CGRect.zero
    
    var presenting = true
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    //1) Set up transition
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    
    let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
    
    let initialFrame = presenting ? originFrame : herbView.frame
    let finalFrame = presenting ? herbView.frame : originFrame
    
    let scaleFactor = CGAffineTransform(scaleX: originFrame.width / herbView.frame.width, y: originFrame.height / herbView.frame.height)

    if presenting {
        
//        herbView.transform = CGAffineTransform(
//            scaleX: initialFrame.width / finalFrame.width,
//            y: initialFrame.height / finalFrame.height
//        )
        herbView.transform = scaleFactor
        herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
    }
    containerView.addSubview(toView)
    containerView.bringSubview(toFront: herbView)
    
    //2) Animate!
    UIView.animate(
      withDuration: duration,
      delay: 0.0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.0,
      animations: {
      
        herbView.transform = self.presenting ? .identity : scaleFactor
            herbView.center = CGPoint(
                x: finalFrame.midX,
                y: finalFrame.midY
            )
    },

      completion: {_ in
    //3) Complete transition
        
        if !self.presenting {
            let viewController = transitionContext.viewController(forKey: .to) as! ViewController
            viewController.selectedImage?.isHidden = false
        }
        transitionContext.completeTransition(true)
      }
    )
  }
}
