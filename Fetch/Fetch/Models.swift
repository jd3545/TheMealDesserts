//
//  Models.swift
//  Fetch
//
//  Created by Joseph Doros on 7/25/24.
//

import Foundation

/// Structure of the meal, from JSON
struct Meal: Identifiable, Codable {
    // Name of meal
    let strMeal: String
    // URL of  meals thumbnail
    let strMealThumb: String
    // ID of meal
    let idMeal: String
    
    var id: String { idMeal }
}
/// Structure of response from API, that has the list of meals
struct MealResponse: Codable {
    // Array if meal
    let meals: [Meal]
}

/// Structure of  information about the meal
struct MealDetail: Codable {
    // Id of meal
    let idMeal: String
    // Name of meal
    let strMeal: String
    // Cooking instructions
    let strInstructions: String
    // URL of thumbnail of meal
    let strMealThumb: String
    // An array of ingredients names
    let ingredients: [String]
    // An array of ingredient measurements
    let measurements: [String]
    
    // This filters out empty ingredient names
    var filteredIngredients: [String] {
        ingredients.filter { !$0.isEmpty }
    }
    
    // This filters out empty ingredient measurements
    var filteredMeasurements: [String] {
        measurements.filter { !$0.isEmpty }
    }
    
    // Helps match json keys to structure properties
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    /// Filters out empty values, and sets up meal detail instance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        
        var ingredients: [String] = []
        var measurements: [String] = []
        
        for i in 1...20 {
            let ingredientKey = CodingKeys(rawValue: "strIngredient\(i)")!
            let measurementKey = CodingKeys(rawValue: "strMeasure\(i)")!
            
            if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey) {
                ingredients.append(ingredient)
            } else {
                ingredients.append("")
            }
            
            if let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey) {
                measurements.append(measurement)
            } else {
                measurements.append("")
            }
        }
        self.ingredients = ingredients
        self.measurements = measurements
    }
    
    /// Encodes details of the meals instance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idMeal, forKey: .idMeal)
        try container.encode(strMeal, forKey: .strMeal)
        try container.encode(strInstructions, forKey: .strInstructions)
        try container.encode(strMealThumb, forKey: .strMealThumb)
        
        for (index, ingredient) in ingredients.enumerated() {
            if index < 20 {
                let ingredientKey = CodingKeys(rawValue: "strIngredient\(index + 1)")!
                try container.encode(ingredient, forKey: ingredientKey)
            }
        }
        
        for (index, measurement) in measurements.enumerated() {
            if index < 20 {
                let measurementKey = CodingKeys(rawValue: "strMeasure\(index + 1)")!
                try container.encode(measurement, forKey: measurementKey)
            }
        }
    }
}

/// Structure of a respone from API that has the details of the meals
struct MealDetailResponse: Codable {
    // Array of meal details
    let meals: [MealDetail]
}
