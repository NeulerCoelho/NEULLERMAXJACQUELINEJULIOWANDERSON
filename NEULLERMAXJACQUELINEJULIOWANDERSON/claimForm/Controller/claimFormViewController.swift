//
//  claimFormViewController.swift
//  NEULLERMAXJACQUELINEJULIOWANDERSON
//
//  Created by Neuler Pereira on 25/08/22.
//

import UIKit

class claimFormViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var descriptionClaim: UITextView!
    @IBOutlet weak var location: UITextView!
    @IBOutlet weak var insertDate: UILabel!
    
    
    public var model  = Claim()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = model.nameClaim
        descriptionClaim.text = model.descriptionClaim
        location.text = model.location
        insertDate.text = model.insertDate
        // Criando borda
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        descriptionClaim.layer.borderColor = color
        descriptionClaim.layer.borderWidth = 0.5
        descriptionClaim.layer.cornerRadius = 5

        location.layer.borderColor = color
        location.layer.borderWidth = 0.5
        location.layer.cornerRadius = 5
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
