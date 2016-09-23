//
//  Extensions.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 28/03/16.
//
//  Copyright (c) 2016 Alex Usbergo.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit

public extension FlexboxView where Self: UIView {

  /// content-size calculation for the scrollview should be applied after the layout
  /// This is called after the scroll view is rendered.
  /// TableViews and CollectionViews are excluded from this post-render pass
  func postRender() {
    if let scrollView = self as? UIScrollView {
      if let _ = self as? UITableView { return }
      if let _ = self as? UICollectionView { return }
      scrollView.postRender()
    }
  }
}

public extension UIScrollView {

  fileprivate func postRender() {
    var x: CGFloat = 0
    var y: CGFloat = 0
    for subview in self.subviews {
      x = subview.frame.maxX > x ? subview.frame.maxX : x
      y = subview.frame.maxY > y ? subview.frame.maxY : y
    }
    self.contentSize = CGSize(width: x, height: y)
    self.isScrollEnabled = true
  }
}

