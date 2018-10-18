//
//  HomeViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 05/01/18.
//  Copyright © 2017 Gina Delarosa. All rights reserved.
//  What user will first see after logging in or signing up.
    
import UIKit
import SDWebImage

class HomeViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var users = [Userr]()
    
    var imagesArray: [UIImage?] = [UIImage(named: "Travel.png"), UIImage(named: "Health.png"), UIImage(named: "Education.png"), UIImage(named: "Food.png"), UIImage(named: "Media.png"), UIImage(named: "Tech.png"), UIImage(named: "Beauty.png"), UIImage(named: "Lifestyle.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarIcon(named: "Search")
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    ///Navigation Bar
    func addLeftBarIcon(named:String) {
        
        let logoImage = UIImage.init(named: named)
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:50,height:25.0)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.rightBarButtonItem = imageItem
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 18)!]
        
    }
    
    @objc func searchTapped() {
        print("Search icon tapped")
        //Action for searching 
    }
    
    /// Will load all posts onto users feed.
    
    func loadPosts() {
        
        Api.Feed.observeFeed(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            
            self.tableView.reloadData()
        }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.Userr.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost_Segue" {
            let detailVC = segue.destination as! DetailViewController
            let postID = sender  as! String
            detailVC.postId = postID
        }
    }
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicImageCollectionViewCell

        cell.imageView.image = imagesArray[indexPath.item]
        
        return cell
    }
}
// MARK: CollectionView Layout
extension HomeViewController : UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let collectionViewWidth = collectionView.bounds.width
//        return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/3)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}

// MARK: - TableView Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
    
}

extension HomeViewController: HomeTableViewCellDelegate {
    func goToDetailPostVC(postId: String) {
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
