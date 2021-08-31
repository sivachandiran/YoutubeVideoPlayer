

import Foundation
struct VideoList_Base : Codable {
	let tracklist : Tracklist?

	enum CodingKeys: String, CodingKey {

		case tracklist = "tracklist"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tracklist = try values.decodeIfPresent(Tracklist.self, forKey: .tracklist)
	}

}
