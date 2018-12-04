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
    @IBOutlet weak var messageLabel: UILabel!
    
    var posts = [Post]()
    var users = [Userr]()
    var blockList = [String]()
    var userr: Userr!
    

    var post: Post?
    lazy var postsRef = Database.database().reference().child("posts")
    
    var imagesArray: [UIImage?] = [UIImage(named: "Lifestyle.png"), UIImage(named: "Tech.png"), UIImage(named: "Travel.png"), UIImage(named: "Food.png"),UIImage(named: "Politics.png"), UIImage(named: "Media.png"), UIImage(named: "Education.png"), UIImage(named: "Finance.png"), UIImage(named: "Health.png"), UIImage(named: "Beauty.png")]
    
    var topicTitles: [String?] = ["Lifestyle", "Tech", "Travel", "Food", "Politics", "Media", "Education", "Finance", "Health", "Beauty"]
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        settingsBarButton()
        setupView()
        loadBlockList(completion: {
            self.loadPosts()
            self.removeBlockFeed()
        })
      
    }

    // Setup View
    private func setupView() {
        setupTableView()
        setupMessageLabel()
        setupActivityIndicatorView()
        updateView()
    }
    
    // Setup TableView
    private func setupTableView() {
        tableView.isHidden = true
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.allowsSelection = true
    }
    
    // Refreshes data
    @objc private func refreshData(_ sender: Any) {
        loadPosts()
    }
    
    // Activity Indicator Setup
    private func setupActivityIndicatorView() {
        activityIndicatorView.startAnimating()
    }
    
    private func updateView() {
        let hasPosts = posts.count > 0
        tableView.isHidden = !hasPosts
        messageLabel.isHidden = hasPosts
        if hasPosts {
            tableView.reloadData()
        }
        self.activityIndicatorView.stopAnimating()
    }
    
    private func setupMessageLabel() {
        messageLabel.isHidden = true
        messageLabel.text = "Welcome! 👋 Follow others to fill your feed."
    }
    
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
            DispatchQueue.main.async {
                self.posts.removeAll()
                guard let postUid = post.uid else { return }
                
                self.fetchUser(uid: postUid, completed: {
                    
                    self.posts.append(post)
                    
                    self.updateView()
                    self.refreshControl.endRefreshing()
                    self.activityIndicatorView.stopAnimating()
                })
                Api.Feed.observeFeedRemoved(withId: Api.Userr.CURRENT_USER!.uid) { (post) in
                    self.posts = self.posts.filter { $0.id != post.id }
                    self.users = self.users.filter { $0.id != post.uid }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// Loads blocked feed
    func loadBlockList(completion: @escaping () -> Void) {
        guard let uid = Api.Userr.CURRENT_USER?.uid else {return}
        
        Api.blockUser.observeBlockList(uid: uid, completion: { (id) in
            self.blockList.append(id)
        })
        completion()
    }
    
    func removeBlockFeed() {
        guard let currentUserUID = Api.Userr.CURRENT_USER?.uid else {return}
        
        Api.blockUser.observeBlock(uid: currentUserUID) { (id) in
            self.posts = self.posts.filter{$0.uid != id}
            self.users = self.users.filter{$0.id != id}
            self.tableView.reloadData()
        }
    }
    
//    func addUnblockFeed() {
//        guard let currentUserUID = Api.Userr.CURRENT_USER?.uid else {return}
//
//        Api.USER_BLOCK.observeUnblock(uid: currentUserUID) { (id) in
//            Api.USER_POST.observeUserPostSingleEvent(uid: id, completion: { (postID) in
//                Api.POST.observeSinglePost(postId: postID, completion: { (post) in
//                    self.loadUser(uid: post.uid!, completed: {(user) in
//                        self.users.insert(user, at: 0)
//                        self.posts.insert(post, at: 0)
//                        self.tableView.reloadData()
//                    })
//                })
//            })
//        }
//    }
    
    // Fetches User
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.Userr.observeUser(withId: uid, completion: { user in
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
        
        if post.isSaved == true {
        ref.updateChildValues(values as [AnyHashable : Any]) { (err, ref) in
            if let err = err {
                print("Failed to put save post data in db:", err)
                return
            }
            print("Successfully put save post in db")
           }
        } else {
            ref.child(post.id!).removeValue {_,_ in
                print("Post is unsaved from HomeVC")
            }
        }
 }
    
    func didUnsavePost(post: Post) {
        print("This function is unused")
     }

    // Will segue go to DetailVC is title of post is selected.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPost_Segue" {
            print("Segue to Detail from HOME VC")
            let detailVC = segue.destination as! DetailViewController
            let postID = sender  as! String
            detailVC.postId = postID
        }
        // Go to Profile View Controller
        if segue.identifier == "Home_ProfileSegue" {
            print("Segue to profile from HomeVC")
            let profileVC = segue.destination as! ProfileUserViewController
            let userID = sender  as! String
            profileVC.userId = userID
        }
    }
    
    // MARK: - CollectionView Data Source for Topics
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicImageCollectionViewCell

        cell.imageView.image = imagesArray[indexPath.item]
        cell.topicTitle.text = topicTitles[indexPath.item]
        
        return cell
    }
    
}

