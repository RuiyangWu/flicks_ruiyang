//
//  ActiveMoviesController
//  flick
//
//  Created by ruiyang_wu on 8/1/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class ActiveMoviesController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var modeControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl?
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    
    var endpoint: String = ""
    static var modeSelection: Int = 0
    
    func networkCall() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if self.modeControl.selectedSegmentIndex == 0 {
                    self.tableView.hidden = false
                }
                else {
                    self.collectionView.hidden = false
                }
                self.errorView.hidden = true
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
            else {
                self.collectionView.hidden = true
                self.tableView.hidden = true
                self.errorView.hidden = false
                self.errorView.frame.origin.y = 0
                //self.errorView.frame = CGRect(x: 0, y: 0, width: self.errorView.frame.size.width, height: self.errorView.frame.size.height)

            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        task.resume()
        
        print("AAA: ", ActiveMoviesController.modeSelection)
        print("setting from: ", self.modeControl.selectedSegmentIndex)
        self.modeControl.selectedSegmentIndex = ActiveMoviesController.modeSelection
        print("setting to: ", self.modeControl.selectedSegmentIndex)
        modeChanged(self)
    }
    
    override func viewDidLoad() {
        print("viewdidload called")
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ActiveMoviesController.onRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)
        collectionView.insertSubview(refreshControl!, atIndex: 0)
        
        networkCall()
        
        self.navigationItem.title = "Movies"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "codepath-logo"), forBarMetrics: .Default)
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            shadow.shadowOffset = CGSizeMake(2, 2);
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(22),
                NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }

        // Do any additional setup after loading the view.
    }
    
    func onRefresh(sender:AnyObject) {
        networkCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modeChanged(sender: AnyObject) {
        if modeControl.selectedSegmentIndex == 0 {
            tableView.hidden = false
            collectionView.hidden = true
        }
        else {
            tableView.hidden = true
            collectionView.hidden = false
        }
        ActiveMoviesController.modeSelection = modeControl.selectedSegmentIndex
        print("modeSelection updated to: ", ActiveMoviesController.modeSelection)
    }
    
    /* Table View Protocols */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        // Customize the selection effect
        cell.selectionStyle = .None
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.redColor()
        cell.selectedBackgroundView = backgroundView
        
        // Getting info and pass to details view
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            //let imageUrl = NSURL(string: baseUrl + posterPath)
            //cell.posterView.setImageWithURL(imageUrl!)
            let imageUrl = baseUrl + posterPath
            let imageRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
            cell.posterView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(1.0, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        
        return cell
    }
    
    /* Collection View Protocols */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("moviecell", forIndexPath: indexPath) as! MovieCollectionCell
        
        let movie = filteredMovies![indexPath.row]
        print("index: ", indexPath.row)
        print("movie: ", movie)
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            //let imageUrl = NSURL(string: baseUrl + posterPath)
            //cell.posterImageView.setImageWithURL(imageUrl!)
            let imageUrl = baseUrl + posterPath
            let imageRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
            cell.posterImageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        cell.posterImageView.alpha = 0.0
                        cell.posterImageView.image = image
                        UIView.animateWithDuration(1.0, animations: { () -> Void in
                            cell.posterImageView.alpha = 1.0
                        })
                    } else {
                        cell.posterImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        return cell
    }
    
    /* Search Bar Protocols */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            let overview = movie["overview"] as! String
            let title = movie["title"] as! String
            let allText = overview + " " + title
            return allText.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
        collectionView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if modeControl.selectedSegmentIndex == 0 {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let movie = filteredMovies![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.movie = movie
        }
        else {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let movie = filteredMovies![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.movie = movie
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
