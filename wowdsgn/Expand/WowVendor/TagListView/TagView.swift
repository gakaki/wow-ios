//
//  TagView.swift
//  TagListViewDemo
//
//  Created by Dongyuan Liu on 2015-05-09.
//  Copyright (c) 2015 Ela. All rights reserved.
//

import UIKit

@IBDesignable
open class TagView: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var textColor: UIColor = UIColor.white {
        didSet {
            setTitleColor(textColor, for: UIControlState())
        }
    }
    @IBInspectable var selectedTextColor: UIColor = UIColor.white {
        didSet {
            setTitleColor(isSelected ? selectedTextColor : textColor, for: UIControlState())
        }
    }
    @IBInspectable var paddingY: CGFloat = 2 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    @IBInspectable var paddingX: CGFloat = 5 {
        didSet {
            titleEdgeInsets.left = paddingX
            updateRightInsets()
        }
    }

    @IBInspectable open var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            backgroundColor = tagBackgroundColor
        }
    }
    
    @IBInspectable open var tagHighlightedBackgroundColor: UIColor? {
        didSet {
            if let color = tagHighlightedBackgroundColor , isHighlighted {
                backgroundColor = color
            }
            else {
                backgroundColor = tagBackgroundColor
            }
        }
    }
    
    @IBInspectable open var tagSelectedBackgroundColor: UIColor = UIColor.red {
        didSet {
            backgroundColor = isSelected ? tagSelectedBackgroundColor : tagBackgroundColor
        }
    }
    
    var textFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if let color = tagHighlightedBackgroundColor , isHighlighted {
                backgroundColor = color
            }
            else {
                backgroundColor = isSelected ? tagSelectedBackgroundColor : tagBackgroundColor
            }
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = tagSelectedBackgroundColor
                setTitleColor(selectedTextColor, for: UIControlState())
            }
            else {
                backgroundColor = tagBackgroundColor
                setTitleColor(textColor, for: UIControlState())
            }
        }
    }
    
    // MARK: remove button
    
    let removeButton = CloseButton()
    
    @IBInspectable var enableRemoveButton: Bool = false {
        didSet {
            removeButton.isHidden = !enableRemoveButton
            updateRightInsets()
        }
    }
    
    @IBInspectable var removeButtonIconSize: CGFloat = 12 {
        didSet {
            removeButton.iconSize = removeButtonIconSize
            updateRightInsets()
        }
    }
    
    @IBInspectable var removeIconLineWidth: CGFloat = 3 {
        didSet {
            removeButton.lineWidth = removeIconLineWidth
        }
    }
    @IBInspectable var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            removeButton.lineColor = removeIconLineColor
        }
    }
    
    /// Handles Tap (TouchUpInside)
    open var onTap: ((TagView) -> Void)?
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: UIControlState())
        
        setupView()
    }
    
    fileprivate func setupView() {
        frame.size = intrinsicContentSize
        addSubview(removeButton)
        removeButton.tagView = self
    }
    
    // MARK: - layout

    fileprivate func updateRightInsets() {
        if enableRemoveButton {
            titleEdgeInsets.right = paddingX  + removeButtonIconSize + paddingX
        }
        else {
            titleEdgeInsets.right = paddingX
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        var size = titleLabel?.text?.size(attributes: [NSFontAttributeName: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if enableRemoveButton {
            size.width += removeButtonIconSize + paddingX
        }
        return size
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if enableRemoveButton {
            removeButton.frame.size.width = paddingX + removeButtonIconSize + paddingX
            removeButton.frame.origin.x = self.frame.width - removeButton.frame.width
            removeButton.frame.size.height = self.frame.height
            removeButton.frame.origin.y = 0
        }
    }
}
