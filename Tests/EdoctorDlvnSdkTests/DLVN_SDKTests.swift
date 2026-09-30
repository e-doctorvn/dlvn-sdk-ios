import XCTest
@testable import EdoctorDlvnSdk

final class DLVN_SDKTests: XCTestCase {
    func testNewEnvironmentURLs() {
        let previousEnv = env
        defer { env = previousEnv }

        env = .SANDBOX
        XCTAssertEqual(getDomain(), "khuat.daiichilife.com.vn")
        XCTAssertEqual(getUrlDefault(), "https://khuat.daiichilife.com.vn/tu-van-suc-khoe")
        env = .LIVE
        XCTAssertEqual(getDomain(), "kh.daiichilife.com.vn")
        XCTAssertEqual(getUrlDefault(), "https://kh.daiichilife.com.vn/tu-van-suc-khoe")
        XCTAssertEqual(targetVersionBooking, "14.3")
    }

    func testInternalDaiichiHosts() throws {
        for value in [
            "https://daiichilife.com.vn",
            "https://kh.daiichilife.com.vn/tu-van-suc-khoe",
            "https://khuat.daiichilife.com.vn:8082/tu-van-suc-khoe",
            "https://campaign.daiichilife.com.vn/gioi-thieu",
            "https://nested.kh.daiichilife.com.vn/path?mode=rating#section",
            "HTTPS://KH.DAIICHILIFE.COM.VN/tu-van-suc-khoe",
            "http://kh.daiichilife.com.vn/tu-van-suc-khoe",
        ] {
            XCTAssertTrue(isInternalDaiichiURL(try XCTUnwrap(URL(string: value))), value)
        }
    }

    func testExternalAndSpoofedURLs() throws {
        for value in [
            "https://example.com/tu-van-suc-khoe",
            "https://example.com/?next=https://kh.daiichilife.com.vn/tu-van-suc-khoe",
            "https://example.com/#https://kh.daiichilife.com.vn",
            "https://daiichilife.com.vn.evil.example/tu-van-suc-khoe",
            "https://kh.daiichilife.com.vn.evil.example",
            "https://evildaiichilife.com.vn",
            "https://evil-daiichilife.com.vn",
            "https://kh.daiichilife.com.vn@evil.example/tu-van-suc-khoe",
            "https://kh.dai-ichi-life.com.vn/tu-van-suc-khoe",
            "https://khuat.dai-ichi-life.com.vn/tu-van-suc-khoe",
            "https://127.0.0.1/tu-van-suc-khoe",
            "https://[::1]/tu-van-suc-khoe",
            "mailto:contact@daiichilife.com.vn",
            "tel:02838100888",
            "javascript:alert('daiichilife.com.vn')",
            "file://kh.daiichilife.com.vn/tu-van-suc-khoe",
            "/tu-van-suc-khoe",
        ] {
            XCTAssertFalse(isInternalDaiichiURL(try XCTUnwrap(URL(string: value))), value)
        }
    }
}
