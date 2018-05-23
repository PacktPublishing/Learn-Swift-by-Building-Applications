//
//  SecondViewController.swift
//  InstagramLikeApp
//
//  Created by Emil Atanasov on 10.02.18.
//  Copyright © 2018 ApposeStudio Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class SearchViewController: UIViewController {
    
    private let photoCellReuseIdentifier = "PhotoCell"
    var model:[PostModel]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "PhotoViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: photoCellReuseIdentifier)
        
        let gridLayout = GridLayout()
        gridLayout.fixedDivisionCount = 3
        gridLayout.scrollDirection = .vertical
        gridLayout.delegate = self
        
        collectionView.collectionViewLayout = gridLayout
        
        collectionView.dataSource = self
        searchBar.delegate = self
        loadData()
    }
    
    func loadData() {
        model = []
        DataManager.shared.fetchHomeFeed {[weak self] items in
            if items.count > 0 {
                self?.model? += items
                self?.collectionView.reloadData()
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as? PhotoViewCell else {
            return UICollectionViewCell()
        }
        
        guard let post = model?[indexPath.row] else {
            return cell
        }
        
        if let image = post.photoURL {
            let imgRef = Storage.storage().reference().child(image)
            cell.image.sd_setImage(with: imgRef)
        }
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if !searchText.isEmpty {
                
                DataManager.shared.search(for: searchText) {
                    [weak self] items in
                    self?.model? = items
                    self?.collectionView.reloadData()
                }
                
                searchBar.text = ""
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension SearchViewController: GridLayoutDelegate {
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        if indexPath.row % 9 == 0 {
            return 2
        }
        
        return 1
    }
}
