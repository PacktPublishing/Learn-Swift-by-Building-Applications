//
//  FavoriteViewCell.swift
//  WeatherApp
//
//  Created by Emil Atanasov on 9/25/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
}

class StaticViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
}

