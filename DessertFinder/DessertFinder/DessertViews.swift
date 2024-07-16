//
//  DessertViews.swift
//  DessertFinder
//
import SwiftUI

// `MealListView` displays a list of meal items and allows navigation to a detail view.
struct MealListView: View {
    // Create a `StateObject` for `MealViewModel` to manage data and business logic.
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            // A `List` view to display a scrollable list of meals.
            List(viewModel.meals) { meal in
                // `NavigationLink` allows navigation to the `MealDetailView` when a meal is selected.
                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                    HStack {
                        // `AsyncImage` loads the meal’s image from the URL asynchronously.
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image.resizable()  // Make sure the image scales to fit the view.
                        } placeholder: {
                            // Show a progress indicator while the image loads.
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)  // Set the size of the image.
                        .clipShape(Circle())  // Clip the image into a circular shape.
                        
                        // Display the meal’s name.
                        Text(meal.strMeal)
                            .font(.headline)  // Set the font size and weight for the meal name.
                    }
                }
            }
            .navigationTitle("Desserts")  // Set the title of the navigation bar.
            .task {
                // Fetch the list of desserts asynchronously when the view appears.
                await viewModel.fetchMeals()
            }
        }
    }
}

// Preview provider for `MealListView`, used to generate previews in Xcode’s canvas.
struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}

// `MealDetailView` displays detailed information about a selected meal.
struct MealDetailView: View {
    // The ID of the meal to fetch details for.
    let mealID: String
    // Create a `StateObject` for `MealViewModel` to manage data and business logic.
    @StateObject private var viewModel = MealViewModel()
    
    var body: some View {
        ScrollView {
            // Display meal details if available.
            if let meal = viewModel.mealDetail {
                VStack(alignment: .leading, spacing: 16) {
                    // Display the meal’s name.
                    Text(meal.strMeal)
                        .font(.largeTitle)  // Set the font size for the meal name.
                        .fontWeight(.bold)  // Make the meal name bold.
                    
                    // Title for the instructions section.
                    Text("Instructions")
                        .font(.title2)  // Set the font size for the instructions title.
                        .padding(.top, 8)  // Add space above the instructions title.
                    
                    // Display the instructions for preparing the meal.
                    Text(meal.strInstructions)
                        .padding(.bottom, 16)  // Add space below the instructions.
                    
                    // Title for the ingredients section.
                    Text("Ingredients")
                        .font(.title2)  // Set the font size for the ingredients title.
                        .padding(.top, 8)  // Add space above the ingredients title.
                    
                    // Display ingredients and their measurements.
                    ForEach(Array(zip(meal.ingredients, meal.measurements)), id: \.0) { ingredient, measurement in
                        // Display each ingredient with its corresponding measurement.
                        Text("\(ingredient): \(measurement)")
                    }
                }
                .padding()  // Add padding around the entire `VStack`.
            } else {
                // Show a progress indicator while the meal details are loading.
                ProgressView()
            }
        }
        .navigationTitle("Meal Detail")  // Set the title of the navigation bar.
        .task {
            // Fetch the meal details asynchronously when the view appears.
            await viewModel.fetchMealDetail(by: mealID)
        }
    }
}

// Preview provider for `MealDetailView`, used to generate previews in Xcode’s canvas.
struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(mealID: "52772")  // Example meal ID for preview.
    }
}
