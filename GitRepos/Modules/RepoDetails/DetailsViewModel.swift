//
//  DetailsViewModel.swift
//  GitRepos
//
//  Created by Max on 15/04/22.
//

import Foundation

final class DetailsViewModel {
    
    internal var entities: DetailEntities
    private weak var view: DetailViewInputs!
    
    init(entities: DetailEntities,
         view: DetailViewInputs) {
        self.view = view
        self.entities = entities
    }
}
