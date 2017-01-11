//
//  ViewController.swift
//  ShakeEditCollectionView
//
//  Created by 张和悦 on 2017/1/11.
//  Copyright © 2017年 com.ZHY. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let shakeLayout = ShakeLayout()
    private var collectionView: UICollectionView! = nil
    private let editButton = UIButton()

    fileprivate var isEdit: Bool = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate var originData: [String] = ["Bring", "the", "power", "of", "Swift", "functional", "programming", "to iOS", "Web", "macOS", "watchOS", "and", "tvOS", "application", "development"] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    private func setup() {
        shakeLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        shakeLayout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: shakeLayout)
        collectionView.register(ShakeCell.self, forCellWithReuseIdentifier: "ShakeCell")
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitle("完成", for: .selected)
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.addTarget(self, action: #selector(self.selectEditButton(sender:)), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    private func layout() {
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.center.equalTo(self.view)
            make.height.equalTo(300)
        }
        editButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.right.equalTo(-30)
            make.top.equalTo(30)
        }
    }
    
    func selectEditButton(sender: UIButton) {
        editButton.isSelected = !editButton.isSelected
        isEdit = !isEdit
    }

}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShakeCell", for: indexPath) as! ShakeCell
        cell.setText(text: originData[indexPath.row])
        cell.observeDelete { [weak self] text in
            guard let strongSelf = self else { return }
            strongSelf.originData = strongSelf.originData.filter { $0 != text }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ShakeCell else {
            return
        }
        if isEdit {
            cell.startEdit()
        } else {
            cell.stopEdit()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return originData.count
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = originData[indexPath.row] as NSString
        let width = text.size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)]).width
        return CGSize(width: width + 10, height: 30)
    }
    
}

