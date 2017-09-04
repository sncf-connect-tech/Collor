//
//  CollectionUpdater+Diff.swift
//  Collor
//
//  Created by Guihal Gwenn on 04/08/2017.
//  Copyright (c) 2017-present, Voyages-sncf.com. All rights reserved.
//

import Foundation

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
            collectionData.computeIndexPaths(in: sectionDescriptor)
            
            do {
                try verifyUID(sectionIndex: sectionIndex, items: oldItems)
                try verifyUID(sectionIndex: sectionIndex, items: sectionDescriptor.cells)
            
                let old = oldItems.map(toDiffItem)
                let new = sectionDescriptor.cells.map(toDiffItem)
                
                let diff = CollorDiff(before: old, after: new)
                
                diff.deleted.forEach {
                    result?.deletedIndexPaths.append( $0 )
                    result?.deletedCellDescriptors.append( oldItems[$0.item] )
                }
                
                diff.inserted.forEach {
                    result?.insertedIndexPaths.append( $0 )
                    result?.insertedCellDescriptors.append( sectionDescriptor.cells[$0.item] )
                }
                
                diff.moved.forEach {
                    result?.movedIndexPaths.append( ($0.from, $0.to) )
                    result?.movedCellDescriptors.append( oldItems[$0.from.item])
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
        collectionData.computeIndices()
        
        do {
            try verifyUID(sections: oldSections)
            try verifyUID(sections: collectionData.sections)
            
            // 1th pass : sections
            let oldDiffItemSections = oldSections.map{ return ( $0.index!, $0.uid()! ) }
            let newDiffItemSections = collectionData.sections.map{ return ( $0.index!, $0.uid()! ) }
            
            let sectionsDiff = CollorDiff(before: oldDiffItemSections, after: newDiffItemSections)
            sectionsDiff.deleted.forEach {
                result?.deletedSectionsIndexSet.insert($0)
                result?.deletedSectionDescriptors.append( oldSections[$0] )
            }
            sectionsDiff.inserted.forEach {
                result?.insertedSectionsIndexSet.insert($0)
                result?.insertedSectionDescriptors.append( collectionData.sections[$0] )
            }
//            sectionsDiff.moved.forEach {
//                result?.movedSectionIndices.append( ($0.from, $0.to) )
//                result?.movedSectionDescriptors.append( oldSections[$0.from] )
//            }
            
            //2dc pass : items
            let old = oldSections.flatMap(toDiffItem)
            let new = collectionData.sections.flatMap(toDiffItem)
            
            let diff = CollorDiff(before: old, after: new)
            
            diff.deleted.forEach {
                result?.deletedIndexPaths.append( $0 )
                result?.deletedCellDescriptors.append( oldSections[$0.section].cells[$0.item] )
            }
            
            diff.inserted.forEach {
                result?.insertedIndexPaths.append( $0 )
                result?.insertedCellDescriptors.append( collectionData.sections[$0.section].cells[$0.item] )
            }
            
            diff.moved.forEach {
                result?.movedIndexPaths.append( ($0.from, $0.to) )
                result?.movedCellDescriptors.append( oldSections[$0.from.section].cells[$0.from.item])
            }
            
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
    
    private func toDiffItem(section:CollectionSectionDescribable) -> [(IndexPath,String)] {
        return section.cells.map { cell in
            return (cell.indexPath!, section.uid()! + "/" + cell.uid()!)
        }
    }
    
    private func toDiffItem(cell:CollectionCellDescribable) -> (IndexPath,String) {
        return (cell.indexPath!, cell.uid()!)
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
