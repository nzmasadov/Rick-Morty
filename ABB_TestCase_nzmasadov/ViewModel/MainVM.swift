import Foundation
import Alamofire

class MainVM {
    
    func fetchFilteredCharacters(name: String? = nil, page: Int? = nil, status: String? = nil, species: String? = nil, gender: String? = nil, completionHandler: @escaping (CharacterData) -> Void) {
        
        var params = Parameters()
        
        params["name"] = name
        params["page"] = page
        params["status"] = status
        params["species"] = species
        params["gender"] = gender
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/")!
                
        AF.request(url, method: .get, parameters: params).responseDecodable(of: CharacterData.self) { response in
            
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
