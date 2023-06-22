//
//  DeleteCompanyUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation

protocol DeleteCompanyUseCase {
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)

}

