//
//  mainVC.swift
//  DreamLister
//
//  Created by LionMane Software on 2/15/17.
//  Copyright © 2017 LionMane Software. All rights reserved.
//

import UIKit
import CoreData

class mainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
       // generateTestData()
        attemptFetch()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell",for: indexPath)as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        //update cell
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects , objs.count > 0{
            
            let item = objs[indexPath.row]
            
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch(){
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do{
            try controller.performFetch()
        }catch {
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type){
        case.insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = newIndexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    func generateTestData(){
        
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "Some random test sklfsaddl;j sakjdfasldf j;lasdf akjshfasjh fsjhd fsadfas jdkaskhdf asdhjksakjf hsad"
        let item2 = Item(context: context)
        item2.title = "Wireless headphones"
        item2.price = 300
        item2.details = "Some random test sklfsaddl;j sakjdfasldf j;lasdf akjshfasjh fsjhd fsadfas jdkaskhdf asdhjksakjf hsad"
        let item3 = Item(context: context)
        item3.title = "Testa Model S"
        item3.price = 80000
        item3.details = "Some random test sklfsaddl;j sakjdfasldf j;lasdf akjshfasjh fsjhd fsadfas jdkaskhdf asdhjksakjf hsad"
        
        ad.saveContext()
    }
}

