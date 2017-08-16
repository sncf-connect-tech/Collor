//
//  CollectionUpdater+Diff.swift
//  Pods
//
//  Created by Guihal Gwenn on 04/08/2017.
//
//

import Foundation
import Dwifft

extension CollectionUpdater {
    
    private func raiseItemsMissingItemUIDException(items:[(Int, String)]) {
        let itemsInError = items.reduce("") { result, item in
            return result + "- section: \(item.0), uid:\(item.1)\n"
        }
        NSException(name: .collorDuplicateItemUID, reason: "Duplicate for items:\n \(itemsInError)", userInfo: nil).raise()
    }
    
    private func raiseItemsWithoutUIDException(items:[(Int, Int, CollectionCellDescribable)]) {
        let itemsInError = items.reduce("") { result, item in
            return result + "- section: \(item.0), item:\(item.1), description:\(item.2)\n"
        }
        NSException(name: .collorMissingItemUID, reason: "No UID given for items:\n \(itemsInError)", userInfo: nil).raise()
    }

    public func diff(sections sectionDescriptors:[CollectionSectionDescribable]) {
        
        sectionDescriptors.forEach { sectionDescriptor in
            
            guard let sectionIndex = sectionDescriptor.index else {
                NSException(name: .collorSectionIndexNil, reason: "SectionDescriptor index nil, call computeIndices() before.", userInfo: nil).raise()
                return
            }
            
            guard let sectionBuilder = sectionDescriptor.builder else {
                NSException(name: .collorSectionBuilderNil, reason: "SectionDescriptor reloadSection closure nil, call reloadSection() before", userInfo: nil).raise()
                return
            }
            
            let oldItems = sectionDescriptor.cells
            sectionDescriptor.cells.removeAll()
            sectionBuilder(&sectionDescriptor.cells)
            
            do {
                try verifyUID(sectionIndex: sectionIndex, items: oldItems)
                try verifyUID(sectionIndex: sectionIndex, items: sectionDescriptor.cells)
            
                let old = oldItems.map{ $0._uid! }
                let new = sectionDescriptor.cells.map{ $0._uid! }
                
                Dwifft.diff(old, new).forEach {
                    switch $0 {
                    case let .delete(item, _):
                        result?.deletedIndexPaths.append( IndexPath(item: item, section: sectionIndex ) )
                        result?.deletedCellDescriptors.append( oldItems[item] )
                    case let .insert(item, _):
                        result?.insertedIndexPaths.append( IndexPath(item: item, section: sectionIndex ) )
                        result?.insertedCellDescriptors.append( sectionDescriptor.cells[item] )
                    }
                }
                
            } catch UIDError.itemsWithoutUIDError(let items) {
                raiseItemsWithoutUIDException(items: items)
            } catch UIDError.itemsDuplicateError(let items) {
                raiseItemsMissingItemUIDException(items: items)
            } catch {}
        }
        
        if !sectionDescriptors.isEmpty {
            collectionData.computeIndices()
        }
    }
    
