//
//  DiscoverViewController.swift
//  Metis
//
//  Created by Gina De La Rosa on 11/15/17.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//

import UIKit
import Firebase

class SavedPostsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
       // fetchMyPosts()
    }
    
    @IBAction func refresh_TouchUpInside(_ sender: Any) {
      
    }
    
    // This is an example that will only display user's posts.
//    func fetchMyPosts() {
//        guard let currentUser = Api.Userr.CURRENT_USER else {
//            return
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Discover_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
        }
    }
}

extension SavedPostsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! ProfilePosts
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self

        return cell
    }
}

extension SavedPostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}

extension SavedPostsViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Discover_DetailSegue", sender: postId)
    }

}

