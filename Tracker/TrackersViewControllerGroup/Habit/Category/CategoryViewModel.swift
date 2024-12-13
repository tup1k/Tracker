//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Олег Кор on 11.12.2024.
//
import UIKit

final class CategoryViewModel {
    static let shared = CategoryViewModel()
//    private init() {}
    var didUpdateCategories: (() -> Void)?
    private(set) var actualCategories: [String] = [] {
        didSet {
            didUpdateCategories?()
        }
    }

//    var actualCategories: [TrackerCategoryCoreData] = []
    private var trackerStore = TrackerStore.shared
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    /// Метод загрузки данных из CoreData при первом входе в приложение
    func loadCategoriesFromCoreData() {
        actualCategories = (try? trackerCategoryStore.importCategoryFromCoreData()) ?? []
    }
    
    // Метод добавления новой категории в список actualCategories
    func addCategory(categoryName: String) {
        trackerCategoryStore.saveCategoryToCoreData(categoryName: categoryName)
        actualCategories.append(categoryName)
    }
    
    func deleteCategory(_ category: String) {
        do {
            try trackerCategoryStore.deleteCategoryFromCoreData(category)
//          try loadCategoriesFromCoreData()
            actualCategories.removeAll{$0 == category}
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func editCategory(indexPath: IndexPath) throws {
//        trackerCategoryStore.editCategoryNameToCoreData(indexPath: indexPath, newCategoryName: <#String#>)
       try loadCategoriesFromCoreData()
    }
    
}
