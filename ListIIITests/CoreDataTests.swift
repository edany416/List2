//
//  CoreDataTests.swift
//  ListIIITests
//
//  Created by Edan on 3/10/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import XCTest
@testable import ListIII

class CoreDataTests: XCTestCase {

    var didLoadData = false
    override func setUp() {
        if !didLoadData {
            TestUtilities.setupDB(from: "TestTasks")
            didLoadData = true
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    /********** Fetch tasks for tags test **********/
    
    func testFetchTaskForSingleTag() {
        let T2 = Tag(context: PersistanceManager.instance.context)
        T2.name = "T2"
        let tasks = PersistanceManager.instance.fetchTasks(for: [T2])
        let expected = ["Task_1", "Task_3"]
        testResult(expected: expected, actual: tasks)
    }
    
    func testFetchTasksForMultipleTags() {
        let T1 = Tag(context: PersistanceManager.instance.context)
        T1.name = "T1"
        let T3 = Tag(context: PersistanceManager.instance.context)
        T3.name = "T3"
        let tasks = PersistanceManager.instance.fetchTasks(for: [T1,T3])
        let expected = ["Task_1", "Task_2"]
        testResult(expected: expected, actual: tasks)
    }
    
    func testFetchTasksForMultipleTagsWithNoIntersection() {
        let T1 = Tag(context: PersistanceManager.instance.context)
        T1.name = "T1"
        let T3 = Tag(context: PersistanceManager.instance.context)
        T3.name = "T3"
        let T6 = Tag(context: PersistanceManager.instance.context)
        T6.name = "T6"
        let tasks = PersistanceManager.instance.fetchTasks(for: [T1,T3, T6])
        let expected: [String] = []
        testResult(expected: expected, actual: tasks)
    }
    
    func testEmptyFetch() {
        let tasks = PersistanceManager.instance.fetchTasks(for: [])
        testResult(expected: [], actual: tasks)
    }
    
    func appendTagToTask() {
        
    }
    
    func testResult(expected: [String], actual: [Task]) {
        var actualString: [String]? =  nil
        actualString = actual.map({$0.taskName!}).sorted(by: < )
        
        
        XCTAssert(expected == actualString, "\(String(describing: actualString))")
    }
}
