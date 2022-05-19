

import UIKit

class CalendarPickerViewController: UIViewController {
  // MARK: Views
  private lazy var dimmedBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    return view
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  private lazy var headerView = CalendarPickerHeaderView { [weak self] in
    guard let self = self else { return }
    self.dismiss(animated: true)
  }
  
  private lazy var footerView = CalendarPickerFooterView(
    didTapLastMonthCompletionHandler: { [weak self] in
      guard let self = self else { return }
      self.baseDate = self.calendar.date(byAdding: .month,
                                         value: -1,
                                         to: self.baseDate) ?? self.baseDate
    }, didTapNextMonthCompletionHandler: { [weak self] in
      guard let self = self else { return }
      
      self.baseDate = self.calendar.date(byAdding: .month,
                                         value: 1,
                                         to: self.baseDate) ?? self.baseDate
    })

  // MARK: Calendar Data Values
  
  private let calendar = Calendar(identifier: .gregorian)
  
  private let selectedDate: Date
  
  private var baseDate: Date {
    didSet {
      days = generateDaysInMonth(for: baseDate)
      collectionView.reloadData()
      headerView.baseDate = baseDate
    }
  }
  
  private lazy var days = generateDaysInMonth(for: baseDate)
  
  private var numberOfWeeksInBaseDate: Int {
    calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
  }

  private let selectedDateChanged: ((Date) -> Void)

  private lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()

  // MARK: Initializers

  init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
    self.selectedDate = baseDate
    self.baseDate = baseDate
    self.selectedDateChanged = selectedDateChanged

    super.init(nibName: nil, bundle: nil)

    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
    definesPresentationContext = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .systemGroupedBackground
    
    view.addSubview(dimmedBackgroundView)
    view.addSubview(collectionView)
    view.addSubview(headerView)
    view.addSubview(footerView)

    NSLayoutConstraint.activate([
      dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
      collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
      collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
    ])
    
    NSLayoutConstraint.activate([
      headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 85),
      
      footerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
      footerView.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    collectionView.register(CalendarDateCollectionViewCell.self, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    headerView.baseDate = baseDate
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    collectionView.reloadData()
  }
}

// MARK: - Day Generation

private extension CalendarPickerViewController {
  
  enum CalendarDataError: Error {
    case metadataGeneration
  }
  
  func monthMetadata(for baseData: Date) throws -> MonthMetadata {
    // Ask the calendar for the number of days in "baseDate" months
    guard let numberOfDaysInMonth = calendar.range(of: .day,
                                                   in: .month,
                                                   for: baseData)?.count,
          let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month],
                                                                            from: baseData))
    else {
      // Both of the previus calls return optional values. If either return nil, the code throws an error and returns
      throw CalendarDataError.metadataGeneration
    }
    
    // get the weekday value, a number between one and seven that represents which day of the week the first day of the month falls on
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
    
    // Use these values to create an instance of MonthMetadata and return it
    return MonthMetadata(numberOfDays: numberOfDaysInMonth,
                         firstDay: firstDayOfMonth,
                         firstDayWeekday: firstDayWeekday)
  }
  
  // takes in a Date and returns an array of Days
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    // Retrieve the meradata you need about the month
    guard let metadata = try? monthMetadata(for: baseDate)
    else {
      fatalError("an error occured when generating the metadata for \(baseDate)")
    }
    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay
    
    // if a month starts on a day other tha Sunday, you add the last few days from the previus month at the beginning
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        // check if the current day in the loop is within the current month or part of the previus month
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        // calculate the offset that day is from the first day of the month. If day is in previus month, this value will be negative
        let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow: -(offsetInInitialRow - day)
        
        // Call generateDay, which adds or subtracts an offset from a Date to produce a new one and return its result
        return generateDay(offsetBy: dayOffset,
                           for: firstDayOfMonth,
                           isWithinDisplayedMonth: isWithinDisplayedMonth)
      }
    days += generateStartOfNextMonth(using: firstDayOfMonth)
    return days
  }

  func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
    let date = calendar.date(byAdding: .day,
                             value: dayOffset,
                             to: baseDate) ?? baseDate
    
    return Day(
        date: date,
        number: dateFormatter.string(from: date),
        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
        isWithinDisplayedMonth: isWithinDisplayedMonth
      )
  }
    // takes the first day of the displayed month and returns an array of Day objects
  func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
    // retrieve the last day of the displayed month. If this fails you return an empty array
    guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1),
                                             to: firstDayOfDisplayedMonth) else { return [] }
    
    // Calculate the number of extra days you need to fill the last row of the calendar
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }
    
    // adds the current day in the loop to lastDayInMonth to generate the days at the beginning of the next month
    let days: [Day] = (1...additionalDays)
      .map {
        generateDay(offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
      }
    return days
  }
}

// MARK: - UICollectionViewDataSource

extension CalendarPickerViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    days.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let day = days[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier, for: indexPath) as! CalendarDateCollectionViewCell
    
    cell.day = day
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let day = days[indexPath.row]
    selectedDateChanged(day.date)
    dismiss(animated: true, completion: nil)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
    return CGSize(width: width, height: height)
  }
}
