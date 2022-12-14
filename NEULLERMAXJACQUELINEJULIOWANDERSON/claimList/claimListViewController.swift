//
//  ViewController.swift
//  NEULLERMAXJACQUELINEJULIOWANDERSON
//
//  Created by Neuler Pereira on 23/08/22.
//

import UIKit

class claimListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var tableViewClaimList: UITableView!
    
    var models = [Claim]()
    var model  = Claim()
    var estilo = "Manter"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Lista de Reclamações"

        //self.tableViewClaimList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewClaimList.delegate = self
        tableViewClaimList.dataSource = self
        tableViewClaimList.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getAllClaim ()
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "Nova Reclamação",
                                      message: "Título da nova reclamação" ,
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.addAction (UIAlertAction(title: "Inserir", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first , let text = field.text , !text.isEmpty else {
                return
            }
            self?.estilo = "Manter"
            self?.model = self?.createClaim(nameClaim: text) ?? Claim()
            self?.performSegue(withIdentifier: "showDetailingSegue", sender: self)
        }))
        
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let claim = models[indexPath.row]
        
        let sheet = UIAlertController(title: nil,
                                      message: nil ,
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Consultar", style: .default, handler: {_ in
            self.estilo = "Consultar"
            self.model = self.models[indexPath.row]
            self.performSegue(withIdentifier: "showDetailingSegue", sender: self)}))
        sheet.addAction(UIAlertAction(title: "Editar", style: .default, handler: {_ in
            self.estilo = "Manter"
            self.model = self.models[indexPath.row]
            self.performSegue(withIdentifier: "showDetailingSegue", sender: self)}))
        sheet.addAction(UIAlertAction(title: "Deletar", style: .destructive, handler: {_ in
            self.deleteClaim(item: claim)
        }))
        
        present(sheet, animated: false)
            /*
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
        }))*/

    }
    
    // Passagem de parametros
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailingSegue" {
            let controller = segue.destination as! claimFormViewController
            controller.model = model
            print (estilo)
            controller.estilo = estilo
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        model = models[indexPath.row] as Claim
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "claimTableViewCell", for: indexPath) as? claimTableViewCell else {
            return claimTableViewCell()
        }

        //cell.configure(with: model)
        cell.claimNameCell?.text = model.nameClaim
        cell.claimDateCell?.text = model.insertDate

        return cell
        
    }
    
    // Core Data Functions
    
    func getAllClaim () {
        print("ViewController -> getAllClaim" )
        do {
            models = try context.fetch(Claim.fetchRequest())
            DispatchQueue.main.async {
                self.tableViewClaimList.reloadData()
            }
        }
        catch{
              print("ViewControllerError -> Falha na recuperação das reclamações" )
        }
    }
    
    func createClaim (nameClaim: String) -> Claim {
        let newClaim = Claim(context: context)
        newClaim.nameClaim = nameClaim
        newClaim.insertDate = Date().formatted()
        print("ViewController -> createClaim" )
        do{
            try context.save()
            // getAllClaim()
        }
        catch{
            print("ViewControllerError -> Falha na criação" )
        }
        return newClaim
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
    /*
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
   */
}

