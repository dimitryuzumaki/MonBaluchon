//
//  CurrencyServiceTest.swift
//  MonBaluchonAppTests
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

import XCTest
@testable import MonBaluchonApp

class CurrencyServiceTests: XCTestCase {

    
    func testGetRate_WhenAnErrorIsPassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        let service = CurrencyService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getRate { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRate_WhenCorrectDataAndBadResponseArePassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.exchengeCorrectData, response: FakeResponseData.responseKO, error: nil)
        let service = CurrencyService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getRate { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .badResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRate_WhenIncorrectDataAndGoodResponseArePassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = CurrencyService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getRate { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRate_WhenCorrectDataAndGoodResponseArePassed_ThenShouldACorrectResult() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.exchengeCorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = CurrencyService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getRate { result in
            guard case .success(let rate) = result else { return }
            XCTAssertEqual(rate, 1.181133)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
