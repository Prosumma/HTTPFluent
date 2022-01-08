//
//  Slide.swift
//  HTTPFluent
//
//  Created by Gregory Higley on 2020-04-01.
//  Copyright © 2020 Prosumma.
//  This code is licensed under the MIT license (see LICENSE for details).
//

struct Slide: Codable {
  let title: String
  let type: String
  let items: [String]

  private enum CodingKeys: String, CodingKey {
    case title
    case type
    case items
  }

  init(title: String, type: String, items: [String] = []) {
    self.title = title
    self.type = type
    self.items = items
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    type = try container.decode(String.self, forKey: .type)
    items = (try? container.decode([String].self, forKey: .items)) ?? []
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(title, forKey: .title)
    try container.encode(type, forKey: .type)
    if items.count > 0 {
      try container.encode(items, forKey: .items)
    }
  }
}

struct Slideshow: Decodable {
  let title: String
  let author: String
  let date: String
  let slides: [Slide]
}

struct Slideshows: Decodable {
  let slideshow: Slideshow
}
