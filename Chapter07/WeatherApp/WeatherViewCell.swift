//
//  WeatherViewCell.swift
//  WeatherApp
//
//  Created by Emil Atanasov on 9/17/17.
//  Copyright © 2017 Appose Studio Inc. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var temperature: UILabel!
}
