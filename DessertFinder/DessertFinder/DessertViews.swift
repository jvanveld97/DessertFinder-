//
//  DessertViews.swift
//  DessertFinder
//
import SwiftUI

struct MealListView: View {
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                    HStack {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        Text(meal.strMeal)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Desserts")
            .task {
                await viewModel.fetchMeals()
            }
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}

struct MealDetailView: View {
    let mealID: String
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        ScrollView {
            if let meal = viewModel.mealDetail {
                VStack(alignment: .leading, spacing: 16) {
                    Text(meal.strMeal)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Instructions")
                        .font(.title2)
                        .padding(.top, 8)
                    
                    Text(meal.strInstructions)
                        .padding(.bottom, 16)
                    
                    Text("Ingredients")
                        .font(.title2)
                        .padding(.top, 8)
                    
                    // Display ingredients and measurements
                    ForEach(Array(zip(meal.ingredients, meal.measurements)), id: \.0) { ingredient, measurement in
                        Text("\(ingredient): \(measurement)")
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Meal Detail")
        .task {
            await viewModel.fetchMealDetail(by: mealID)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(mealID: "52772")
    }
}

