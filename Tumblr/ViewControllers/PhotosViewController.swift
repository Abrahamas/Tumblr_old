//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Mac on 6/23/1397 AP.
//  Copyright © 1397 Abraham Asmile. All rights reserved.
//

import UIKit
 import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
  
    

    @IBOutlet weak var tvPhoto: UITableView!
    var posts: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvPhoto.delegate = self
        tvPhoto.dataSource = self
        tvPhoto.rowHeight = 150
        tvPhoto.estimatedRowHeight = 200
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // TODO: Reload the table view
                 self.tvPhoto.reloadData()
            }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.row]
        if let photos = post["photos"] as? [[String: Any]]{
            // photos is NOT nil, we can use it!
            // todo: get the photo url
            
            // Get the first photo in the photos array
            let photo = photos[0]
            // Get the original size dictionary from the photo
            let originalSize =  photo["original_size"] as! [String: Any]
            // Get the url string from the original size dictionary
            let urlString = originalSize["url"] as! String
            // Create a URL using the urlString
            let url = URL(string: urlString)
            
            // call the AlamofireImage method
            cell.photoImageView.af_setImage(withURL: url!)
        }
        
        // Configure PhotoCell using the outlets that you've defined.
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
