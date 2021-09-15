//
//  TranslateServiceTest.swift
//  MonBaluchonAppTests
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

import XCTest
@testable import MonBaluchonApp

class TranslateServiceTest: XCTestCase {
    func testGetTranslate_WhenAnErrorIsPassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        let service = TranslateService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getTranslation(text: ""){ result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslate_WhenCorrectDataAndBadResponseArePassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseKO, error: nil)
        let service = TranslateService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getTranslation(text: "" ){ result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .badResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslate_WhenIncorrectDataAndGoodResponseArePassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = TranslateService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getTranslation(text: "") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslate_WhenCorrectDataAndGoodResponseArePassed_ThenShouldACorrectResult() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = TranslateService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getTranslation(text:"") { result in
            guard case .success(let translate) = result else { return }
            XCTAssertEqual(translate, "")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
