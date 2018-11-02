//
//  HomeViewController.swift
//  Balapoint
//
//  Created by Gina De La Rosa on 05/01/18.
//  Copyright © 2017 Gina Delarosa. All rights reserved.

//  What user will first see after logging in or signing up.
    
import UIKit
import SDWebImage
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var users = [Userr]()
    
    var post: Post?
    
    var imagesArray: [UIImage?] = [UIImage(named: "Lifestyle.png"), UIImage(named: "Tech.png"), UIImage(named: "Travel.png"), UIImage(named: "Food.png"), UIImage(named: "Media.png"), UIImage(named: "Education.png"), UIImage(named: "Finance.png"), UIImage(named: "Health.png"), UIImage(named: "Beauty.png")]
    var topicTitles: [String?] = ["Lifestyle", "Tech", "Travel", "Food", "Media", "Education", "Finance", "Health", "Beauty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        settingsBarButton()
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.allowsSelection = true
        loadPosts()
        if self.posts.isEmpty {
            self.tableView?.backgroundView = self.emptyHomeLabel
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    // Empty State Label
    let emptyHomeLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "Hmm...\n Follow people to populate your feed."
        messageLabel.textColor = #colorLiteral(red: 0.1538375616, green: 0.1488625407, blue: 0.1489177942, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Futura", size: 20)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    ///Navigation Bar
        func settingsBarButton() {
            let button: UIButton = UIButton(type: UIButtonType.custom)
            button.setImage(UIImage(named: "Search.png"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(goToSearch), for: UIControlEvents.touchUpInside)
            button.frame = CGRect(x:0.0,y:0.0, width:25,height: 25.0)
            let barButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = barButton
            self.navigationItem.title = "Balapoint"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 18)!]
        }

    /// Go to Search View Controller
    @objc func goToSearch() {
        print("Search icon tapped")
        self.performSegue(withIdentifier: "Search_Segue", sender:SearchViewController())
    }
    
    /// Will load all posts onto users feed.
    
    func loadPosts() {
        
        Api.Feed.observeFeed(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
            guard let postUid = post.uid else { return }
            
            self.fetchUser(uid: postUid, completed: {
                self.posts.append(post)
                // TODO: Sort by date published 
//                self.posts.sort(by: {(p1, p2) -> Bool in
//                    return p1.date?.compare(p2.date!) == .orderedDescending
//                })
                self.tableView.reloadData()
                
            })
            
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            
            self.tableView.reloadData()
        }
//        if self.posts.isEmpty {
//            self.tableView?.backgroundView = self.emptyHomeLabel
//        }
       
        activityIndicatorView.stopAnimating()
    }
    
    // Fetches User
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.Userr.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
    
    // Save posts
    func didSavePost(post: Post) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("saved").child(uid)
        
        guard let postId = post.id else { return }
        
        let values = [postId: post.uid]
        ref.updateChildValues(values as [AnyHashable : Any]) { (err, ref) in
            if let err = err {
                print("Failed to put save post data in db:", err)
                return
            }
            print("Successfully put save post in db")
        }
    }

    
    // Will segue go to DetailVC is title of post is selected.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost_Segue" {
            let detailVC = segue.destination as! DetailViewController
            let postID = sender  as! String
            detailVC.postId = postID
        }
        // Testing to go to Profile View Controller 
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userID = sender  as! String
            profileVC.userId = userID
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        controller.navigationItem.title = topicTitles[indexPath.item]
        controller.setBackButton()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - TableView Data Source and Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section \(indexPath.section), Row : \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: Segue Actions
extension HomeViewController: HomeTableViewCellDelegate {
    
    func goToDetailPostVC(postId: String) {
        performSegue(withIdentifier: "DetailPost_Segue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
