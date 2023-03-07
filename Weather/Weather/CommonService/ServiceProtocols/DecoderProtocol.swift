//
//  DecoderProtocol.swift
//  Weather
//
//  Created by Akshay Bhandary on 3/4/23.
//

import Foundation

protocol DecoderProtocol {
    func decode<T: Decodable>(type: T.Type, from data: Data?) -> T?
}
