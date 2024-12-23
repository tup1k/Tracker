//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Олег Кор on 22.12.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image)
    }
    
    func testViewControllerLight() {
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDark() {
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    

}
