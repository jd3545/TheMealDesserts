//
//  MealDetailView.swift
//  Fetch
//
//  Created by Joseph Doros on 7/25/24.
//

import SwiftUI

/// Shows the detials of the meal selected, the loading state and if any error messages
struct MealDetailView: View {
    // States the ID of the meal being shown and properities for the detials of the meal, the loading site and error messages if any occurs
    let mealId: String
    @State private var mealDetail: MealDetail?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        // Allows for scrolling for the details of the meal
        ScrollView {
            // Shows a loading indicator when the meals are being Fetch(ed)
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    ProgressView("Loading meal details...")
                } 
                // Shows an error message when there is an error
                else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } 
                // Shows the details of the meal once gotten successfully
                else if let meal = mealDetail {
                    // Shows image of the meal
                    AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    // Shows the nameof the meal
                    Text(meal.strMeal)
                        .font(.title)
                    
                    // Shows the instructions of the meals
                    Text("Instructions:")
                        .font(.headline)
                    Text(meal.strInstructions)
                    
                    // Shows the ingredients and measurements of the meal
                    Text("Ingredients:")
                        .font(.headline)
                    ForEach(Array(zip(meal.filteredIngredients, meal.filteredMeasurements)), id: \.0) { ingredient, measurement in
                        Text("• \(ingredient): \(measurement)")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Meal Details")
        .task {
            // Gets the meals details from the API
            await fetchMealDetail()
        }
    }
    
    func fetchMealDetail() async {
        // Clear any previous error messages, sets isLoading to true
        isLoading = true
        errorMessage = nil
        
        do {
            // Gets the API request
            guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") else {
                throw URLError(.badURL)
            }
            // Network request to get data
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decodes the json into meal detail response
            let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
            // Updates the meals detail state
            if let detail = mealDetailResponse.meals.first {
                mealDetail = detail
            } else {
                // Throws an error message if no meal details are found
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No meal details found"])
            }
        } catch {
            // Sets an error message if decoding fails or network request
            errorMessage = "Failed to fetch meal details: \(error.localizedDescription)"
        }
        // Once complete it will set isLoading to false
        isLoading = false
    }
}
