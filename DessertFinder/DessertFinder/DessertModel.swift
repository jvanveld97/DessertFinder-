//
//  DessertModel.swift
//  DessertFinder
//
//  
//

import Foundation

struct Meal: Identifiable, Decodable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

struct MealDetail: Decodable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let ingredients: [String]
    let measurements: [String]
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        
        ingredients = (1...20).compactMap { index in
            return try? container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: "strIngredient\(index)")!)
        }.filter { !$0.isEmpty }
        
        measurements = (1...20).compactMap { index in
            return try? container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: "strMeasure\(index)")!)
        }.filter { !$0.isEmpty }
    }
}
