import XCTest
@testable import MTAFeed

final class MTAFeedProcessorTests: XCTestCase {
    private func makeFeed(_ entities: [TransitRealtime_FeedEntity]) -> TransitRealtime_FeedMessage {
        var feed = TransitRealtime_FeedMessage()
        feed.header.gtfsRealtimeVersion = "1.0"
        feed.header.timestamp = 1_793_000_000
        feed.entity = entities
        return feed
    }

    func testTripUpdateCarriesDirectionIdAndScheduleRelationship() {
        var entity = TransitRealtime_FeedEntity()
        entity.id = "1"
        entity.tripUpdate.trip.tripID = "CS_D6-Weekday-SDon-114500_M15_101"
        entity.tripUpdate.trip.routeID = "M15"
        entity.tripUpdate.trip.directionID = 1
        entity.tripUpdate.trip.scheduleRelationship = .canceled
        var stu = TransitRealtime_TripUpdate.StopTimeUpdate()
        stu.stopID = "401234"
        stu.arrival.time = 1_793_000_300
        entity.tripUpdate.stopTimeUpdate = [stu]

        let wrapper = MTAFeedProcessor.shared.process(makeFeed([entity]))
        let trip = wrapper.tripUpdatesByTripId["CS_D6-Weekday-SDon-114500_M15_101"]?.first?.trip

        XCTAssertEqual(trip?.routeId, "M15")
        XCTAssertEqual(trip?.directionId, 1)
        XCTAssertEqual(trip?.scheduleRelationship, .canceled)
        XCTAssertEqual(trip?.isCanceled, true)
    }

    func testTripWithoutOptionalFieldsLeavesThemNil() {
        var entity = TransitRealtime_FeedEntity()
        entity.id = "1"
        entity.tripUpdate.trip.tripID = "T1"

        let trip = MTAFeedProcessor.shared.process(makeFeed([entity])).tripUpdatesByTripId["T1"]?.first?.trip

        XCTAssertNil(trip?.directionId)
        XCTAssertNil(trip?.scheduleRelationship)
        XCTAssertEqual(trip?.isCanceled, false)
    }

    func testVehicleCarriesOccupancyStatus() {
        var entity = TransitRealtime_FeedEntity()
        entity.id = "MTA NYCT_1234"
        entity.vehicle.stopID = "401234"
        entity.vehicle.trip.tripID = "T1"
        entity.vehicle.occupancyStatus = .standingRoomOnly

        let vehicle = MTAFeedProcessor.shared.process(makeFeed([entity])).vehiclesByStopId["401234"]?.first

        XCTAssertEqual(vehicle?.occupancyStatus, .standingRoomOnly)
    }

    func testBusAlertKeepsEffectEntitiesAndPeriods() {
        var entity = TransitRealtime_FeedEntity()
        entity.id = "MTA NYCT_lmm:alert:123"

        var header = TransitRealtime_TranslatedString.Translation()
        header.text = "B44 SBS: trip canceled"
        header.language = "en"
        var description = TransitRealtime_TranslatedString.Translation()
        description.text = "<p>Details</p>"
        entity.alert.headerText.translation = [header]
        entity.alert.descriptionText.translation = [description]
        entity.alert.effect = .reducedService

        var routeSelector = TransitRealtime_EntitySelector()
        routeSelector.agencyID = "MTA NYCT"
        routeSelector.routeID = "B44+"
        var tripSelector = TransitRealtime_EntitySelector()
        tripSelector.agencyID = "MTA NYCT"
        tripSelector.trip.tripID = "FB_D6-Weekday-SDon-114500_B44+_101"
        tripSelector.trip.routeID = "B44+"
        entity.alert.informedEntity = [routeSelector, tripSelector]

        var period = TransitRealtime_TimeRange()
        period.start = 1_793_000_000
        period.end = 1_793_003_600
        entity.alert.activePeriod = [period]

        let alert = MTAFeedProcessor.shared.process(makeFeed([entity])).alerts.first

        XCTAssertEqual(alert?.id, "MTA NYCT_lmm:alert:123")
        XCTAssertEqual(alert?.headerText, "B44 SBS: trip canceled")
        XCTAssertEqual(alert?.descriptionText, "<p>Details</p>")
        XCTAssertEqual(alert?.effect, .reducedService)
        XCTAssertNil(alert?.cause)
        XCTAssertEqual(alert?.informedEntities.count, 2)
        XCTAssertEqual(alert?.informedEntities.first?.agencyId, "MTA NYCT")
        XCTAssertEqual(alert?.routeIds, ["B44+"])
        XCTAssertEqual(alert?.tripIds, ["FB_D6-Weekday-SDon-114500_B44+_101"])
        XCTAssertEqual(alert?.delayedTrips.count, 0)
        XCTAssertEqual(alert?.isActive(at: Date(timeIntervalSince1970: 1_793_001_000)), true)
        XCTAssertEqual(alert?.isActive(at: Date(timeIntervalSince1970: 1_793_010_000)), false)
    }

    func testAlertWithoutPeriodsIsAlwaysActive() {
        XCTAssertTrue(MTAAlert(delayedTrips: [], headerText: "", date: Date()).isActive())
    }
}
