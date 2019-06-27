defmodule ExIcalYearlyTest do
  use ExUnit.Case
  alias ExIcal.DateParser

  doctest ExIcal

  test "yearly reccuring event with until" do
    ical = """
    BEGIN:VCALENDAR
    CALSCALE:GREGORIAN
    VERSION:2.0
    BEGIN:VEVENT
    RRULE:FREQ=YEARLY;UNTIL=20201224T083000Z
    DESCRIPTION:A Holiday Tradition
    DTEND:20151224T084500Z
    DTSTART:20151224T083000Z
    SUMMARY:Film with Amy and Adam
    END:VEVENT
    END:VCALENDAR
    """
    events =
      ical
      |> ExIcal.parse()
      |> ExIcal.by_range(
        DateParser.parse("20151224T083000Z"),
        DateParser.parse("20201224T084500Z")
      )
    assert events |> Enum.count == 6

    event_starts = Enum.map(events, & &1.start)
    assert event_starts == [
      "20151224T083000Z",
      "20161224T083000Z",
      "20171224T083000Z",
      "20181224T083000Z",
      "20191224T083000Z",
      "20201224T083000Z",
    ] |> Enum.map(&DateParser.parse/1)
  end

  test "yearly recurring event" do
    ical = """
    BEGIN:VCALENDAR
    CALSCALE:GREGORIAN
    VERSION:2.0
    BEGIN:VEVENT
    RRULE:FREQ=YEARLY
    DESCRIPTION:A Holiday Tradition
    DTEND:20151224T084500Z
    DTSTART:20151224T083000Z
    SUMMARY:Film with Amy and Adam
    END:VEVENT
    END:VCALENDAR
    """
    events =
      ical
      |> ExIcal.parse()
      |> ExIcal.by_range(
        DateParser.parse("20151224T083000Z"),
        DateParser.parse("20171225T083000Z")
      )
    assert events |> Enum.count == 3

    event_starts = Enum.map(events, & &1.start)
    assert event_starts == [
      "20151224T083000Z",
      "20161224T083000Z",
      "20171224T083000Z",
    ] |> Enum.map(&DateParser.parse/1)
  end

  test "yearly reccuring event with until and interval" do
    ical = """
    BEGIN:VCALENDAR
    CALSCALE:GREGORIAN
    VERSION:2.0
    BEGIN:VEVENT
    RRULE:FREQ=YEARLY;UNTIL=20251224T083000Z;INTERVAL=2
    DESCRIPTION:A Holiday Tradition
    DTEND:20151224T084500Z
    DTSTART:20151224T083000Z
    SUMMARY:Film with Amy and Adam
    END:VEVENT
    END:VCALENDAR
    """
    events =
      ical
      |> ExIcal.parse()
      |> ExIcal.by_range(
        DateParser.parse("20151224T083000Z"),
        DateParser.parse("20251224T084500Z")
      )
    assert events |> Enum.count == 6
  end

  test "yearly reccuring event with count" do
    ical = """
    BEGIN:VCALENDAR
    CALSCALE:GREGORIAN
    VERSION:2.0
    BEGIN:VEVENT
    RRULE:FREQ=YEARLY;COUNT=5
    DESCRIPTION:A Holiday Tradition
    DTEND:20151224T084500Z
    DTSTART:20151224T083000Z
    SUMMARY:Film with Amy and Adam
    END:VEVENT
    END:VCALENDAR
    """
    events =
      ical
      |> ExIcal.parse()
      |> ExIcal.by_range(
        DateParser.parse("20151224T083000Z"),
        DateParser.parse("20251224T084500Z")
      )
    assert events |> Enum.count == 6

    event_starts = Enum.map(events, & &1.start)
    assert event_starts == [
      "20151224T083000Z",
      "20161224T083000Z",
      "20171224T083000Z",
      "20181224T083000Z",
      "20191224T083000Z",
      "20201224T083000Z",
    ] |> Enum.map(&DateParser.parse/1)
  end

  test "yearly reccuring event with count and interval" do
    ical = """
    BEGIN:VCALENDAR
    CALSCALE:GREGORIAN
    VERSION:2.0
    BEGIN:VEVENT
    RRULE:FREQ=YEARLY;COUNT=4;INTERVAL=8
    DESCRIPTION:A Holiday Tradition
    DTEND:20151224T084500Z
    DTSTART:20151224T083000Z
    SUMMARY:Film with Amy and Adam
    END:VEVENT
    END:VCALENDAR
    """
    events =
      ical
      |> ExIcal.parse()
      |> ExIcal.by_range(
        DateParser.parse("20151224T083000Z"),
        DateParser.parse("20501224T084500Z")
      )

    assert events |> Enum.count == 5

    event_starts = Enum.map(events, & &1.start)
    assert event_starts == [
      "20151224T083000Z",
      "20231224T083000Z",
      "20311224T083000Z",
      "20391224T083000Z",
      "20471224T083000Z",
    ] |> Enum.map(&DateParser.parse/1)
  end

  test "yearly reccuring event with interval" do
    ical = """
    BEGIN:VCALENDAR
    CALSCALE:GREGORIAN
    VERSION:2.0
    BEGIN:VEVENT
    RRULE:FREQ=YEARLY;INTERVAL=3
    DESCRIPTION:Let's go see Star Wars.
    DTEND:20151224T084500Z
    DTSTART:20151224T083000Z
    SUMMARY:Film with Amy and Adam
    END:VEVENT
    END:VCALENDAR
    """
    events =
      ical
      |> ExIcal.parse()
      |> ExIcal.by_range(
        DateParser.parse("20151224T083000Z"),
        DateParser.parse("20301224T084500Z")
      )
    assert events |> Enum.count == 6

    event_starts = Enum.map(events, & &1.start)
    assert event_starts == [
      "20151224T083000Z",
      "20181224T083000Z",
      "20211224T083000Z",
      "20241224T083000Z",
      "20271224T083000Z",
      "20301224T083000Z",
    ] |> Enum.map(&DateParser.parse/1)
  end
end
