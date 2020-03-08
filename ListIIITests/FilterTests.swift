//
//  FilterTests.swift
//  ListIIITests
//
//  Created by Edan on 3/5/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import XCTest
@testable import ListIII

private struct Result: Equatable {
    let appliedTags: [String]
    let pendingTags: [String]?
    let appliedIntersection: [String]?
    let pendingIntersection: [String]?
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.appliedTags == rhs.appliedTags && lhs.pendingTags == rhs.pendingTags && lhs.appliedIntersection == rhs.appliedIntersection && lhs.pendingIntersection == rhs.pendingIntersection
    }
    
    var description: String {
        return "Applied Tags: \(appliedTags) \n Pending Tags: \(pendingTags ?? nil) \n Applied Intersection: \(appliedIntersection ?? nil) \n Pending Intersection: \(pendingIntersection ?? nil)"
    }
}

class FilterTests: XCTestCase {

    var taskFilter = TaskFilter2()
    
    override func setUp() {
        TestUtilities.setupDB(from: "TestTasks")
    }

    override func tearDown() {
        taskFilter = TaskFilter2()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testAddTagsNoApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        
        let expectedResult = Result(appliedTags: [], pendingTags: ["T1", "T3"], appliedIntersection: nil, pendingIntersection: ["Task_1", "Task_2"])
        let actualResult = getActualResult(for: taskFilter)
        
        XCTAssert(expectedResult == actualResult, actualResult.description)
        
    }
    
    func testAddTagsAndApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.applyFilter()
        let expectedResult = Result(appliedTags: ["T1", "T3"], pendingTags: nil, appliedIntersection: ["Task_1", "Task_2"], pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddAndRemoveTagsNoApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        
        let expectedResult = Result(appliedTags: [], pendingTags: ["T1"], appliedIntersection: nil, pendingIntersection: ["Task_1", "Task_2"])
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddAnRemoveTagsAndApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        taskFilter.applyFilter()
        
        let expectedResult = Result(appliedTags: ["T1"], pendingTags: nil, appliedIntersection: ["Task_1", "Task_2"] , pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddAndRemoveUntilEmptyNoApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        taskFilter.removeTag(withName: "T1")

        
        let expectedResult = Result(appliedTags: [], pendingTags: [], appliedIntersection: nil, pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddAndRemoveTagsUntilEmptyAndApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        taskFilter.removeTag(withName: "T1")
        taskFilter.applyFilter()
        
        let expectedResult = Result(appliedTags: [], pendingTags: nil, appliedIntersection: nil, pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddAndApplyThenRemoveUntilEmpty() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.applyFilter()
        taskFilter.removeTag(withName: "T3")
        taskFilter.removeTag(withName: "T1")
        let expectedResult = Result(appliedTags: ["T1", "T3"], pendingTags: [], appliedIntersection: ["Task_1", "Task_2"], pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddAndApplyThenRemoveUntilEmptyAndApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.applyFilter()
        taskFilter.removeTag(withName: "T3")
        taskFilter.removeTag(withName: "T1")
        taskFilter.applyFilter()
        
        let expectedResult = Result(appliedTags: [], pendingTags: nil, appliedIntersection: nil, pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testRemoveBeyondEmpty() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.applyFilter()
        taskFilter.removeTag(withName: "T1")
        taskFilter.removeTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        taskFilter.applyFilter()
        
        let expectedResult = Result(appliedTags: [], pendingTags: nil, appliedIntersection: nil, pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
        
    }
    
    func testAddSameTagTwice() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T1")
        
        let expectedResult = Result(appliedTags: [], pendingTags: ["T1"], appliedIntersection: nil, pendingIntersection: ["Task_1", "Task_2"])
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testCancel() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.cancelFilter()
        
        let expectedResult = Result(appliedTags: [], pendingTags: nil, appliedIntersection: nil, pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddRemoveAddNoApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        taskFilter.appendTag(withName: "T3")
        
        let expectedResult = Result(appliedTags: [], pendingTags: ["T1", "T3"], appliedIntersection: nil, pendingIntersection: ["Task_1", "Task_2"])
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
    }
    
    func testAddRemoveAddAndApply() {
        taskFilter.appendTag(withName: "T1")
        taskFilter.appendTag(withName: "T3")
        taskFilter.removeTag(withName: "T3")
        taskFilter.appendTag(withName: "T3")
        taskFilter.applyFilter()
        
        let expectedResult = Result(appliedTags: ["T1", "T3"], pendingTags: nil , appliedIntersection: ["Task_1", "Task_2"], pendingIntersection: nil)
        let actualResult = getActualResult(for: taskFilter)
        XCTAssert(expectedResult == actualResult, actualResult.description)
        
    }
    
    private func getActualResult(for filter: TaskFilter2) -> Result {
        let appliedTags = filter.appliedTags.map({$0.name!})
        let pendingTags = filter.pendingTags?.map({$0.name!})
        let appliedIntersection = filter.appliedIntersection?.map({$0.taskName!}).sorted(by: < )
        let pendingIntersection = filter.pendingIntersection?.map({$0.taskName!}).sorted(by: < )
        
        return Result(appliedTags: appliedTags, pendingTags: pendingTags, appliedIntersection: appliedIntersection, pendingIntersection: pendingIntersection)
    }

}
