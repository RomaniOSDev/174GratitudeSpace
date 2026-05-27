import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: GratitudeSpaceViewModel

    @State private var displayedMonth = Date()
    @State private var selectedDate: Date?
    @State private var selectedEntry: GratitudeEntry?

    private let weekdaySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    monthSummaryCard
                    calendarCard
                    selectedDaySection
                }
                .padding(.vertical, 12)
                .padding(.bottom, 24)
            }
            .gardenScreenBackground()
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedEntry) { entry in
                EntryDetailView(viewModel: viewModel, entry: entry)
            }
        }
    }

    private var monthSummaryCard: some View {
        HStack(spacing: 16) {
            GardenIconCircle(systemName: "calendar", color: .gardenNew, size: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text(DateFormatting.monthYearString(from: displayedMonth))
                    .font(.headline)
                    .foregroundColor(.gardenBloom)
                Text("\(entriesInDisplayedMonth) entries this month")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .gardenCard()
        .padding(.horizontal, GardenDesign.padding)
    }

    private var entriesInDisplayedMonth: Int {
        viewModel.entries.filter {
            calendar.isDate($0.date, equalTo: displayedMonth, toGranularity: .month)
        }.count
    }

    private var calendarCard: some View {
        VStack(spacing: 14) {
            HStack {
                monthNavButton(systemName: "chevron.left", action: previousMonth)
                Spacer()
                Text(DateFormatting.monthYearString(from: displayedMonth))
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.gardenBloom)
                Spacer()
                monthNavButton(systemName: "chevron.right", action: nextMonth)
            }

            HStack {
                ForEach(weekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date {
                        CalendarDayCell(
                            date: date,
                            hasEntry: viewModel.hasEntry(on: date),
                            entryCount: viewModel.entryCount(on: date),
                            heatLevel: viewModel.heatLevel(for: date),
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate ?? .distantPast),
                            isToday: calendar.isDateInToday(date)
                        )
                        .onTapGesture { selectedDate = date }
                    } else {
                        Color.clear.aspectRatio(1, contentMode: .fit)
                    }
                }
            }

            HStack(spacing: 16) {
                heatLegend(opacity: 0.1, label: "Low")
                heatLegend(opacity: 0.35, label: "High")
            }
            .font(.caption2)
            .foregroundColor(.gray)
        }
        .gardenCard()
        .padding(.horizontal, GardenDesign.padding)
    }

    private func monthNavButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.body.weight(.semibold))
                .foregroundColor(.gardenNew)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.gardenNew.opacity(0.12)))
        }
    }

    private func heatLegend(opacity: Double, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gardenNew.opacity(opacity))
                .frame(width: 16, height: 10)
            Text(label)
        }
    }

    @ViewBuilder
    private var selectedDaySection: some View {
        if let selectedDate {
            VStack(alignment: .leading, spacing: 14) {
                GardenSectionHeader(
                    title: DateFormatting.formattedDate(selectedDate),
                    subtitle: "\(viewModel.entryCount(on: selectedDate)) entries"
                )

                let dayEntries = viewModel.entriesOnDate(selectedDate)
                if dayEntries.isEmpty {
                    emptyDayCell
                } else {
                    ForEach(dayEntries) { entry in
                        EntryListCell(entry: entry)
                            .onTapGesture { selectedEntry = entry }
                    }
                }
            }
            .padding(.horizontal, GardenDesign.padding)
        }
    }

    private var emptyDayCell: some View {
        VStack(spacing: 10) {
            Image(systemName: "leaf")
                .font(.largeTitle)
                .foregroundColor(.gardenNew.opacity(0.35))
            Text("No entries for this day")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .gardenCard()
    }

    private var daysInMonth: [Date?] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)),
              let dayRange = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }

        let weekday = calendar.component(.weekday, from: monthStart)
        let offset = (weekday - calendar.firstWeekday + 7) % 7
        var days: [Date?] = Array(repeating: nil, count: offset)
        for day in dayRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        while days.count % 7 != 0 { days.append(nil) }
        return days
    }

    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = newDate
        }
    }

    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = newDate
        }
    }
}
