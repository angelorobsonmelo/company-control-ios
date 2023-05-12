//
//  AuthUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation

protocol AuthUseCase {
   
    func auth(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)

}
