import SwiftUI
import FSCalendar
import Shared

struct CustomCalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    let firstWorkoutDate: Date

    func makeUIView(context: Context) -> UIView {
        let parentView = UIView()
        
        // FSCalendar 설정
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // Coordinator에서 calendar에 접근할 수 있도록 참조 저장
        context.coordinator.calendarView = calendar
        
        calendar.appearance.titleDefaultColor = UIColor(.basicColor)
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.todayColor = UIColor.purple.withAlphaComponent(0.5)
        calendar.appearance.titleTodayColor = UIColor(.basicColor)
        calendar.appearance.selectionColor = UIColor(Color.fitculatorLogo)
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.currentPage = selectedDate
        
        // yyyy년 mm월
        let titleLabel = UILabel()
        titleLabel.text = "2025년 2월"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        context.coordinator.titleLabel = titleLabel
        context.coordinator.updateTitleLabel()
        
        // 이전 버튼
        let previousButton = UIButton(type: .system)
        previousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        previousButton.addTarget(context.coordinator, action: #selector(Coordinator.goToPreviousMonth), for: .touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false

        // 다음 버튼
        let nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.addTarget(context.coordinator, action: #selector(Coordinator.goToNextMonth), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(titleLabel)
        parentView.addSubview(previousButton)
        parentView.addSubview(nextButton)
        parentView.addSubview(calendar)
        
        // 제약 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            
            previousButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10),
            
            nextButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
         
            calendar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        return parentView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let calendarView = context.coordinator.calendarView {
            calendarView.setCurrentPage(selectedDate, animated: false)
            context.coordinator.updateTitleLabel()
            calendarView.reloadData()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: CustomCalendarView
        weak var calendarView: FSCalendar?
        weak var titleLabel: UILabel?

        init(_ parent: CustomCalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            calendar.reloadData()
        }
        
        // 선택한 날짜가 속한 주의 배경색 변경
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
            let calendar = Calendar.current
            let selectedWeek = calendar.component(.weekOfYear, from: parent.selectedDate)
            let currentWeek = calendar.component(.weekOfYear, from: date)
            
            if selectedWeek == currentWeek {
                return UIColor(Color.fitculatorLogo.opacity(0.8))
            }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
            return nil
        }
        
        // 선택 안되는 날짜 색상 변경
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            // 미래 날짜
            let today = Date()
            let calendar = Calendar.current
            
            guard let startOfThisWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)),
                  let endOfThisWeek = calendar.date(byAdding: .day, value: 6, to: startOfThisWeek)
            else { return nil }
            
            if date > endOfThisWeek {
                return UIColor(Color.disabledColor)
            }
            
            // 최초 운동 기록 이전 날짜
            guard let startOfFirstDataWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: parent.firstWorkoutDate)) else { return nil }
            
            if date < startOfFirstDataWeek {
                return UIColor(Color.disabledColor)
            }
            
            return nil
        }
        
        // 선택 안되는 날짜
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            // 미래 날짜
            let today = Date()
            let calendar = Calendar.current
            
            guard let startOfThisWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)),
                  let endOfThisWeek = calendar.date(byAdding: .day, value: 6, to: startOfThisWeek)
            else { return false }
            
            if date > endOfThisWeek {
                return false
            }
            
            // 최초 운동 기록 이전 날짜
            guard let startOfFirstDataWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: parent.firstWorkoutDate)) else { return false }
            
            if date < startOfFirstDataWeek {
                return false
            }
            
            return true
        }
        
        @objc func goToPreviousMonth() {
            guard let calendarView = calendarView else { return }
            let currentPage = calendarView.currentPage
            if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage) {
                calendarView.setCurrentPage(previousMonth, animated: true)
                updateTitleLabel()
            }
        }

        @objc func goToNextMonth() {
            guard let calendarView = calendarView else { return }
            let currentPage = calendarView.currentPage
            if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage) {
                calendarView.setCurrentPage(nextMonth, animated: true)
                updateTitleLabel()
            }
        }
        
        func updateTitleLabel() {
            guard let calendarView = calendarView, let titleLabel = titleLabel else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월"
            DispatchQueue.main.async {
                titleLabel.text = dateFormatter.string(from: calendarView.currentPage)
            }
        }
    }
}
