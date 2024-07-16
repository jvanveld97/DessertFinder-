//
//  DessertViewModel.swift
//  DessertFinder
//
import Foundation
import SwiftUI

@MainActor
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var mealDetail: MealDetail?
    
    func fetchMeals() async {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode([String: [Meal]].self, from: data)
            if let meals = response["meals"] {
                self.meals = meals.sorted { $0.strMeal < $1.strMeal }
            }
        } catch {
            print("Error fetching meals: \(error)")
        }
    }
    
    func fetchMealDetail(by id: String) async {
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode([String: [MealDetail]].self, from: data)
            if let mealDetail = response["meals"]?.first {
                self.mealDetail = mealDetail
            }
        } catch {
            print("Error fetching meal detail: \(error)")
        }
    }
}
