//
//  AnimatedReloadAnimator.swift
//  movieListChallenge
//
//  Created by Nijat Muzaffarli on 2021/10/21.
//

import CollectionKit
import Foundation
import UIKit

class AnimatedReloadAnimator: CollectionKit.Animator {
    static let defaultEntryTransform: CATransform3D = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1), 0, 0, -1)
    static let fancyEntryTransform: CATransform3D = {
        var trans = CATransform3DIdentity
        trans.m34 = -1 / 500
        return CATransform3DScale(CATransform3DRotate(CATransform3DTranslate(trans, 0, -50, -100), 0.5, 1, 0, 0), 0.8, 0.8, 1)
    }()

    let entryTransform: CATransform3D

    init(entryTransform: CATransform3D = defaultEntryTransform) {
        self.entryTransform = entryTransform
        super.init()
    }

    override func delete(collectionView: CollectionView, view: UIView) {
        if collectionView.isReloading, collectionView.bounds.intersects(view.frame) {
            UIView.animate(withDuration: 0.25, animations: {
                view.layer.transform = self.entryTransform
                view.alpha = 0
            }, completion: { _ in
                if !collectionView.visibleCells.contains(view) {
                    view.recycleForCollectionKitReuse()
                    view.transform = CGAffineTransform.identity
                    view.alpha = 1
                }
            })
        } else {
            view.recycleForCollectionKitReuse()
        }
    }

    override func insert(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
        view.bounds = frame.bounds
        view.center = frame.center
        if collectionView.isReloading, collectionView.hasReloaded, collectionView.bounds.intersects(frame) {
            let offsetTime: TimeInterval = TimeInterval(frame.origin.distance(collectionView.contentOffset) / 3000)
            view.layer.transform = entryTransform
            view.alpha = 0
            UIView.animate(withDuration: 0.5, delay: offsetTime, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                view.transform = .identity
                view.alpha = 1
            })
        }
    }

    override func update(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
        if view.center != frame.center {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.layoutSubviews], animations: {
                view.center = frame.center
            }, completion: nil)
        }
        if view.bounds.size != frame.bounds.size {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.layoutSubviews], animations: {
                view.bounds.size = frame.bounds.size
            }, completion: nil)
        }
        if view.alpha != 1 || view.transform != .identity {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.transform = .identity
                view.alpha = 1
            }, completion: nil)
        }
    }
}

extension UIColor {
    static var lightBlue: UIColor {
        return UIColor(red: 0, green: 184 / 255, blue: 1.0, alpha: 1.0)
    }
}

extension CGFloat {
    func clamp(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
        return self < a ? a : (self > b ? b : self)
    }
}

extension CGPoint {
    func translate(_ dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }

    func transform(_ t: CGAffineTransform) -> CGPoint {
        return applying(t)
    }

    func distance(_ b: CGPoint) -> CGFloat {
        return sqrt(pow(x - b.x, 2) + pow(y - b.y, 2))
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func * (left: CGFloat, right: CGPoint) -> CGPoint {
    return right * left
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

prefix func - (point: CGPoint) -> CGPoint {
    return CGPoint.zero - point
}

func / (left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width / right, height: left.height / right)
}

func - (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x - right.width, y: left.y - right.height)
}

prefix func - (inset: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: -inset.top, left: -inset.left, bottom: -inset.bottom, right: -inset.right)
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(origin: center - size / 2, size: size)
    }
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

extension String {
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.width
    }
}