// MARK: CollectionView Layout for Topics
extension HomeViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    // Will navigate to selected topic vc 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lifestyle = self.storyboard?.instantiateViewController(withIdentifier: "Lifestyle") as! LifestyleViewController
        let tech = self.storyboard?.instantiateViewController(withIdentifier: "Tech") as! TechViewController
        let travel = self.storyboard?.instantiateViewController(withIdentifier: "Travel") as! TravelViewController
        let food = self.storyboard?.instantiateViewController(withIdentifier: "Food") as! FoodViewController
        let politics = self.storyboard?.instantiateViewController(withIdentifier: "Politics") as! PoliticsViewController
        let media = self.storyboard?.instantiateViewController(withIdentifier: "Media") as! MediaViewController
        let education = self.storyboard?.instantiateViewController(withIdentifier: "Education") as! EducationViewController
        let finance = self.storyboard?.instantiateViewController(withIdentifier: "Finance") as! FinanceViewController
        let health = self.storyboard?.instantiateViewController(withIdentifier: "Health") as! HealthViewController
        let beauty = self.storyboard?.instantiateViewController(withIdentifier: "Beauty") as! BeautyViewController
        
        if indexPath.item == 0 {
          print("Selected Lifestyle")
            lifestyle.navigationItem.title = topicTitles[indexPath.item]
            lifestyle.setBackButton()
            self.navigationController?.pushViewController(lifestyle, animated: true)
        } else if (indexPath.item == 1){
            print ("Selected Tech")
            tech.navigationItem.title = topicTitles[indexPath.item]
            tech.setBackButton()
            self.navigationController?.pushViewController(tech, animated: true)
        } else if (indexPath.item == 2) {
            print ("Selected Travel")
            travel.navigationItem.title = topicTitles[indexPath.item]
            travel.setBackButton()
            self.navigationController?.pushViewController(travel, animated: true)
       } else if (indexPath.item == 3) {
            print ("Selected Food")
            food.navigationItem.title = topicTitles[indexPath.item]
            food.setBackButton()
            self.navigationController?.pushViewController(food, animated: true)
        } else if (indexPath.item == 4) {
            print ("Selected Politics")
            politics.navigationItem.title = topicTitles[indexPath.item]
            politics.setBackButton()
            self.navigationController?.pushViewController(politics, animated: true)
        } else if (indexPath.item == 5) {
            print ("Selected Media")
            media.navigationItem.title = topicTitles[indexPath.item]
            media.setBackButton()
            self.navigationController?.pushViewController(media, animated: true)
        } else if (indexPath.item == 6) {
            print ("Selected Education")
            education.navigationItem.title = topicTitles[indexPath.item]
            education.setBackButton()
            self.navigationController?.pushViewController(education, animated: true)
        } else if (indexPath.item == 7) {
            print ("Selected Finance")
            finance.navigationItem.title = topicTitles[indexPath.item]
            finance.setBackButton()
            self.navigationController?.pushViewController(finance, animated: true)
        } else if (indexPath.item == 8) {
            print ("Selected Health")
            health.navigationItem.title = topicTitles[indexPath.item]
            health.setBackButton()
            self.navigationController?.pushViewController(health, animated: true)
        } else if (indexPath.item == 9) {
            print ("Selected Beauty")
            beauty.navigationItem.title = topicTitles[indexPath.item]
            beauty.setBackButton()
            self.navigationController?.pushViewController(beauty, animated: true)
        } else {
            print("Unrecognized Topic Selected")
        }
    }
}

// MARK: - TableView Data Source and Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        
        let post = posts.reversed()[indexPath.row]
        let user = users.reversed()[indexPath.row]

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
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