    public func diff() {
        let oldSections = collectionData.sections // store old model
        collectionData.reloadData() // compute new model
        
        do {
            try verifyUID(sections: oldSections)
            try verifyUID(sections: collectionData.sections)
            
            let old = mapToSectionedValues(oldSections)
            let new = mapToSectionedValues(collectionData.sections)
            
            Dwifft.diff(lhs: old, rhs: new).forEach {
                switch $0 {
                case let .delete(section, item, _):
                    result?.deletedIndexPaths.append( IndexPath(item: item, section: section ) )
                    result?.deletedCellDescriptors.append( oldSections[section].cells[item] )
                case let .insert(section, item, _):
                    result?.insertedIndexPaths.append( IndexPath(item: item, section: section ) )
                    result?.insertedCellDescriptors.append( collectionData.sections[section].cells[item] )
                case let .sectionDelete(section, _):
                    result?.deletedSectionsIndexSet.insert(section)
                    result?.deletedSectionDescriptors.append( oldSections[section] )
                case let .sectionInsert(section, _):
                    result?.insertedSectionsIndexSet.insert(section)
                    result?.insertedSectionDescriptors.append( collectionData.sections[section] )
                }
            }
            
            collectionData.computeIndices()
            
        } catch UIDError.sectionsWithoutUIDError(let sections) {
            let sectionsInError = sections.reduce("") { result, section in
                return result + "- section:\(section.0), description:\(section.1)\n"
            }
            NSException(name: .collorMissingSectionUID, reason: "No UID given for sections:\n \(sectionsInError)", userInfo: nil).raise()
        } catch UIDError.sectionsDuplicateError(let sections) {
            let sectionsInError = sections.reduce("") { result, section in
                return result + "- section:\(section.0), description:\(section.1)\n"
            }
            NSException(name: .collorDuplicateSectionUID, reason: "Duplicate for sections:\n \(sectionsInError)", userInfo: nil).raise()
        } catch UIDError.itemsWithoutUIDError(let items) {
            raiseItemsWithoutUIDException(items: items)
        } catch UIDError.itemsDuplicateError(let items) {
            raiseItemsMissingItemUIDException(items: items)
        } catch {}
    }
    
    private func mapToSectionedValues(_ sections:[CollectionSectionDescribable]) -> SectionedValues<String, String> {
        return SectionedValues( sections.map{ section -> (String, [String]) in
            let cellUids = section.cells.map{ return section._uid! + "/" + $0._uid! }
            return (section._uid!, cellUids)
        })
    }
    
    private enum UIDError : Error {
        case sectionsWithoutUIDError(sections:[(Int,CollectionSectionDescribable)])
        case itemsWithoutUIDError(items:[(Int,Int,CollectionCellDescribable)])
        case itemsDuplicateError(items:[(Int,String)])
        case sectionsDuplicateError(items:[(Int,String)])
    }
    
    private func verifyUID(sections:[CollectionSectionDescribable]) throws {
        var sectionsWithoutUID = [(Int,CollectionSectionDescribable)]()
        var sectionsDuplicateUID = [(Int,String)]()
        
        var setSections = Set<String>()
        
        for (sectionIndex, section) in sections.enumerated() {
            // sections wihtout uid
            guard let sectionUID = section._uid else {
                sectionsWithoutUID.append( (sectionIndex,section) )
                continue
            }
            
            // duplicate sections
            let insertResult = setSections.insert(sectionUID)
            if insertResult.inserted == false {
                sectionsDuplicateUID.append( (sectionIndex, insertResult.memberAfterInsert) )
            }
            
            // items
            do {
                try verifyUID(sectionIndex: sectionIndex, items: section.cells)
            } catch let error {
                throw error
            }
        }
        
        if !sectionsWithoutUID.isEmpty {
            throw UIDError.sectionsWithoutUIDError(sections: sectionsWithoutUID)
        } else if !sectionsDuplicateUID.isEmpty {
            throw UIDError.sectionsDuplicateError(items: sectionsDuplicateUID)
        }
    }
    
    private func verifyUID(sectionIndex:Int, items:[CollectionCellDescribable]) throws {
        
        var itemsWithoutUID = [(Int,Int,CollectionCellDescribable)]()
        var itemsDuplicateUID = [(Int,String)]()
        
        let tempSellsWithoutUID = items.enumerated().filter {
            return $0.element._uid == nil
            }.map {
                return (sectionIndex, $0.offset, $0.element)
        }
        itemsWithoutUID.append(contentsOf: tempSellsWithoutUID)
        
        // duplicate items
        var setCells = Set<String>()
        items.flatMap{ $0._uid }.forEach {
            let insertResult = setCells.insert($0)
            if insertResult.inserted == false {
                itemsDuplicateUID.append( (sectionIndex, insertResult.memberAfterInsert) )
            }
        }
        
        if !itemsWithoutUID.isEmpty {
            throw UIDError.itemsWithoutUIDError(items: itemsWithoutUID)
        } else if !itemsDuplicateUID.isEmpty {
            throw UIDError.itemsDuplicateError(items: itemsDuplicateUID)
        }
    }
}
