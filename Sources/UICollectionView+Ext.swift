//
//  UICollectionView+Ext.swift
//  YMExtension
//
//  Created by lym on 2022/6/7.
//

import Foundation

public extension ExtWrapper where Base: UICollectionView {
    /// SwifterSwift: Dequeue reusable UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionViewCell object with associated class name.
    func dequeueReusableCell<T: UICollectionViewCell>(
        withClass name: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = base.dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T
        else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        return cell
    }

    /// SwifterSwift: Dequeue reusable UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionReusableView object with associated class name.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass name: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = base.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: name),
            for: indexPath
        ) as? T
        else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name))")
        }
        return cell
    }

    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(
        supplementaryViewOfKind kind: String,
        withClass name: T.Type
    ) {
        base.register(T.self,
                      forSupplementaryViewOfKind: kind,
                      withReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameter name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        base.register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Safely scroll to possibly invalid IndexPath.
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to.
    ///   - scrollPosition: Scroll position.
    ///   - animated: Whether to animate or not.
    func safeScrollToItem(at indexPath: IndexPath,
                          at scrollPosition: UICollectionView.ScrollPosition,
                          animated: Bool)
    {
        guard indexPath.item >= 0,
              indexPath.section >= 0,
              indexPath.section < base.numberOfSections,
              indexPath.item < base.numberOfItems(inSection: indexPath.section)
        else {
            return
        }
        base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    /// SwifterSwift: Check whether IndexPath is valid within the CollectionView.
    ///
    /// - Parameter indexPath: An IndexPath to check.
    /// - Returns: Boolean value for valid or invalid IndexPath.
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.item >= 0 &&
            indexPath.section < base.numberOfSections &&
            indexPath.item < base.numberOfItems(inSection: indexPath.section)
    }
}
