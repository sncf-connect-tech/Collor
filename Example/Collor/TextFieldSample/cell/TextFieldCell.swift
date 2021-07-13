//
//  TextFieldCell.swift
//  Collor
//
//  Created by Guihal Gwenn on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Collor


@objc
public protocol RealTextFieldCellDelegate {

    @objc
    func textFieldDidEndEditing(_ textField: UITextField)

}


public protocol TextFieldCellDelegate: CollectionUserEventDelegate {

    func supplyDelegate() -> RealTextFieldCellDelegate

}


public final class TextFieldCell: UICollectionViewCell, CollectionCellAdaptable {

    @IBOutlet weak var textField: UITextField!

    private var delegate: TextFieldCellDelegate?

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func update(with adapter: CollectionAdapter) {
//        guard let adapter = adapter as? TextFieldAdapterProtocol else {
//            fatalError("TextFieldAdapterProtocol required")
//        }
    }

    public func set(delegate: CollectionUserEventDelegate?) {
        guard delegate is TextFieldCellDelegate else {
            return
        }

        textField.addTarget(delegate,
                            action: #selector(RealTextFieldCellDelegate.textFieldDidEndEditing),
                            for: .editingDidEnd)
    }

}

public protocol TextFieldAdapterProtocol: CollectionAdapter {

}

public struct TextFieldAdapter: TextFieldAdapterProtocol {

    public init() {

    }

}

public final class TextFieldDescriptor: CollectionCellDescribable {
    
    public let identifier: String = "TextFieldCell"
    public let className: String = "TextFieldCell"
    public var selectable: Bool = false
    
    let adapter: TextFieldAdapterProtocol
    
    public init(adapter: TextFieldAdapterProtocol) {
        self.adapter = adapter
    }
    
    public func size(_ collectionView: UICollectionView,
                     sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width: CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right - 80
        return CGSize(width: width, height: 50)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
