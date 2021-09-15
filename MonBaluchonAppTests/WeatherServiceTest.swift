//
//  WeatherServiceTest.swift
//  MonBaluchonAppTests
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

import XCTest
@testable import MonBaluchonApp

class WeatherServiceTest: XCTestCase {
    func testGetWeather_WhenAnErrorIsPassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        let service = WeatherService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getWeather { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenCorrectDataAndBadResponseArePassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil)
        let service = WeatherService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getWeather { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .badResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenIncorrectDataAndGoodResponseArePassed_ThenShouldReturnAnError() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = WeatherService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getWeather { result in
            guard case .failure(let error) = result else { return }
            XCTAssertTrue(error == .undecodableData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenCorrectDataAndGoodResponseArePassed_ThenShouldACorrectResult() {
        let fakeSeesion = URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = WeatherService(session: fakeSeesion)
        
        let expectation = XCTestExpectation(description: "Waiting...")
        service.getWeather{ result in
            guard case .success(let weather) = result else { return }
            XCTAssertEqual(weather[0].weather[0].weatherDescription, "few clouds")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
