//
//  SignOutUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 24/07/2023.
//

import Foundation
import Combine

protocol SignOutUseCase {
    
    func execute() -> AnyPublisher<Void, Error>
}
