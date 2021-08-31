
import Foundation
struct Tracklist : Codable {
	let title : String?
	let author : String?
	let totalvideos : String?
	let track : [TrackDetail]?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case author = "author"
		case totalvideos = "totalvideos"
		case track = "track"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		totalvideos = try values.decodeIfPresent(String.self, forKey: .totalvideos)
		track = try values.decodeIfPresent([TrackDetail].self, forKey: .track)
	}

}
