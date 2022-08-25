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
    var models = [Claim]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Lista de Reclamações"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        getAllClaim ()
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "Nova Reclamação",
                                      message: "Título da nova reclamação" ,
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.addAction (UIAlertAction(title: "Enviar", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first , let text = field.text , !text.isEmpty else {
                return
            }
            self?.createClaim(nameClaim: text)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let claim = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Manter Reclamação",
                                      message: nil ,
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Editar", style: .default, handler: {_ in
            let alertEdit = UIAlertController(title: "Editar Reclamação",
                                          message: "Informe os novos dados da reclamação" ,
                                          preferredStyle: .alert)
            alertEdit.addTextField()
            alertEdit.textFields?[0].text = claim.nameClaim
            alertEdit.addTextField()
            alertEdit.textFields?[1].text = claim.descriptionClaim
            alertEdit.addTextField()
            alertEdit.textFields?[2].text = claim.location
            
            
            alertEdit.addAction (UIAlertAction(title: "Salvar", style: .default, handler: { [weak self] _ in
                guard let nameClaim = alertEdit.textFields?[0] ,
                      let descriptionClaim = alertEdit.textFields?[1] ,
                      let location = alertEdit.textFields?[2]
                else {
                    return
                }
                
                self?.updateClaim(item: claim, newName: (nameClaim.text)!,
                                  newLocation: (location.text)!,
                                  newDescriptionClaim: descriptionClaim.text!)
            }))
            
            self.present(alertEdit, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Deletar", style: .destructive, handler: {_ in
            self.deleteClaim(item: claim)
        }))
        
        present(sheet, animated: true)
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
        print("ViewControllerError -> getAllClaim" )
        do {
            models = try context.fetch(Claim.fetchRequest())
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
        print("ViewControllerError -> createClaim" )
        do{
            try context.save()
            getAllClaim()
        }
        catch{
            print("ViewControllerError -> Falha na criação" )
        }
    }

    func deleteClaim (item : Claim){
        context.delete(item)
        
        do{
            try context.save()
            getAllClaim()
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
            getAllClaim()
        }
        catch{
            print("ViewControllerError -> Falha na atualização" )
        }
        
    }
}

