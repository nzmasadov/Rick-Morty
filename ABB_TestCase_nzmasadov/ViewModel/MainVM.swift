//
//  MainVM.swift
//  ABB_TestCase_nzmasadov
//
//  Created by Test Test on 28.10.22.
//

import Foundation
import Alamofire

class MainVM {
    
    func fetchCharacters(page: Int, completionHandler: @escaping (CharacterData) -> Void) {
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)")
        AF.request(url!, method: .get).responseDecodable(of: CharacterData.self) { response in
            
            if response.error != nil {
                return
            }
            guard let characters = response.value else {return}
            completionHandler(characters)
        }
    }
    
    func searchCharacters(name: String, completionHandler: @escaping (CharacterData) -> Void) {
        let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(name)")
        AF.request(url!, method: .get).responseDecodable(of: CharacterData.self) { response in
            
            if response.error != nil {
                return
            }
            guard let characters = response.value else {return}
            completionHandler(characters)
        }
    }
    
    func savePhoneMode(id: String, isDark: Bool) {
        UserDefaults.standard.set(isDark, forKey: id)
    }
    
    func getPhoneMode(id: String) -> Bool {
        UserDefaults.standard.bool(forKey: id)
    }
}
