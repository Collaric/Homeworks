import Foundation

enum TaskCategory: String {
    case work = "Работа"
    case study = "Учеба"
    case personal = "Личное"
}

struct Task: Identifiable {
    let id: UUID = UUID()
    let title: String
    var isCompleted: Bool = false
    let category: TaskCategory
}

class TaskManager {
    private var tasks: [Task] = []
    
    var allTasks: [Task] {
        tasks
    }
    
    func addTask(title: String, category: TaskCategory, showMessage: Bool = true) {
        let task = Task(title: title, category: category)
        tasks.append(task)
        if showMessage {
            print("Задача успешно добавлена.")
        }
    }
    
    func removeTask(by id: UUID) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks.remove(at: index)
            print("Задача успешно удалена.")
        } else {
            print("Задача не найдена.")
        }
    }
    
    func toggleTaskCompletion(by id: UUID, showMessage: Bool = true) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks[index].isCompleted.toggle()
            if showMessage {
                print("Статус задачи изменен.")
            }
        } else {
            print("Задача не найдена.")
        }
    }
    
    func filterTasks(by category: TaskCategory) -> [Task] {
        tasks.filter {task in
            task.category == category && !task.isCompleted
        }
    }
    
    func seedtasks() {
        addTask(title: "Подготовить отчёт", category: .work, showMessage: false)
        addTask(title: "Проверить рабочую почту", category: .work, showMessage: false)
        addTask(title: "Выполнить домашнее задание по физике", category: .study, showMessage: false)
        addTask(title: "Повторить уравнение Шредингера", category: .study, showMessage: false)
        addTask(title: "Купить продукты", category: .personal, showMessage: false)
        addTask(title: "Сходить на тренировку", category: .personal, showMessage: false)
        
        if let task = tasks.first(where: { $0.title == "Проверить рабочую почту" }) {
            toggleTaskCompletion(by: task.id, showMessage: false)
        }

        print("Начальные задачи загружены.")

    }
}

func readInt(prompt: String) -> Int? {
    print(prompt, terminator: " ")
    guard let input = readLine(),
          let number = Int(input) else {
        print("Ошибка: введите целое число.")
        return nil
    }
    return number
}

func printTasks(_ tasks: [Task]) {
    if tasks.isEmpty {
        print("Список задач пуст.")
        return
    }
    
    for (index, task) in tasks.enumerated() {
        let status = task.isCompleted ? "Выполнена" : "Не выполнена"
        print("""
            \(index + 1). \(task.title)
                Категория: \(task.category.rawValue)
                Статус: \(status)
            """)
    }
}

func chooseCategory() -> TaskCategory? {
    print("""
        
        Выберите категорию:
        1. Работа
        2. Учеба
        3. Личное
        """)
    
    guard let choice = readInt(prompt: "Ваш выбор:") else {
        return nil
    }
    
    switch choice {
    case 1:
        return .work
    case 2:
        return .study
    case 3:
        return .personal
    default:
        print("Некорректный номер категории.")
        return nil
    }
}

func addTask(to manager: TaskManager) {
    print("Введите название задачи:", terminator: " ")
    guard let title = readLine(),
          !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        print("Название задачи не может быть пустым.")
        return
    }
    guard let category = chooseCategory() else {
        return
    }
    manager.addTask(title: title, category: category)
}

func removeTask(from manager: TaskManager) {
    let tasks = manager.allTasks
    guard !tasks.isEmpty else {
        print("Удалять нечего: список задач пуст.")
        return
    }
    printTasks(tasks)
    guard let number = readInt(prompt: "Введите номер задачи для удаления:"), tasks.indices.contains(number - 1) else {
        print("Некорректный номер задачи.")
        return
    }
    
    manager.removeTask(by: tasks[number - 1].id)
}

func toggleTask(in manager: TaskManager) {
    let tasks = manager.allTasks
    guard !tasks.isEmpty else {
        print("Список задач пуст.")
        return
    }
    printTasks(tasks)
    guard let number = readInt(prompt: "Введите номер задачи:"), tasks.indices.contains(number - 1) else {
        print("Некорректный номер задачи.")
        return
    }
    manager.toggleTaskCompletion(by: tasks[number - 1].id)
}

func filterTasks(in manager: TaskManager) {
    guard let category = chooseCategory() else {
        return
    }
    let filteredTasks = manager.filterTasks(by: category)
    print("\nНевыполненные задачи категории «\(category.rawValue)»:")
    printTasks(filteredTasks)
}

// Главное меню

let manager = TaskManager()
manager.seedtasks()
var isRunning = true
while isRunning {
    print("""
        
        ==============================
                МЕНЕДЖЕР ЗАДАЧ
        ==============================
            1. Добавить задачу
            2. Удалить задачу
            3. Изменить статус задачи
            4. Фильтр невыполненных задач
            5. Показать все задачи
            0. Выход
        """)
    
    guard let choice = readInt(prompt: "Выберите действие:") else {
        continue
    }
    
    switch choice {
    case 1:
        addTask(to: manager)
    case 2:
        removeTask(from: manager)
    case 3:
        toggleTask(in: manager)
    case 4:
        filterTasks(in: manager)
    case 5:
        print("\nВсе задачи:")
        printTasks(manager.allTasks)
    case 0:
        isRunning = false
        print("Программа завершена.")
    default:
    print("Неизвестная команда. Попробуйте еще раз.")
    }
    
    if isRunning {
        print("\nНажмите Enter, чтобы продолжить.")
        _ = readLine()
    }
}
