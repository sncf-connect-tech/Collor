//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit
import Collor

public final class ___VARIABLE_productName:identifier___CollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? ___VARIABLE_productName:identifier___AdapterProtocol else {
            fatalError("___VARIABLE_productName:identifier___AdapterProtocol required")
        }        
    }

}

public protocol ___VARIABLE_productName:identifier___AdapterProtocol: CollectionAdapter {
}

public struct ___VARIABLE_productName:identifier___Adapter: ___VARIABLE_productName:identifier___AdapterProtocol {

    public init() {
        
    }

}

public final class ___VARIABLE_productName:identifier___Descriptor: CollectionCellDescribable {
    
    public let identifier: String = "___VARIABLE_productName:identifier___CollectionViewCell"
    public let className: String = "___VARIABLE_productName:identifier___CollectionViewCell"
    public var selectable: Bool = false
    
    let adapter: ___VARIABLE_productName:identifier___AdapterProtocol
    
    public init(adapter: ___VARIABLE_productName:identifier___AdapterProtocol) {
        self.adapter = adapter
    }
    
    public func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width: CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width: width, height: 100)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
