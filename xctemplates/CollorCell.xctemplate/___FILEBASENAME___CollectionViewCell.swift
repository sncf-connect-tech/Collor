//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit
import Collor

final class ___VARIABLE_productName:identifier___CollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? ___VARIABLE_productName:identifier___AdapterProtocol else {
            fatalError("___VARIABLE_productName:identifier___AdapterProtocol required")
        }        
    }

}

protocol ___VARIABLE_productName:identifier___AdapterProtocol: CollectionAdapter {
}

struct ___VARIABLE_productName:identifier___Adapter: ___VARIABLE_productName:identifier___AdapterProtocol {

    init() {
        
    }

}

final class ___VARIABLE_productName:identifier___Descriptor: CollectionCellDescribable {
    
    let identifier: String = "___VARIABLE_productName:identifier___CollectionViewCell"
    let className: String = "___VARIABLE_productName:identifier___CollectionViewCell"
    var selectable: Bool = false
    
    let adapter: ___VARIABLE_productName:identifier___AdapterProtocol
    
    init(adapter: ___VARIABLE_productName:identifier___AdapterProtocol) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width: CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width: width, height: 100)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
