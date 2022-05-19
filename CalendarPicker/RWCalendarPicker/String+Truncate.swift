

import Foundation

extension String {
  func truncatedPrefix(_ maxLength: Int, using truncator: String = "...") -> String {
    "\(prefix(maxLength))\(truncator)"
  }
}
