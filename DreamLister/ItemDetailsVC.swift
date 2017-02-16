//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by LionMane Software on 2/15/17.
//  Copyright © 2017 LionMane Software. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    
    var stores = [Store]()
    
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
//        let s1 = Store(context: context)
//        s1.name = "Best Buy"
//        
//        let s2 = Store(context: context)
//        s2.name = "Amazon"
//        
//        let s3 = Store(context: context)
//        s3.name = "Tesla Dealership"
//        
//        let s4 = Store(context: context)
//        s4.name = "Frys Electronics"
//        
//        let s5 = Store(context: context)
//        s5.name = "Target"
//        
//        let s6 = Store(context: context)
//        s6.name = "K mart"
//        
//        ad.saveContext()
        
        getStores()
        
        if itemToEdit != nil{
            loadItemData()
        }
        
        // Do any additional setup after loading the view.
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func getStores(){
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }catch{
            
        }
    }
    
    @IBAction func savePress(_ sender: UIButton) {
        
        var item: Item!
        
        if itemToEdit == nil{
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
        
        if let title = titleField.text{
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData(){
        
        if let item = itemToEdit{
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            
            if let store = item.toStore{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while(index < stores.count)
            }
            
        }
        
    }
    @IBAction func deletePress(_ sender: UIBarButtonItem) {
        if itemToEdit != nil{
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
