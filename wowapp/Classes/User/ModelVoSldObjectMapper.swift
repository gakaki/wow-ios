import ObjectMapper
import SwiftyJSON
struct VoSldOM:Mappable {

    
    var id: String?
    var name: String?
    var parent_id: String?
    var level_type: String?
    
    var subCities: [VoSldOM]?
    var subDistricts: [VoSldOM]?
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        parent_id       <- map["parent_id"]
        level_type      <- map["level_type"]
    }
    
}

struct CityDataManager {
    static let data = VoSldDataOM()
    private init() {}
}

struct VoSldDataOM {
    
    var slds: [VoSldOM]           = []
    var provinces:[VoSldOM]       = [] //省
    var cities:[VoSldOM]          = [] //市
    var districts:[VoSldOM]       = [] //区
    var is_load:Bool = false
    
    mutating func loadJsonObjectMapper() throws {
        if let path = NSBundle.mainBundle().pathForResource("city", ofType: "json") {
            
            do {
                let json_str            = try! String(contentsOfURL: NSURL(fileURLWithPath: path), encoding: NSUTF8StringEncoding)
                if let dataFromString   = json_str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json            = JSON(data: dataFromString)
                    let a               = json["RECORDS"].arrayObject
                    slds                = try! Mapper<VoSldOM>().mapArray(a)!
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }catch {
                print("error")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    mutating func reload(){
    
        let stopwatch = Stopwatch()
        do{
            try loadJsonObjectMapper()
            self.filter(self.slds)

        }catch {
        
        }
    
        print("city data elapsed time: \(stopwatch.elapsedTimeString())")

    }
    init(){
        
        reload()
        is_load = true
    }
    mutating func filter ( slds:[VoSldOM] ){
        self.slds       = slds
        self.provinces  = slds.filter{ (sld) in sld.level_type == "1" }
        self.cities     = slds.filter{ (sld) in sld.level_type == "2" }
        self.districts  = slds.filter{ (sld) in sld.level_type == "3" }
        for (index, item) in provinces.enumerate() {
            provinces[index].subCities = cities.filter{ (sld) in sld.parent_id == item.id }
            
            for (index_city, item_city) in provinces[index].subCities!.enumerate() {
                
                provinces[index].subCities![index_city].subDistricts = districts.filter{ (sld) in sld.parent_id == item_city.id }
            }
        }
 
    }

    
}
