//
//  ShakeCell.swift
//  ShakeEditCollectionView
//
//  Created by 张和悦 on 2017/1/11.
//  Copyright © 2017年 com.ZHY. All rights reserved.
//

import UIKit
import SnapKit

class ShakeCell: UICollectionViewCell {

    private let label = UILabel()
    private let deleteButton = UIButton(type: .contactAdd)
    private var deleteClosure: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = UIColor.blue.cgColor
        
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(label)
        
        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(self.deleteText), for: .touchUpInside)
        contentView.addSubview(deleteButton)
    }
    
    private func layout() {
        label.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.right.equalTo(10)
            make.top.equalTo(-10)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !deleteButton.isHidden && deleteButton.frame.contains(point) {
            return deleteButton
        }
        return super.hitTest(point, with: event)
    }
    
    func observeDelete(closure: @escaping (String) -> ()) {
        deleteClosure = closure
    }
    
    func startEdit() {
        deleteButton.isHidden = false
        startShake()
    }
    
    func stopEdit() {
        deleteButton.isHidden = true
        stopShake()
    }
    
    private func startShake() {
        let animation =  CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [2 / self.frame.width, -2 / self.frame.width]
        animation.duration = 0.3
        animation.isAdditive = true
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        self.layer.add(animation, forKey: "shake")
    }
    
    private func stopShake() {
        self.layer.removeAnimation(forKey: "shake")
    }
    
    func setText(text: String) {
        label.text = text
    }
    
    func deleteText() {
        deleteClosure?(label.text!)
    }
}
