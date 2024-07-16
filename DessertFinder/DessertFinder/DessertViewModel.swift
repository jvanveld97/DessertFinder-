//
//  DessertViewModel.swift
//  DessertFinder
//
import Foundation
import SwiftUI

// `MealViewModel` is a class responsible for managing the data related to meals and meal details.
@MainActor
class MealViewModel: ObservableObject {
    // `@Published` properties automatically notify SwiftUI views of changes.
    @Published var meals: [Meal] = []  // An array of `Meal` objects representing the list of desserts.
    @Published var mealDetail: MealDetail?  // An optional `MealDetail` object for storing details of a selected meal.
    
    // `fetchMeals` is an asynchronous function that fetches the list of desserts from the API.
    func fetchMeals() async {
        // Define the URL string for fetching the list of dessert meals from the API.
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        // Convert the URL string to a `URL` object. If this fails, return early from the function.
        guard let url = URL(string: urlString) else { return }
        
        do {
            // Fetch the data from the URL asynchronously. `data(from:)` suspends the function until the data is received.
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode the JSON data into a Swift dictionary with a String key and an array of `Meal` objects as the value.
            let response = try JSONDecoder().decode([String: [Meal]].self, from: data)
            // Extract the array of `Meal` objects from the dictionary under the key "meals".
            if let meals = response["meals"] {
                // Sort the meals alphabetically by their names and update the `meals` property.
                self.meals = meals.sorted { $0.strMeal < $1.strMeal }
            }
        } catch {
            // Print an error message if there was a problem fetching or decoding the data.
            print("Error fetching meals: \(error)")
        }
    }
    
    // `fetchMealDetail` is an asynchronous function that fetches detailed information for a specific meal by its ID.
    func fetchMealDetail(by id: String) async {
        // Define the URL string for fetching the details of a specific meal using its ID.
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        // Convert the URL string to a `URL` object. If this fails, return early from the function.
        guard let url = URL(string: urlString) else { return }
        
        do {
            // Fetch the data from the URL asynchronously. `data(from:)` suspends the function until the data is received.
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode the JSON data into a Swift dictionary with a String key and an array of `MealDetail` objects as the value.
            let response = try JSONDecoder().decode([String: [MealDetail]].self, from: data)
            // Extract the first `MealDetail` object from the array under the key "meals".
            if let mealDetail = response["meals"]?.first {
                // Update the `mealDetail` property with the details of the selected meal.
                self.mealDetail = mealDetail
            }
        } catch {
            // Print an error message if there was a problem fetching or decoding the data.
            print("Error fetching meal detail: \(error)")
        }
    }
}
