

import UIKit

class ItemDetailViewController: UITableViewController {
  lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    return dateFormatter
  }()

  let item: ChecklistItem

  init(item: ChecklistItem) {
    self.item = item

    super.init(style: .insetGrouped)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemGroupedBackground

    title = String(item.title.truncatedPrefix(16))

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")

    if indexPath.row == 0 {
      cell.textLabel?.text = "Task Name"
      cell.detailTextLabel?.text = item.title
    } else {
      cell.textLabel?.text = "Due Date"
      cell.detailTextLabel?.text = dateFormatter.string(from: item.date)
    }

    cell.accessoryType = .disclosureIndicator

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if indexPath.row == 0 {
      let changeTaskNameAlert = UIAlertController(
        title: "Edit Name",
        message: "What should this task be called?",
        preferredStyle: .alert)
      changeTaskNameAlert.addTextField { [weak self] textField in
        guard let self = self else { return }

        textField.text = self.item.title
        textField.placeholder = "Task Name"
      }
      changeTaskNameAlert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
        guard let self = self else { return }

        guard
          let newTitle = changeTaskNameAlert.textFields?[0].text,
          !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
          else {
          return
        }

        self.item.title = newTitle
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
      })

      changeTaskNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      present(changeTaskNameAlert, animated: true, completion: nil)
    } else if indexPath.row == 1 {
      let pickerController = CalendarPickerViewController(
        baseDate: item.date,
        selectedDateChanged: { [weak self] date in
        guard let self = self else { return }

        self.item.date = date
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        })

      present(pickerController, animated: true, completion: nil)
    }
  }
}
