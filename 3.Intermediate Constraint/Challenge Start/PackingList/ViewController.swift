/**
 * Copyright (c) 2017 Razeware LLC
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

class ViewController: UIViewController {
  
  //MARK: IB outlets
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var buttonMenu: UIButton!
  @IBOutlet var titleLabel: UILabel!
  
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var closeButtonTrailing: NSLayoutConstraint!
  
  //MARK: further class variables
  
  var slider: HorizontalItemList!
  var isMenuOpen = false
  var items: [Int] = [5, 6, 7]
  
  //MARK: class methods
  
  @IBAction func actionToggleMenu(_ sender: AnyObject) {
    isMenuOpen = !isMenuOpen
    
    titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
    view.layoutIfNeeded()
    
    titleLabel.superview?.constraints.forEach { constraint in
      if constraint.firstItem === titleLabel &&
        constraint.firstAttribute == .centerX {
        constraint.constant = isMenuOpen ? -100.0 : 0.0
        return
      }
      
      if constraint.identifier == "TitleCenterY" {
        constraint.isActive = false
        
        let newConstraint = NSLayoutConstraint(
          item: titleLabel,
          attribute: .centerY,
          relatedBy: .equal,
          toItem: titleLabel.superview!,
          attribute: .centerY,
          multiplier: isMenuOpen ? 0.67 : 1.0,
          constant: 5.0
        )
        newConstraint.identifier = "TitleCenterY"
        newConstraint.isActive = true
      }
    }
    
    menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
    closeButtonTrailing.constant = isMenuOpen ? 16.0 : 8.0
    
    UIView.animate(
      withDuration: 0.33,
      delay: 0.0,
      options: .curveEaseIn,
      animations: {
        let angle: CGFloat = self.isMenuOpen
          ? .pi / 4
          : 0.0
        self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
        self.view.layoutIfNeeded()
      },
      completion: nil
    )
  }
  
  func showItem(_ index: Int) {
    print("tapped item \(index)")
    let imageView = makeImageView(index: index)
    view.addSubview(imageView)
    
    let conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    let conTop = imageView.topAnchor.constraint(equalTo: view.bottomAnchor)
    let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3, constant: -50)
    let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    
    NSLayoutConstraint.activate([conX, conTop, conWidth, conHeight])
    
    print("imageView.frame.size.height  is \(imageView.frame.height)")
    print("imageView.frame.size.width is \(imageView.frame.width)")
    //TODO: Create and animate some constraints!
    
    view.layoutIfNeeded()
    
    conTop.constant = -imageView.frame.size.height / 2
    conWidth.constant = 0.0
    
    UIView.animate(
        withDuration: 0.8,
        delay: 0.0,
        animations: {
            self.view.layoutIfNeeded()
    },
        completion: nil
    )
    
    
    conTop.constant = 0.0
    conWidth.constant = -50
    UIView.animate(
        withDuration: 0.67,
        delay: 2.0,
        animations: {
            self.view.layoutIfNeeded()
        },
        completion: nil
    )
  }
    
    

  func transitionCloseMenu() {
    //TODO: Close the menu with a cool transition
    delay(seconds: 0.35, completion: {
      self.actionToggleMenu(self)
    })
  }
}

//////////////////////////////////////
//
//   Starter project code
//
//////////////////////////////////////

let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func makeImageView(index: Int) -> UIImageView {
    let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
    imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    imageView.layer.cornerRadius = 5.0
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }
  
  func makeSlider() {
    slider = HorizontalItemList(inView: view)
    slider.didSelectItem = {index in
      print("add \(index)")
      self.items.append(index)
      self.tableView.reloadData()
      self.transitionCloseMenu()
    }
    self.titleLabel.superview?.addSubview(slider)
  }
  
  // MARK: View Controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    makeSlider()
    self.tableView?.rowHeight = 54.0
  }
  
  // MARK: Table View methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    cell.accessoryType = .none
    cell.textLabel?.text = itemTitles[items[indexPath.row]]
    cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    showItem(items[indexPath.row])
  }
  
}
