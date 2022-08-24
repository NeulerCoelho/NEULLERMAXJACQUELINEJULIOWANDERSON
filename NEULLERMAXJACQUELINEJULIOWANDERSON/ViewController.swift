//
//  ViewController.swift
//  NEULLERMAXJACQUELINEJULIOWANDERSON
//
//  Created by Neuler Pereira on 23/08/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableView: UITableView = {
        let table = UITableView ()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    let models = [Claim]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Lista de Reclamações"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.nameClaim // Nome da Reclamacao
        return cell
    }
    
    // Core Data Functions
    
    func getAllClaim () {
        do {
            let models = try context.fetch(Claim.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
              print("ViewControllerError -> Falha na recuperação das reclamações" )
        }
        
    }
    
    func createClaim (nameClaim: String) {
        let newClaim = Claim(context: context)
        newClaim.nameClaim = nameClaim
        newClaim.insertDate = Date().formatted()
        
        do{
            try context.save()
        }
        catch{
            print("ViewControllerError -> Falha na criação" )
        }
    }

    func deleteClaim (item : Claim){
        context.delete(item)
        
        do{
            try context.save()
        }
        catch{
            print("ViewControllerError -> Falha na deleção" )
        }
    }
    func updateClaim (item : Claim, newName: String , newLocation: String , newDescriptionClaim: String ){
        item.nameClaim        = newName
        item.location         = newLocation
        item.descriptionClaim = newDescriptionClaim
        
        do{
            try context.save()
        }
        catch{
            print("ViewControllerError -> Falha na atualização" )
        }
        
    }
}

