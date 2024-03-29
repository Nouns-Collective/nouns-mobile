// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

@testable import Services

extension Trait {
  
  static var bodyFixture: Self {
    Trait(rleData: "0x0015171f090e020e020e020e02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02020201000b02",
          assetImage: "body-bege-bsod",
          textures: [:]
    )
  }
  
  static var headFixture: Self {
    Trait(rleData: "0x00021e140605000137020001370f0004000237020002370e0003000337020003370d0002000437020004370c0003000337020003370d0004000237020002370e0005000137020001370f000d370b000d370b000d370b000d370b000d370b000d370b000d370600057d0d370600017d017e017d017e017d0b37097d017e017d017e017d0b370d7d0a370523097d0b370d7d",
          assetImage: "head-aardvark",
          textures: ["mouth": ["mouth-default-1", "mouth-default-2"]]
    )
  }
  
  static var glassesFixture: Self {
    Trait(rleData: "0x000b1710070300062001000620030001200201022301200100012002010223012004200201022303200201022301200420020102230320020102230120012002000120020102230120010001200201022301200300062001000620",
          assetImage: "glasses-hip-rose",
          textures: [:]
    )
  }
  
  static var accessoryFixture: Self {
    Trait(rleData: "0x0017141e0d0100011f0500021f05000100011f0300011f01000100011f0200011f02000300011f03000200011f0200021f0100011f0200011f0100011f0400011f0100011f",
          assetImage: "accessory-1n",
          textures: [:]
    )
  }
}
