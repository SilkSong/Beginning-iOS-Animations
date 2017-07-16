import PlaygroundSupport
import UIKit

let view = SpringsView(frame: CGRect(
  x: 0, y: 0,
  width: 400, height: 800
))
PlaygroundPage.current.liveView = view
/*:
 
 # Springs!
 Change the properties below to quickly adjust the springy qualities of each view. Then, click the "Animate!" button in the live view to compare the effects!
 
 * Currently there are 3 different damping properties, but matching velocity (none!). It should be easy to compare the effect of damping!
 * Do you have a favorite? Try adjusting the duration. What is the effect?
 * Try setting all of the SpringDamping values to the same value, maybe 0.5. Then set the InitialSpringVelocities to 0.5, 1.0, and 50.0. 
 * Try adjusting the duration again to see the effect now.
 * Go nuts! Make all kinds of damping and velocity combinations and view them side-by-side.
*/

view.duration = 2.0

view.beachballSpringDamping = 0.1
view.beachballInitialSpringVelocity = 0.0

view.drinkSpringDamping = 0.5
view.drinkInitialSpringVelocity = 0.0

view.icecreamSpringDamping = 1.0
view.icecreamInitialSpringVelocity = 0.0
/*:
 **Remember:**
 
 *Damping* is a ratio ranging from 0 *(snappier oscillation)* to 1 *(no oscillation)*.
 
 *Initial Velocity* is a multiplier used to calculate the view's initial velocity in points/second. Here, 0 equates to *no velocity* and 1 equates to the velocity required for the view to travel the entire animated distance in 1 second.
 */

//: The animation code is below, for easy reference. The remainder of the supporting code can be found in the "Sources" folder.

extension SpringsView {
  func animate() {
    UIView.animate(
      withDuration: duration, delay: 0.0,
      usingSpringWithDamping: beachballSpringDamping,
      initialSpringVelocity: beachballInitialSpringVelocity,
      options: [], animations: {
        view.beachballConY.constant = view.beachballConY.constant * -1
        view.layoutIfNeeded()
      }, completion: nil
    )
    UIView.animate(withDuration: duration, delay: 0.0,
      usingSpringWithDamping: drinkSpringDamping,
      initialSpringVelocity: drinkInitialSpringVelocity,
      options: [], animations: {
        view.drinkConY.constant = view.drinkConY.constant * -1
        view.layoutIfNeeded()
      }, completion: nil
    )
    UIView.animate(withDuration: duration, delay: 0.0,
      usingSpringWithDamping: icecreamSpringDamping,
      initialSpringVelocity: icecreamInitialSpringVelocity,
      options: [], animations: {
        view.icecreamConY.constant = view.icecreamConY.constant * -1
        view.layoutIfNeeded()
      }, completion: nil
    )
  }
}
view.button.addTarget(view, action: #selector(view.animate), for: .touchUpInside)
