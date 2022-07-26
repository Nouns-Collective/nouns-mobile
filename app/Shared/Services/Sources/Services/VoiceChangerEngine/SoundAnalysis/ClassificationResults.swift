// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Foundation
import SoundAnalysis
import Combine

/// An observer that forwards Sound Analysis results to a combine subject.
///
/// Sound Analysis emits classification outcomes to observer objects. When classification completes, an
/// observer receives termination messages that indicate the reason. A subscriber receives a stream of
/// results and a termination message with an error, if necessary.
class ClassificationResults: NSObject, SNResultsObserving {
  private let subject: PassthroughSubject<SNClassificationResult, Error>
  
  init(subject: PassthroughSubject<SNClassificationResult, Error>) {
    self.subject = subject
  }
  
  func request(_ request: SNRequest, didFailWithError error: Error) {
    subject.send(completion: .failure(error))
  }
  
  func requestDidComplete(_ request: SNRequest) {
    subject.send(completion: .finished)
  }
  
  func request(_ request: SNRequest, didProduce result: SNResult) {
    if let result = result as? SNClassificationResult {
      subject.send(result)
    }
  }
}
