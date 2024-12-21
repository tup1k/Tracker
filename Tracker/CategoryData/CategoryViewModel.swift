//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Олег Кор on 11.12.2024.
//

final class CategoryViewModel {
    var didUpdateCategories: (() -> Void)?
    var didSelectedRaw: ((String) -> Void)?
    private(set) var actualCategories: [String] = [] {
        didSet {
            didUpdateCategories?()
        }
    }
    
    private var selectedCategory: String?  {
        didSet {
            guard let selectedCategory else { return }
            didSelectedRaw?(selectedCategory)
        }
    }

    private var trackerStore = TrackerStore.shared
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    /// Метод загрузки данных из CoreData при первом входе в приложение по паттерну MVVM
    func loadCategoriesFromCoreData() {
        actualCategories = (try? trackerCategoryStore.importCategoryFromCoreData()) ?? []
    }
    
    /// Метод добавления новой категории по паттерну MVVM
    func addCategory(categoryName: String) {
        trackerCategoryStore.saveCategoryToCoreData(categoryName: categoryName)
        actualCategories.append(categoryName)
    }
    
    /// Метод корректировки названия категории по паттерну MVVM
    func editCategory(categoryName: String, newCategoryName: String) throws {
        do {
            try trackerCategoryStore.editCategoryNameToCoreData(categoryName: categoryName, newCategoryName: newCategoryName)
            actualCategories = actualCategories.map({$0 == categoryName ? newCategoryName : $0})
        } catch {
            print("ОШИБКА РЕДАКТИРОВАНИЯ ИМЕНИ КАТЕГОРИИ: \(error.localizedDescription)")
            return
        }
    }
    
    /// Метод удаления категории по паттерну MVVM
    func deleteCategory(_ category: String) {
        do {
            try trackerCategoryStore.deleteCategoryFromCoreData(category)
            actualCategories.removeAll{$0 == category}
        } catch {
            print("ОШИБКА УДАЛЕНИЯ КАТЕГОРИИ: \(error.localizedDescription)")
            return
        }
    }
    
    func isSelectedCategory(category: String) -> Bool {
       selectedCategory == category
    }
    
    func didSelectCategory(category: String) {
        selectedCategory = category
    } 
}
