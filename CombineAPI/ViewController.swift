//
//  ViewController.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let _ = try await viewModel.getExampleAsync()
        }
    }


}

