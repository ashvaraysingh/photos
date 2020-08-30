//
//  PinterestLayout.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  // 1
  weak var delegate: PinterestLayoutDelegate?

  // 2
  var numberOfColumns = 2
  private let cellPadding: CGFloat = 6

  // 3
  var cache: [UICollectionViewLayoutAttributes] = []

  // 4
  var contentHeight: CGFloat = 0

  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  // 5
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    guard cache.isEmpty == true, let collectionView = collectionView else {
        return
    }
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
        
      let photoHeight = delegate?.collectionView(
        collectionView,
        heightForPhotoAtIndexPath: indexPath) ?? 180
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column],
                         y: yOffset[column],
                         width: columnWidth,
                         height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
        
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
    
//    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
//        let context = super.invalidationContext(forBoundsChange: newBounds)
//          guard let invalidationContext = context as? UICollectionViewFlowLayoutInvalidationContext,
//              let collectionView = self.collectionView else { return context }
//
//          let oldBounds = collectionView.bounds
//
//          // MARK: Change the size of content according to the new bounds
//          invalidationContext.contentSizeAdjustment = CGSize(width: (newBounds.size.width - oldBounds.size.width) * CGFloat(collectionView.numberOfItems(inSection: 0)), height: newBounds.size.height - oldBounds.size.height)
//          invalidationContext.invalidateFlowLayoutDelegateMetrics = oldBounds.size != newBounds.size
//
//          // MARK: Keep scroll position on the same element as before the change of bounds
//          let oldOffset = collectionView.contentOffset
//          let newOffset: CGPoint
//
//          if let firstVisibleIndexPath = collectionView.indexPathsForVisibleItems.sorted(by: { $0 < $1 }).first,
//              let flowLayoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
//              // MARK: Calculate new vertical offset
//              var rowHeights: [Int: CGFloat] = [:]
//              var maxRowHeight: CGFloat = 0
//              var currentRowWidth: CGFloat = 0
//              var currentRow = 0
//
//              for row in 0...firstVisibleIndexPath.row {
//                  let indexPath = IndexPath(row: row, section: firstVisibleIndexPath.section)
//                  guard let cellSize = flowLayoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) else { continue }
//
//                  if currentRowWidth + cellSize.width > newBounds.width {
//                      // MARK: For multicolumns layout add offset to y only for each new row
//                      currentRowWidth = cellSize.width
//
//                      currentRow += 1
//                      rowHeights[currentRow] = maxRowHeight
//                      maxRowHeight = cellSize.height
//                  } else {
//                      maxRowHeight = max(cellSize.height, maxRowHeight)
//                      currentRowWidth += cellSize.width
//                  }
//              }
//
//              newOffset = CGPoint(x: oldOffset.x, y: rowHeights.reduce(CGFloat(0), { $0 + $1.value }))
//          } else {
//              newOffset = CGPoint(x: (oldOffset.x / oldBounds.width) * newBounds.width, y: 0)
//          }
//          context.contentOffsetAdjustment = CGPoint(x: newOffset.x - oldOffset.x, y: newOffset.y - oldOffset.y)
//
//          return context
//    }
    
}
