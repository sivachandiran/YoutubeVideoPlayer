
import Foundation
struct TrackDetail : Codable {
	let videoid : String?
	let key : String?
	let videoname : String?
	let description : String?
	let contentclassification : String?
	let category : String?
	let showname : String?
	let showid : Int?
	let keywords : String?
	let privatetagname : String?
	let content_owner_type : String?
	let content_provider_url : String?
	let content_url : String?
	let publishdate : String?
	let thumbpath : String?
	let posterpath : String?
	let videoviews : Int?
	let videoduration : Int?
	let embed : String?
	let jscode : String?

	enum CodingKeys: String, CodingKey {

		case videoid = "videoid"
		case key = "key"
		case videoname = "videoname"
		case description = "description"
		case contentclassification = "contentclassification"
		case category = "category"
		case showname = "showname"
		case showid = "showid"
		case keywords = "keywords"
		case privatetagname = "privatetagname"
		case content_owner_type = "content_owner_type"
		case content_provider_url = "content_provider_url"
		case content_url = "content_url"
		case publishdate = "publishdate"
		case thumbpath = "thumbpath"
		case posterpath = "posterpath"
		case videoviews = "videoviews"
		case videoduration = "videoduration"
		case embed = "embed"
		case jscode = "jscode"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		videoid = try values.decodeIfPresent(String.self, forKey: .videoid)
		key = try values.decodeIfPresent(String.self, forKey: .key)
		videoname = try values.decodeIfPresent(String.self, forKey: .videoname)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		contentclassification = try values.decodeIfPresent(String.self, forKey: .contentclassification)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		showname = try values.decodeIfPresent(String.self, forKey: .showname)
		showid = try values.decodeIfPresent(Int.self, forKey: .showid)
		keywords = try values.decodeIfPresent(String.self, forKey: .keywords)
		privatetagname = try values.decodeIfPresent(String.self, forKey: .privatetagname)
		content_owner_type = try values.decodeIfPresent(String.self, forKey: .content_owner_type)
		content_provider_url = try values.decodeIfPresent(String.self, forKey: .content_provider_url)
		content_url = try values.decodeIfPresent(String.self, forKey: .content_url)
		publishdate = try values.decodeIfPresent(String.self, forKey: .publishdate)
		thumbpath = try values.decodeIfPresent(String.self, forKey: .thumbpath)
		posterpath = try values.decodeIfPresent(String.self, forKey: .posterpath)
		videoviews = try values.decodeIfPresent(Int.self, forKey: .videoviews)
		videoduration = try values.decodeIfPresent(Int.self, forKey: .videoduration)
		embed = try values.decodeIfPresent(String.self, forKey: .embed)
		jscode = try values.decodeIfPresent(String.self, forKey: .jscode)
	}

}
