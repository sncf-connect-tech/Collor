//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

import UIKit
import Collor

final class ___FILEBASENAMEASIDENTIFIER___CollectionViewCell: UICollectionViewCell, CollectionCellAdaptable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with adapter: CollectionAdapter) {
        guard let adapter = adapter as? ___FILEBASENAMEASIDENTIFIER___Adapter else {
            fatalError("___FILEBASENAMEASIDENTIFIER___Adapter required")
        }        
    }

}

final class ___FILEBASENAMEASIDENTIFIER___Descriptor: CollectionCellDescribable {
    
    let identifier: String = "___FILEBASENAME___CollectionViewCell"
    let className: String = "___FILEBASENAME___CollectionViewCell"
    var selectable:Bool = false
    
    let adapter: ___FILEBASENAME___Adapter
    
    init(adapter:___FILEBASENAME___Adapter) {
        self.adapter = adapter
    }
    
    func size(_ collectionView: UICollectionView, sectionDescriptor: CollectionSectionDescribable) -> CGSize {
        let sectionInset = sectionDescriptor.sectionInset(collectionView)
        let width:CGFloat = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return CGSize(width:width, height:100)
    }
    
    public func getAdapter() -> CollectionAdapter {
        return adapter
    }
}
