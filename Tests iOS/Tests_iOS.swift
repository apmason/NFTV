//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Alexander Mason on 10/22/21.
//

import XCTest
import NFTV

class Tests_iOS: XCTestCase {

    func testDisplayableAddress() throws {
        let account = OpenSeaAccount(address: "0x51906b344eae66a8bc3db3efb2da3d79507aa06e")
        XCTAssert(account.displayableAddress == "0x5190...a06e")
    }
}
