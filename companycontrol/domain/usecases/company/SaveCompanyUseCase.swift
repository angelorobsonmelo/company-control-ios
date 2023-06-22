//
//  SaveCompanyUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation

protocol SaveCompanyUseCase {
    func save(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void)

}
