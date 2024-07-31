//
//  ContentView.swift
//  Fetch
//
//  Created by Joseph Doros on 7/25/24.
//

import SwiftUI

import SwiftUI
/// This is the main view of the application, it displays the list of dessert meals sorted alphabetically it is feteched(haha Fetch)  from the API given
struct ContentView: View {
    // States the properities for the list of meals, the loading site and error messages if any occurs
    @State private var meals: [Meal] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                // Shows a loading indicator when the meals are being Fetch(ed)
                if isLoading {
                    ProgressView("Loading meals...")
                } 
                // Shows an error message when there is an error
                else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(meals.sorted(by: { $0.strMeal < $1.strMeal })) { meal in
                        NavigationLink(destination: MealDetailView(mealId: meal.idMeal)) {
                            HStack {
                                // Shows the image of the meal
                                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                                // Shows the meals name
                                Text(meal.strMeal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dessert Meals")
            .task {
                // Gets the meals when the view appears
                await fetchMeals()
            }
        }
    }
    
    /// Gets the dessert meals in a list from the API
    func fetchMeals() async {
        // Clear any previous error messages, sets isLoading to true
        isLoading = true
        errorMessage = nil
        
        do {
            // Gets the API request
            guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
                throw URLError(.badURL)
            }
            // Network request to get data
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decodes the json into meal response
            let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
            // Updates the meals state
            meals = mealResponse.meals
        } catch {
            // Throws an error message if decoding fails or network request
            errorMessage = "Failed to fetch meals: \(error.localizedDescription)"
        }
        // Once complete it will set isLoading to false
        isLoading = false
    }
}
